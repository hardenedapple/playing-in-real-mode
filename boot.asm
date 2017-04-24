[ORG 0x7c00]

jmp main

%include "othercode.inc"

main:
    xor ax, ax
    mov ds, ax
    BiosPrint msg

    times 510 - ($ - $$) db 0
    db 0x55
    db 0xaa
