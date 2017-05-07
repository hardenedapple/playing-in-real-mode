dochar:
    call cprint
sprint:
    lodsb
    cmpb $0, %al
    jne dochar
    addb $1, (ypos)
    movb $0, (xpos)
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
    ret

.code32
dochar32:
    call cprint32
sprint32:
    movl (%esi), %eax
    leal 1(%esi), %esi
    cmpb $0, %al
    jne dochar32
    addb $1, (ypos)
    movb $0, (xpos)
    ret

cprint32:
    movb $0x0f, %ah
    movl %eax, %ecx
    movzbl (ypos), %eax
    movl $160, %edx
    mull %edx
    movzbl (xpos), %ebx
    shll $1, %ebx

    movl $0xb8000, %edi
    addl %eax, %edi
    addl %ebx, %edi

    movl %ecx, %eax
    # Interesting note: when I specify the DS segment in NASM, it uses the DS
    # segment override prefix, when I specify it here for GNU as, it notices
    # that the data segment is the default and omits it.
    movw %ax, %ds:(%edi)
    addb $1, (xpos)
    ret

printreg32:
    movl $outstr32, %edi
    movl (reg32), %eax
    movl $hexstr, %esi
    movl $8, %ecx

hexloop32:
    roll $4, %eax
    movl %eax, %ebx
    andl $0x0f, %ebx
    movb (%esi, %ebx), %bl
    movb %bl, (%edi)
    incl %edi
    decl %ecx
    jnz hexloop32

    movl $outstr32, %esi
    call sprint32
    ret
.code16
