.code16
.text 0
    .globl _start

_start:  
    jmp _codestart

.include "printing.asm"

testdata:
    .byte 0x10, 0x00, 0x00
 
_codestart:
    movw $0x3, %ax
    int $0x10
    cld

    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %ss
    movw $0x9c00, %sp

    movw $0xb800, %ax
    movw %ax, %es

    cli
    pushw %ds

    # Store the position of the global descriptor table before switching to
    # protected mode.
    lgdt (gdtinfo)
    # Switch to protected mode
    movl %cr0, %eax
    orb $1, %al
    movl %eax, %cr0

    # Use the protected mode version of segments, and load some data into a
    # register using it.
    movw $0x08, %bx
    movw %bx, %ds
    xorl %ecx, %ecx
    movw (testdata), %cx
    movl %ecx, (reg32)
    call printreg32
    xorl %ecx, %ecx
    movw (testdata), %cx
    andb $0xFE, %al
    movl %eax, %cr0
    popw %ds

    sti

    movw %cx, (reg16)
    call printreg16

    jmp .


.text 1
# Data section -- using text subsection so that I can use the 
xpos: .byte 0
ypos: .byte 0
hexstr: .ascii "0123456789ABCDEF"
outstr32: .asciz "00000000"    # register value
reg32: .long 0                   # pass values to printreg32
outstr16:   .asciz "0000"  #register value string
reg16:   .word    0  # pass values to printreg16


gdtinfo:
    .word gdt_end - gdt - 1   #last byte in table
    .long gdt         #start of table
 
gdt:        .long 0, 0  # entry 0 is always unused
flatdesc:    .byte 0xff, 0xff, 0, 0, 0, 0b10010010, 0b11001111, 0
gdt_end:
 
    . = _start + 510
    .byte 0x55, 0xAA
