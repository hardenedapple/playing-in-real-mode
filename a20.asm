# NOTE
#   All methods talking about A20 line are listed here
#       http://wiki.osdev.org/A20_Line

.file "a20.asm"
enablea20:
    # Check if it's already enabled on boot.
    call check_a20
    cmpw $1, %ax
    jne 1f
    printString($booteda20)
    ret
1:
    movw $a20attempts, %cx

activatea20Loop:
    movw %cx, %si
    printString((%si))
    addw $2, %cx
    movw %cx, %si
    movw (%si), %ax
    call *%ax
    addw $2, %cx

    call check_a20
    cmpw $1, %ax
    je a20done

    printString($notenabledmsg)
    cmpw $a20attemptsend, %cx
    ja activatea20failed
    jmp activatea20Loop

a20done:
    printString($enabledmsg)
    ret
activatea20failed:
    printString($a20disabled)
    ret


# Check if wraparound is happening, and hence if the A20 line is disabled.
check_a20:
    pushf
    pushw %ds
    pushw %es
    pushw %di
    pushw %si

    cli

    xorw %ax, %ax
    movw %ax, %es

    not %ax
    movw %ax, %ds

    movw $0x0500, %di
    movw $0x0510, %si

    # Here [es:di] and [ds:si] address 0000:0500 and ffff:0510 which are
    # positions 000500 and 100500 respectively.
    # If wraparound is happening, then these values will address the same byte,
    # otherwise they will address different bytes (that may be the same value).

    movb %es:(%di), %al
    pushw %ax

    movb %ds:(%si), %al
    pushw %ax

    # Now on the stack we have  0xff<byte stored at 0000:0500>
    #       and                 0xff<byte stored at ffff:0510>
    # n.b. this is just so that we can write the correct values back after
    # we've done checking for wraparound.

    movb $0x00, %es:(%di)
    movb $0xff, %ds:(%si)

    # We have written different values under each addressing mechanism.
    # If wraparound is enabled, then both writes will be to the same place, and
    # hence the second one will have overwritten the first.
    # Otherwise they will have written to different places, and when reading
    # [es:di] we'll get the 0x00.

    cmpb $0xff, %es:(%di)

    # Before checking the condition flags, we put those memory locations back
    # to how they were.
    popw %ax
    movb %al, %ds:(%si)

    popw %ax
    movb %al, %es:(%di)

    movw $0, %ax

    # Check the condition flags here.
    je check_a20_exit

    movw $1, %ax

check_a20_exit:
    popw %si
    popw %di
    popw %es
    popw %ds
    popf

    # # Test instruction so I can check my loops work in virtual machines.
    # movw $0, %ax
    ret


fasta20enable:
    in $0x92, %al
    testb $2, %al
    jnz 1f
    orb $2, %al
    andb $0xfe, %al
    outb %al, $0x92
1:
    ret

keyboarda20enable:
biosa20enable:
    pushw %cx
    # vimcmd: e +3128 saved_docs/BIOSinterrupts/INTERRUP.C
    # Check if the BIOS has A20 gate support
    movw $0x2403, %ax
    int  $0x15
    jb 5f
    cmpb $0, %ah
    jnz 5f
    
    # Check if A20 is already set (shouldn't be calling this function if it's
    # already set, but worth it anyway in case I use the function differently
    # in the future).
    movw $0x2402, %ax
    int  $0x15
    jb 4f
    cmpb $0, %ah
    jnz 4f

    cmpb 1, %al
    jz 1f

    # Attempt to activate the A20 gate.
    movw $0x2401, %ax
    int  $0x15
    jb 4f
    cmpb $0, %ah
    jnz 4f

1:
    movw $1, %ax
    jmp biosa20enableret

4:
    printString($faileda20)
5:
    movw $0, %ax
biosa20enableret:
    popw %cx
    ret

datastart
faileda20:  .asciz "... something went wrong "

a20attempts:
    # # The below is the recommended order to attempt turning on a20, the
    # # uncommented order is just for trying things out.
    # .word biosa20, biosa20enable
    # .word keyboarda20, keyboarda20enable
    # .word fasta20, fasta20enable
    
    .word fasta20, fasta20enable
    .word biosa20, biosa20enable
    .word keyboarda20, keyboarda20enable
a20attemptsend:



booteda20:   .asciz "A20 enabled on boot"
biosa20:     .asciz "Attempting to turn on a20 via BIOS"
keyboarda20: .asciz "Attempting to turn on a20 via keyboard"
fasta20:     .asciz "Attempting to turn on a20 via fast method"

enabledmsg:    .asciz "...  worked!\r\nA20 is enabled!"
notenabledmsg: .asciz "...  didn't work ..\r\n"

a20disabled: .asciz "A20 is disabled!!"
dataend
