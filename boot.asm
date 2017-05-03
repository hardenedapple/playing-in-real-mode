; There are three different things it's interesting to do with this example
; file.
;   1) While in protected mode, use a segment register that was set in real-mode, 
;       This demonstrates that the way a segment register is used is not
;       changed by moving from real-mode to protected mode until the segment
;       register is *set* while in protected mode.
;
;       Observation: 'H' printed on second line
;       vimcmd; +1,$g/demo1 codestart/+1,/demo1 codeend/-1Commentary
;
;   2) While in real-mode, use a segment register was set in protected mode.
;       When combined with the above observation, we see that the way a
;       segment register is used is only dependent on the mode it was *set*,
;       not the mode we are currently in.
;
;       Observation: Hex number printed on screen is still correct.
;       vimcmd; +1,$g/demo2 codestart/+1,/demo2 codeend/-1Commentary
;
;   3) While in protected mode, set and use a segment register as if we were in
;       real-mode this is just to proove there is a detectable problem if you
;       use the register incorrectly (i.e. to show the above observations don't
;       just come from mistaking no observable problem for no problem).
;
;       Observation: Infinite loop resetting the BIOS screen.
;       vimcmd; +1,$g/demo3 codestart/+1,/demo3 codeend/-1Commentary
[ORG 0x7c00]      ; add to offsets

jmp start
testdata:
    db 0x10, 0x00, 0x00
%include "print.inc"
 
start:  
    ; Clear the screen so we know what's happening.
    mov ax, 0x3
    int 0x10
    cld

    xor ax, ax   ; make it zero
    mov ds, ax   ; DS=0
    mov ss, ax   ; stack starts at 0
    mov sp, 0x9c00   ; 2000h past code start

    ; Set the extended segment to text video memory. This is needed to use the
    ; printreg16 function.
    mov ax, 0xb800
    mov es, ax

    cli      ; no interrupt
    push ds     ; save real mode segment register for reset after exiting
                ; real-mode with `pop ds` (could just reset it to 0).

    lgdt [gdtinfo]   ; load gdt register

    mov  eax, cr0   ; switch to pmode by
    or al,1         ; set pmode bit
    mov  cr0, eax

    mov  bx, 0x08   ; select descriptor 1
    mov  ds, bx   ; 8h = 1000b
    
    ; See if working with other segments still works in protected mode.
    ; n.b. If you load a segment in real-mode, then use it in protected mode,
    ; then things work fine.
    ; If you load a segment in protected mode, then it has to be a segment
    ; selector instead of a main address.
    ; Uncommenting the two lines below would not work.
    ; demo3 codestart
    ; mov bx, 0xb800
    ; mov es, bx

    ; ; demo1 codestart
    ; mov bx, 0x0748
    ; ; Put on second line so isn't overwritten by the other tests.
    ; mov [es:0xa0], bx
    ; ; demo1 codeend
    ; demo3 codeend

    ; demo2 codestart -- COMMENTED to try demo2
    ; Load some information into a register while in protected mode.
    mov cx, [testdata]
    ; demo2 codeend

    and al,0xFE     ; back to realmode
    mov  cr0, eax   ; by toggling bit again


    ; Instead of a push at the start of the `cli` block and a pop at the end of
    ; the `sti` block, we could use the fact we know the segment should be `0`,
    ; and just set it to `0`. There's nothing special in the register.
    ; xor ax, ax
    ; mov ds, ax
    ; demo2 codestart -- COMMENTED to try demo2
    pop ds      ; get back old segment
    ; demo2 codeend
    sti

    ; demo2 codestart -- UNCOMMENTED to try demo2
    ; ; Load information while still using protected mode data.
    ; mov cx, [testdata]
    ; pop ds
    ; demo2 codeend

    ; Print a smiley to show the previous data segment has been reloaded.
    mov bx, 0x0f01   ; attrib/char of smiley
    mov eax, 0x0b8000 ; note 32 bit offset
    mov word [ds:eax], bx

    ; Print out the data loaded while in protected mode.
    ; Print it after the simley so both demos are working.
    mov byte [xpos], 0x2
    mov word [reg16], cx
    call printreg16

    jmp $      ; loop forever
 
gdtinfo:
    dw gdt_end - gdt - 1   ;last byte in table
    dd gdt         ;start of table
 
gdt        dd 0,0  ; entry 0 is always unused
; Type byte:
;   Present -- segment is in memory, so don't raise an exception when accessed
;   DPL (2 bits) -- most privileged descriptor level
;   System -- for code/data/stack segment descriptors, set to 1
;   Type bit 3 -- as S == 1, specifies whether segment is code/data, is 0 so data
;   Type bit 2 -- data segment => (bit 0 => expand-up stack behaviour)
;   Type bit 1 -- data segment => (bit 1 => read/write)
;   Type bit 0 -- Segment has not yet been accessed.
;
; Flags byte:
;   Granularity -- 1 => 4K pages
;   D/B     -- 1 => Stack pointer is 32 bit
;   R       -- Reserved
;   AVL     -- Available
;   Size    -- Top Nibble of size (i.e. extending the segment limit by extra 4
;              bytes).
; n.b. swapping the lowest byte of the base address to 1, from 0, means when I
; read in the value from ds:testdata, I miss the first byte from testdata, and
; instead use the second and third bytes.
; This means that we print out 0000 instead of 0010.
; For each of demo1 and demo2 it's useful to 
flatdesc    db 0xff, 0xff, 0, 0, 0, 10010010b, 11001111b, 0
; flatdesc    db 0xff, 0xff, 1, 0, 0, 10010010b, 11001111b, 0
gdt_end:
 
    times 510-($-$$) db 0  ; fill sector w/ 0's
    db 0x55          ; req'd by some BIOSes
    db 0xAA
;==========================================
