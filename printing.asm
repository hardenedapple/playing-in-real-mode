dochar:
    call cprint
sprint:
    lodsb
    cmpb $0, %al
    jne dochar
    ret

cprint:
    # Printing attribute of the character
    movb $0x0f, %ah
    movw %ax, %cx
    movzbw (ypos), %ax
    movw $160, %dx
    mulw %dx

    movzbw (xpos), %bx
    shl $1, %bx

    movw $0, %di
    addw %ax, %di
    addw %bx, %di

    movw %cx, %ax
    stosw
    addb $1, (xpos)
    cmpb $80, (xpos)
    jb .Lcursorfine
    # If reached end of line, start a new one.
    addb $1, (ypos)
    movb $0, (xpos)
    # If gotten to last line on the screen, go back to start.
    cmpb $25, (ypos)
    jb .Lcursorfine
    movb $1, (ypos)
.Lcursorfine:
    ret

printreg16:
    movw $outstr16, %di
    movw (reg16), %ax
    movw $hexstr, %si
    movw $4, %cx
hexloop:
    rol $4, %ax
    movw %ax, %bx
    andw $0x0f, %bx
    movb (%bx, %si), %bl
    movb %bl, (%di)
    incw %di
    decw %cx
    jnz hexloop
    movw $outstr16, %si
    call sprint
    movb $' ', %al
    call cprint
    ret

# Clear entire screen.
# Also ensure direction flag is set correctly.
clearAll:
    movw $0x3, %ax
    int $0x10
    cld
    ret

clearHex:
    movw $0, %cx
    movw $0x0720, %ax
    # Start at the start of the second line
    # The first line is the plain message I don't want overwritten.
    movw $160, %di
.Lloopstart:
    # Compare to 80 * 25 * 2 (i.e. end of screen)
    cmpw $4000, %di
    ja .Lret
    stosw 
    jmp .Lloopstart
.Lret:
    movb $1, (ypos)
    movb $0, (xpos)
    ret


# Argument passed via %si
# Assumes direction flag is cleared.
BIOSprint:
    lodsb
    cmpb $0, %al
    je BIOSexit
    movb $0x0e, %ah
    int $0x10
    jmp BIOSprint
BIOSexit:
    ret
    
