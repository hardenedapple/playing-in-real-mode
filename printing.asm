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

newline:
    movw $0x1, %bx
    movb $0xe, %ah
    movb $0xa, %al
    int $0x10
    movb $0xd, %al
    int $0x10
    ret

printReg:
    # Argument to this function -- %al marks whether to terminate with a
    # newline.
    cmpb $0, %al
    je 1f
    movb $0xa, %al
1:
    movb %al, outstr16 + 4
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

printDWORD:
    movw %ax, storedaddr
    movw $1, %cx
    jmp 1f
printQWORD:
    # Address of qword is in %ax
    movw %ax, storedaddr
    movw $3, %cx
1:
    movw storedaddr, %si
    movw %cx, %ax
    shlw $1, %ax
    addw %ax, %si
    movw (%si), %ax
    movw %ax, reg16
    pushw %cx
    movb $0, %al
    call printReg
    popw %cx
    loop 1b
    # Finish, have a new line and return.
printQWORDfin:
    movw storedaddr, %si
    movw (%si), %ax
    movw %ax, reg16
    movb $1, %al
    call printReg
    ret


datastart
hexstr:     .ascii "0123456789ABCDEF"
outstr16:   .byte 0, 0, 0, 0, 0xa, 0xd, 0
reg16:      .word 0
storedaddr: .word 0
dataend
