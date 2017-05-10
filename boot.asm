.code16
.text 0
    .globl _start

.macro datastart
    .text 1
.endm
.macro dataend
    .text 0
.endm

_start:
    call clearAll

    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %ss
    movw $0x9c00, %sp

    # Check if it's already enabled on boot.
    call check_a20
    cmpw $1, %ax
    jne 1f
    movw $booteda20, %si
    call BIOSprint
    jmp hang

1:
    movw $a20attempts, %cx

activatea20Loop:
    movw %cx, %si
    movw (%si), %si
    call BIOSprint
    addw $2, %cx
    movw %cx, %si
    movw (%si), %ax
    call *%ax
    addw $2, %cx

    call check_a20
    cmpw $1, %ax
    je a20done

    movw $notenabledmsg, %si
    call BIOSprint
    cmpw $a20attemptsend, %cx
    ja activatea20failed
    jmp activatea20Loop

a20done:
    movw $enabledmsg, %si
    call BIOSprint
    jmp hang
activatea20failed:
    movw $a20disabled, %si
    call BIOSprint

hang:
    jmp .

.include "printing.asm"
.include "checkstate.asm"

datastart
# Data section -- using text subsection so that I can use the . = _start idiom.
# If I had them in different sections I wouldn't be able to use that, as the
# assembler doesn't know which sections will be linked where.
a20attempts:
    .word biosa20, biosa20enable
    .word keyboarda20, keyboarda20enable
    .word fasta20, fasta20enable
a20attemptsend:


booteda20:   .asciz "A20 enabled on boot"
biosa20:     .asciz "Attempting to turn on a20 via BIOS"
keyboarda20: .asciz "Attempting to turn on a20 via keyboard"
fasta20:     .asciz "Attempting to turn on a20 via fast method"

enabledmsg:    .asciz "...  worked!\r\nA20 is enabled!"
notenabledmsg: .asciz "...  didn't work ..\r\n"

a20disabled: .asciz "A20 is disabled!!"

    . = _start + 510
    .byte 0x55, 0xAA
