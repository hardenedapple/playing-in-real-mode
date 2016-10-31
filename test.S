.code16                 # generate 16-bit code
.text                   #executable code location
    .globl _start
_start:                 # code entry point

    jmp _boot
    # NOTE Don't need the carriage return, but it does put the cursor at the
    # start of a new line instead of just moving it down one line.
    welcome: .asciz "Hello, World\n\r"

    .macro mWriteString str
        leaw \str, %si
        call .writeStringIn
    .endm

    .writeStringIn:
        lodsb
        orb %al, %al
        js .writeStringOut
        movb $0x0e, %ah
        int $0x10
        jmp .writeStringIn
    .writeStringOut:
    ret

_boot:
    mWriteString welcome

    . = _start + 510    # move to 510th byte from 0 pos
    .byte 0x55          # append boot signature
    .byte 0xaa          # append boot signature

