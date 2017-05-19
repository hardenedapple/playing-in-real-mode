.file "printing.asm"

# Clear entire screen.
# Also ensure direction flag is set correctly.
clearScreen:
    movw $0x3, %ax
    int $0x10
    cld
    ret

# Argument passed via %si
# Assumes direction flag is cleared.
#   Don't know if this would affect any registers or not.
#   To be on the safe side, I'm storing the %cx register on the stack (because
#   that's a register I need to be constant over calling this function).
#   I'll check later to see if my machine changes that register or not.
# Caller must ensure everything is saved.
# Taken from my GRUB mbr (from reading the disassembly), I had a less-neat
# version.
1:
    movw $0x1, %bx
    movb $0xe, %ah
    int $0x10
BIOSprint:
    lodsb
    cmpb $0, %al
    jne 1b
    ret
    
printReg:
    movw $outstr16, %di
    movw reg16, %ax
    movw $hexstr, %si
    movw $4, %cx
hexloop:
    rolw $4, %ax
    movw %ax, %bx
    andw $0x0f, %bx
    # Cheating a little here, the index is in the base register while the
    # string position is in the source register.
    movb (%bx, %si), %bl
    movb %bl, (%di)
    incw %di
    loop hexloop

    printString($outstr16)
    ret

datastart
hexstr:     .ascii "0123456789ABCDEF"
outstr16:   .byte 0, 0, 0, 0, 0xa, 0xd, 0
reg16:      .word 0
dataend
