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
.macro mPrintString str
    movw \str, %si
    call printString
.endm
.macro FAILED str
    movw $\str, %si
    call printString
    jmp .
.endm
_start:
    # If an interrupt were called while we set up segment registers, then I'm
    # not sure what would happen. Only allow interrupts when the stack segment
    # & pointer is internally consistent with the code segment.
    cli
    # Just in case of a buggy BIOS -- ensure that %cs is set to 0.
    ljmp $0, $_boot
_boot:
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %ss

    # 0x9fc00 - 0x100000 is reserved by the BIOS (as is below 0x500)
    movw $0x9000, %ax
    movw %ax, %es
    # Start off with the stack pointer just under the extended segment.
    movw $0x8ff8, %sp
    sti

    # Store the current drive in a known place in memory.
    movb %dl, curdrive

    call checkLBASupported

    movb $1, startBlock
    call readFromHardDrive
    call DisplayData
    movb $2, startBlock
    call readFromHardDrive
    call DisplayData
successful_freeze:
    jmp .


printString:
    movb $0x0e, %ah
    cld
1:
    lodsb
    cmp $0x0, %al
    je  2f
    int $0x10
    jmp 1b
2:
    ret

cantRead:
    mPrintString $msgcantRead
    jmp .

# Use the interrupt mentioned in the BIOS list
# vimcmd: e +3550 saved_docs/BIOSinterrupts/INTERRUP.B
checkLBASupported:
	movb	$0x41, %ah
	movw	$0x55aa, %bx
	int	$0x13
    
    # Check return values
	jc  cantRead
	cmpw	$0xaa55, %bx
	jne	cantRead
    # Ensure the extended disk access functions are supported.
	andw	$1, %cx
	jz	cantRead
    ret

readFromHardDrive:
    # disk address packet must be passed to the interrupt via %ds:%si
    movw $diskPacket, %si
    movb $0x42, %ah # Read hard-disk function
    movb curdrive, %dl # drive number
    int $0x13
    jae 1f
    FAILED msgcantRead
1:
    # Interrupt description.
    # vimcmd: e +3590 saved_docs/BIOSinterrupts/INTERRUP.B
    # Operation status table (error code if there was an error) stored in AH.
    # it's zero if successful: vimcmd: e +1602 saved_docs/BIOSinterrupts/INTERRUP.B
    testb %al, %al
    jz 1f
    FAILED msgcantRead
1:
    cmpw $0x1, numBlocks
    jz 1f
    FAILED msgcantRead
1:
    ret


DisplayData:
    movw $0x9000, %si
    call printString
    ret

.text 1
curdrive: .byte 0
msgInHardDrive: .asciz "in hard drive read function"
msgcantRead: .asciz "failed to read"
diskPacket:
    # Tell the BIOS that we're not using the `extendedtransferBuffer` element
    # in this disk address packet.
    sizeofPacket: .byte 0x10
    packetReserved: .byte 0
    # At the moment, we only even want to transfer one block.
    numBlocks:      .word 1
    # Want to load the data into 0x9000
    transferBuffer: .long 0x9000
    # Where to read from, set by the calling code.
    startBlock:     .quad 0
    # The below would be needed if needed to specify a 64 bit address for the
    # transfer buffer.
    # extendedtransferBuffer: .quad 0


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
