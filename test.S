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
    readSectorFromFloppy:
        # Reads into the data buffer pointed to by %es:%bx
        # Store a  record to say how many times I've attempted to read the
        # data.
        pushw $0x00
        jmp 3f
    1:
        # Failure condition -- try again up to three times
        popw %ax
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
        # sector number in bits 0-5,
        # high two bits of cylinder in 6-7 for hard-disks
        # that doesn't matter much, because I'm not using a hard-disk ... but
        # it's nice to know.
        # Take this value from the argument passed by the caller.
        # Getting it from the stack makes the most sense, as ax, cx, and dx are
        # used for the BIOS call, and bx is used as a destination.
        # Real mode is limited in what mov instructions are allowed, we have to
        # load into the accumulator register, and we have to either load from
        # %bx + %si or from %bp + %di.
        movb 0x2(%bp),  %cl
        movb $0x00, %dh # head number
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
    .LreadSectorFromFloppy:
        # Just to remove the counter on the stack
        popw %ax
        ret

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
    pushw $2
    enter $0, $0
    call readSectorFromFloppy
    call DisplayData
    # Don't know why this isn't working TODO
    # Have to walk through the execution and see what happens.
    movw $3, 0x2(%bp)
    call readSectorFromFloppy
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
