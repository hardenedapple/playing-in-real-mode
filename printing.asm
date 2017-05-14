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
    
