# Clear entire screen.
# Also ensure direction flag is set correctly.
clearAll:
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
BIOSprint:
    # TODO -- Needed?
    pushw %cx
1:
    lodsb
    cmpb $0, %al
    je BIOSexit
    movb $0x0e, %ah
    int $0x10
    jmp 1b
BIOSexit:
    popw %cx
    ret
    
