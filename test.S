.code16
.text
    .globl _start
_start:
    jmp _boot
    msgFail: .asciz "something has gone wrong ..."
    .macro mPrintString str
        movw \str, %si
        call printString
    .endm
    printString:
        movb $0x0e, %ah
        cld
    .LprintStringIn:
        lodsb
        cmp $0x0, %al
        je  .LprintStringOut
        int $0x10
        jmp .LprintStringIn
    .LprintStringOut:
    ret

    # Storing the value of a typical floppy disk (obviously .. can have
    # different values).
    # 2 heads ... each contains
    # 80 tracks ... each contains
    # 18 sectors ... each contains
    # 512 bytes.
    .macro mReadSectorFromFloppy num
        # Reads into the data buffer pointed to by %es:%bx
        # This will be my little record to say how many times I've attempted to
        # call this function.
        pushw $0x00
        jmp 3f
    1:
        # Failure condition -- try again up to three times
        popw %ax
        # cmp and jle
        # cmp arg2, arg1 (order because of GAS syntax)
        # cmp effectively does arg2 - arg1
        # arg2 < arg1
        #   Both are positive.
        #       no overflow
        #           SF is set (because sign is now negative)
        #           OF is not set (because there was no overflow).
        #       overflow not possible because (negative range of values
        #       available is greater than possible difference between positive
        #       values).
        #
        #   If arg2 is negative and arg1 is positive
        #       no overflow
        #           SF is set (always going to be negative)
        #           OF is not set
        #       overflow
        #           SF is not set (because of the overflow)
        #           OF is set
        #
        #   Both are negative
        #       no overflow
        #           SF is set (negative addition, arg2 smaller => abs(arg2) greater)
        #           OF not set
        #       overflow not possible (abs(arg2) > abs(arg1))
        #
        # arg2 > arg1
        #   Both positive, 
        #       no overflow
        #           SF not set
        #           OF not set
        #       overflow not possible
        #
        #   arg1 negative, arg2 positive
        #       no overflow
        #           SF not set
        #           OF not set
        #       overflow
        #           SF set (wrap around from positive)
        #           OF set
        #
        #   Both negative
        #       no overflow
        #           SF not set (arg2 > arg1, both negative, abs(arg1) greater)
        #           OF not set
        #       overflow not possible because difference not greater than
        #       positive range.
        #
        # al is never negative here, so I would be just as well served with jbe
        # arg2 < arg1
        #   Both are always positive
        #       Will have to carry, arg2 - arg1 would go negative.
        # arg2 > arg1
        #   Both are always positive
        #       Will not carry, arg2 - arg1 is fine.
        cmp $0x3, %al
        jbe 2f
        mPrintString msgFail
        jmp _freeze
    2:
        pushw %ax
    3:
        movb $0x02, %ah # Read disk function
        movb $0x01, %al # Number of sectors to read
        movb $0x00, %ch # cylinder number
        movb $0x00, %dh # head number
        movb \num,  %cl # sector number in bits 0-5,
                        # high two bits of cylinder in 6-7 for hard-disks
                        # that doesn't matter much, because I'm not using a
                        # hard-disk ... but it's nice to know.
        movb $0x00, %dl # drive number
        int $0x13
        jc 1b
        # Call failure function if carry flag is set, or if al is not 1
        # according to the BIOS list ...
        # carry flag is set on error
        #   AH set to 0x11 if corrected ECC error
        #   AL = burst length
        # carry flag clear on error
        #   AH status (see Table 00234) vimcmd: e +/Table\ 00234/ saved_docs/BIOSinterrupts/INTERRUP.B
        #   AL number of sectors transferred.
        cmpb $0x01, %al
        jne 1b
    .endm

    DisplayData:
    .LDisplayDataIn:
        pushw %ds
        movw %es, %si
        movw %si, %ds
        movw %bx, %si
        call printString
        pop %ds
    .LDisplayDataOut:
    ret
_boot:
    movw $0x7c0, %ax
    movw %ax, %ds
    movw $0x9000, %ax
    movw %ax, %es
    xorw %bx, %bx
    mReadSectorFromFloppy $2
    call DisplayData
    mReadSectorFromFloppy $3
    call DisplayData
_freeze:
    jmp _freeze

# This symbol is just here so I can see how large my file is by using `nm`
# after assembly & linkage.
_end:
    . = _start + 510
    .byte 0x55
    .byte 0xaa

_sector2:
    .asciz "Sector: 2\n\r"
    . = _sector2 + 512
_sector3:
    .asciz "Sector: 3\n\r"
    . = _sector3 + 512
