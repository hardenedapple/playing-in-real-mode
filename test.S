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
        jc .L_failure     # jump if carry flag is set.
                        # according to the BIOS list ...
                        # carry flag is set on error
                        #   AH set to 0x11 if corrected ECC error
                        #   AL = burst length
                        # carry flag clear on error
                        #   AH status (see Table 00234) vimcmd: e +/Table\ 00234/ saved_docs/BIOSinterrupts/INTERRUP.B
                        #   AL number of sectors transferred.
        cmpb $0x01, %al
        jne .L_failure
    .endm

    # Question:
    #   Why use this instead of reusing printString?
    #       I'll have a look to see if we want to use it in other ways ...
    #       Maybe something to do with where we can use lodsb (does it have to
    #       use the data segment)?
    #   I'm guessing it's because data from the sector is read into the data
    #   buffer ... but I still think we could reuse the above code.
    DisplayData:
    .LDisplayDataIn:
        movb %es:(%bx), %al
        orb %al, %al
        jz .LDisplayDataOut
        movb $0x0e, %ah
        int $0x10
        incw %bx
        jmp .LDisplayDataIn
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
.L_failure:
    mPrintString msgFail
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
