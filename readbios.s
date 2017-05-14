.code16
# n.b. You can name the section whatever you want ...
# Using the below declaration, and the flag --section-start=mytext=0x7c00
# instead of -Ttext 0x7c00 in the linker arguments, you get the same file.
# The number "2" means that the SHF_ALLOC flag is set in the section. This
# makes sure that the data is put into the resulting output file.
#
# The format of this declaration when outputting ELF files (which are outputed
# by the assembler by default on my machine & setup) can be found in
# "(as)Section" info page.
# vimcmd: term info as -n Section
# Note that both section header *flags* and *type* can be specified.
# See the difference in the elf(5) man page.
# vimcmd: Man elf
# .section mytext, "2"
.text
    .globl _start
_start:
    jmp _boot
    msgFail: .asciz "something has gone wrong ..."
    msgcantRead: .asciz "failed to read"
    msgCanRead: .asciz "Extensions are installed"
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

cantRead:
    mPrintString $msgcantRead
    jmp _freeze

checkLBASupported:
	movb	$0x41, %ah
	movw	$0x55aa, %bx
	int	$0x13
    
    # Check return values
	jc  cantRead
	cmpw	$0xaa55, %bx
	jne	cantRead
	andw	$1, %cx
	jz	cantRead
    mPrintString $msgCanRead
    jmp _freeze
    ret

# TODO The below is some code taken from GRUB to do with loading data from the
# hard-drive.
	xorw	%ax, %ax
	movw	%ax, 4(%si)

	incw	%ax
	/* set the mode to non-zero */
	movb	$1, -1(%si)
	# Number of blocks to transfer.
	movw	$1, 2(%si)
	/* the size and the reserved byte */
	movw	$0x0010, (%si)

    # Starting absolute block number
	movl	$1, 8(%si)
	movl	$0, 12(%si)


    readFromHardDrive:
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
        mPrintString $msgFail
        jmp _freeze
    2:
        pushw %ax
    3:
        movb $0x42, %ah # Read hard-disk function
        movb curdrive, %dl # drive number
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
    .LreadFromHardDrive:
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
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %ss

    movw $0x9000, %ax
    movw %ax, %es

    # Start off with the stack pointer just under the extended segment.
    movw $0x8ff8, %sp
    # Store the current drive in a known place in memory.
    movb %dl, curdrive

    call checkLBASupported
    mPrintString msgCanRead
    jmp .
    xorw %bx, %bx
    pushw $2
    enter $0, $0
    call readFromHardDrive
    call DisplayData
    # movw $3, 0x2(%bp)
    # movw (%di), %ax
    # call *%ax
    # call DisplayData
_freeze:
    jmp _freeze

curdrive: .byte 0

.org 0x1b8
diskID:
    .long 0xfeeeebbe
    .word 0
partitionTable:
    partition1:
        # Status - bit 7 set is for active, or bootable.
        .byte 0x80
        # CHS address of first absolute sector in partition
            # Doesn't seem to matter.
            .byte 0x00, 0x00, 0x00
        # Partition type
        .byte 0x01
        # CHS address of last absolute sector in partition
            .byte 0x00, 0x00, 0x00
        # LBA of first absolute sector in partition
            .byte 0x01, 0x00, 0x00, 0x00
        # Number of sectors in partition
        .long 100

_end:
    .org 510
    .byte 0x55
    .byte 0xaa

_sector2:
    .asciz "Sector: 2\n\r"

diskLabel:    .asciz "Test value"

    . = _sector2 + 512
_sector3:
    .asciz "Sector: 3\n\r"
    . = _sector3 + 512

.org 512  * 8
