.code16
.text 0
    .globl _start

_start:
    call clearAll

    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %ss
    movw $0x9c00, %sp

    movw $0xb800, %ax
    movw %ax, %es

    movw $GeneralMessage, %si
    call BIOSprint

getkey:
    xorw %ax, %ax
    int $0x16
    # TODO Compare to <Esc>, jmp to getkey if not <Esc>
    # If ypos has reached its maximum, then reset it to 0
    # The BIOS scancode for ESC is 0x01, the ASCII code for ESC is 0x1b
    # For BIOS scancodes, see  vimcmd: e +650 saved_docs/BIOSinterrupts/INTERRUP.A
    # To view return value of int 0x16, see vimcmd: e +277 saved_docs/BIOSinterrupts/INTERRUP.D
    cmpw $0x011b, %ax
    jne .Lcontinueloop
    call clearHex
    jmp getkey
.Lcontinueloop:
    mov %ax, (reg16)
    call printreg16
    jmp getkey

.include "printing.asm"
# .include "checkstate.asm"

.text 1
# Data section -- using text subsection so that I can use the . = _start idiom.
# If I had them in different sections I wouldn't be able to use that, as the
# assembler doesn't know which sections will be linked where.
xpos: .byte 0
# Start of first line.
ypos: .byte 1
hexstr: .ascii "0123456789ABCDEF"
outstr32: .asciz "00000000"    # register value
reg32: .long 0                   # pass values to printreg32
outstr16:   .asciz "0000"  #register value string
reg16:   .word    0  # pass values to printreg16

GeneralMessage: .ascii "This is Matthews bootloader,"
                .asciz " press keys to see their hex"

    . = _start + 510
    .byte 0x55, 0xAA
