%macro BiosPrint 1
    mov si, word %1
    call bios_print
%endmacro

msg db 'Hello World', 0xd, 0xa, 0

hang:
    jmp hang

bios_print:
    lodsb
    or al, al   ; zero=end or str
    jz done     ; get out
    mov ah, 0x0e
    int 0x10
    jmp bios_print
done:
    ret
