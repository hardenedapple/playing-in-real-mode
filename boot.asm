[ORG 0x7c00]      ; add to offsets
    ; n.b. I have a machine with (say) 32Meg of RAM, this is 32 * 1024**2 bytes
    ; I have instructions that access values within a range of 16 bits
    ; This corresponds to 2^16 = 65536 bytes
    ; (32 * 1024**2) / 65536 bytes gives me 512 non-overlapping segments
    ; Why am I using overlapping segments for my stack and code?
    ;
    ; Addresable space is not as much ...
    ; I can only fit a 16 bit value into the segment registers.
    ; When addressing memory they are multiplied by 16.
    ; This gives the range of segment register values as 2^16 * 16
    ; This can be slightly extended with the offsets by another 16 bit value.
    ; We end up with just (2^16 * 17) = 1114112 addressable bytes.
    ; This gives just 17 non-overlapping segments.
    ; This is still much better than everything in the one segment.

    ; Clear screen using a BIOS interrupt (get rid of the qemu/bochs messages)
    ; TODO clear screen without BIOS -- use the print functions below, but
    ; print npaces (or maybe other things).
    mov ax, 0x3
    int 0x10

    xor ax, ax    ; make it zero
    ; TODO I think it would make more sense to have non-overlapping segments.
    ; i.e. each segment is 2^16 bytes long.
    ; cs = 0x0000 (can't change this ... and gdb reports it being 0)
    ; es = 0x1000
    ; ss = 0x2000
    ; ds = 0x3000
    ; fs = 0x4000
    ; gs = 0x5000
    ; These segments map to the segment register number assigned to each
    ; segment, apart from the switch between cs and es that I have because I
    ; can't change the cs register.
    ; (see Intel manual volume 2A, chapter 3-6 page 134 in the pdf I have).
    mov ds, ax   ; DS=0
    mov ss, ax   ; stack starts at 0
    mov sp, 0x9c00   ; 2000h past code start ; TODO Why this number (any particular reason?)

    cld

    ; See http://wiki.osdev.org/Printing_To_Screen for most of what's happening
    ; here. Instead of using the BIOS to print to the screen, we're using the
    ; method you usually have to use -- writing to "video" memory.
    mov ax, 0xb800   ; text video memory
    mov es, ax

    mov si, msg   ; show text string
    call sprint

    ; Inspect the memory at position gs:bx
    ; This gives us the character 'W' with the attribute 0F
    mov ax, 0xb800   ; look at video mem
    mov gs, ax
    mov bx, 0x0000
    mov ax, [gs:bx]

    mov  word [reg16], ax ;look at register
    call printreg16

hang:
    jmp hang

;----------------------
dochar:
    call cprint         ; print one character
sprint:
    lodsb      ; string char to AL
    cmp al, 0
    jne dochar   ; else, we're done
    add byte [ypos], 1   ;down one row
    mov byte [xpos], 0   ;back to left
    ret

; Printing to screen information can be found here
; http://wiki.osdev.org/Printing_To_Screen
; The basics are that you put data into the video memory.
; For each character on screen you write two bytes into the memory, one is the
; ASCII code byte, the other is the attribute byte.
; e.g. 'H', 0x07  is lightgrey-on-black 'H'
; The lowest 4 bits of the attribute byte are the foreground colour, the
; highest 3 bits are the background color, and the interpretation of the
; missing byte is dependant on configuration.
;
; So what does putting a newline do? If characters are printed at the position
; specified by the offset into the 
cprint:
    ; Called with the character to print in al
    ; We set the char/attribute, save it in cx
    ; Then we get the yposition into ax (because the mul instruction uses ax)
    ; by multiplying the position we want by 160 (which is 80 columns times 2
    ; bytes -- character/attribute).
    ;
    ; We then get the x position into bx by multiplying xpos by two
    ; (character/attribute).
    ;
    ; Finally, we get the memory position into di by adding the x and y
    ; positions.
    ; Then we write the stored char/attribute word into that position, and
    ; advance to the right.
    ;
    ; n.b. this does absolutely nothing to the cursor position that we can work
    ; with using the BIOS.

    mov ah, 0x0F
    mov cx, ax
    movzx ax, byte [ypos]
    mov dx, 160
    ; dx:ax = dx * ax     (dx is set to the upper 16 bits of the mul result)
    mul dx

    movzx bx, byte [xpos]
    shl bx, 1

    mov di, 0        ; start of video memory
    add di, ax      ; add y offset
    add di, bx      ; add x offset

    mov ax, cx        ; restore char/attribute
    ; Store ax at es:di
    stosw              ; write char/attribute
    add byte [xpos], 1  ; advance to right

    ret

    ;------------------------------------

; Printing the value of a register to screen.
printreg16:
    mov di, outstr16
    mov ax, [reg16]
    mov si, hexstr
    mov cx, 4   ;four places
hexloop:
    rol ax, 4   ;leftmost will
    mov bx, ax   ; become
    and bx, 0x0f   ; rightmost
    mov bl, [si + bx];index into hexstr
    mov [di], bl
    inc di
    dec cx
    jnz hexloop

    mov si, outstr16
    call sprint

    ret

    ;------------------------------------

    xpos   db 0
    ypos   db 0
    hexstr   db '0123456789ABCDEF'
    outstr16   db '0000', 0  ;register value string
    reg16   dw    0  ; pass values to printreg16
    msg   db "What are you doing, Dave?", 0
    times 510-($-$$) db 0
    db 0x55
    db 0xAA
    ;==================================
