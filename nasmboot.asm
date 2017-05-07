[org 0x7c00]

jmp start

%include "print.inc"

testdata:
    db 0x10, 0x00, 0x00
 
start:
    mov ax, 0x3
    int 0x10
    cld

    xor ax, ax   ; make it zero
    mov ds, ax   ; DS=0
    mov ss, ax   ; stack starts at 0
    mov sp, 0x9c00   ; 2000h past code start

    mov ax, 0xb800
    mov es, ax

    cli      ; no interrupt
    push ds     ; save real mode segment register for reset after exiting

    lgdt [gdtinfo]   ; load gdt register

    mov  eax, cr0   ; switch to pmode by
    or al,1         ; set pmode bit
    mov  cr0, eax

    mov  bx, 0x08   ; select descriptor 1
    mov  ds, bx   ; 8h = 1000b
    xor ecx, ecx
    mov cx, [testdata]
    mov [reg32], ecx
    call printreg32
    xor ecx, ecx
    mov cx, [testdata]
    and al,0xFE     ; back to realmode

    mov  cr0, eax   ; by toggling bit again
    pop ds      ; get back old segment

    sti

    mov [reg16], cx
    call printreg16
    jmp $      ; loop forever


 
;------------------------------------
 
xpos db 0
ypos db 0
hexstr db '0123456789ABCDEF'
outstr32 db '00000000', 0    ; register value
reg32 dd 0                   ; pass values to printreg32
 
outstr16   db '0000', 0  ;register value string
reg16   dw    0  ; pass values to printreg16
;==================================
gdtinfo:
    dw gdt_end - gdt - 1   ;last byte in table
    dd gdt         ;start of table
 
gdt:        dd 0, 0
flatdesc    db 0xff, 0xff, 0, 0, 0, 10010010b, 11001111b, 0
gdt_end:
 
    times 510-($-$$) db 0  ; fill sector w/ 0's
    db 0x55          ; req'd by some BIOSes
    db 0xAA
