.code16

.text
    .globl _start
.macro mPrintString str
    movw \str, %si
    call printString
.endm

.macro ERRMSG str
    movw $\str, %si
    call errmsg
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

    # movw $0x9000, %ax
    # movw %ax, %es
    # Start off with the stack pointer just under the extended segment.
    movw $0x8fc0, %ax
    movw %ax, %ss
    movw $0xffff, %sp
    sti

    # Store the current drive in a known place in memory.
    movb %dl, curdrive

    call checkLBASupported

    # Use the default values stored in `diskPacket` -- read the first block of
    # the disk into memory at 0x7e00.
    call readFromHardDrive

    # Put the value of the current drive back into %dl
    movb curdrive, %dl
    # Jump to this place in the next section.
    # This file is linked twice, once with the start at 0x7c00 and once with
    # the start at 0x7e00.
    # We are now jumping to this place in the binary that was linked second.
    # Use the instruction bytes directly rather than playing tricks with the
    # linker.
    .byte 0xe9
    .word 0x200
    /*
     * NOTE
     *  Between `otherSection` and `backtostart`, the data/text is only accessed
     *  while in the 0x7e00 segment.
     */
otherSection:
    # Read the vmlinuz-linux MBR we placed in sector 2048 of the hard-drive
    # into memory location 0x7c00, and jump to it.
    movw $2048, startBlock
    movw $0x7c00, transferBuffer
    # Store the value of the current drive into `curdrive` in the second
    # segment.
    movb %dl, curdrive
    call readFromHardDrive
    # Check everything worked nicely.
    movw 0x7c00, %ax
    # Hex of the first two bytes in the vmlinuz-linux file.
    cmpw $0x5a4d, %ax
    jne end
    jmp *backtostart
end:
    movw %ax, reg16
    call printReg
    ERRMSG msgReadFailed
    jmp .
backtostart: .word 0x7c00


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
    mPrintString $msgNoLBA
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
    # Disk packet must be set up by the caller.
    movb curdrive, %dl # drive number
    movw $diskPacket, %si
    movb $0x42, %ah # Read hard-disk function
    int $0x13
    jae 1f
    ERRMSG msgReadFailed
1:
    # Interrupt description.
    # vimcmd: e +3590 saved_docs/BIOSinterrupts/INTERRUP.B
    # Operation status table (error code if there was an error) stored in AH.
    # it's zero if successful: vimcmd: e +1602 saved_docs/BIOSinterrupts/INTERRUP.B
    testb %ah, %ah
    jz 1f
    ERRMSG msgReadFailed
1:
    cmpw $0x1, numBlocks
    jz 1f
    ERRMSG msgReadFailed
1:
    ret


printReg:
    movw $outstr16, %di
    movw reg16, %ax
    movw $hexstr, %si
    movw $4, %cx
hexloop:
    rolw $4, %ax
    movw %ax, %bx
    andw $0x0f, %bx
    # Cheating a little here, the index is in the base register while the
    # string position is in the source register.
    movb (%bx, %si), %bl
    movb %bl, (%di)
    incw %di
    loop hexloop

    movw $outstr16, %si
    call printString
    ret


errmsg:
    call printString
    popw %ax
    movw %ax, reg16
    pushw %ax
    call printReg
    ret


.text 1
curdrive: .byte 0
msgInHardDrive: .asciz "in hard drive read function "
msgNoLBA: .ascii "no installed LBA "
msgReadFailed: .asciz "cannot read "
hexstr:     .ascii "0123456789ABCDEF"
outstr16:   .byte 0, 0, 0, 0, 0xa, 0xd, 0
reg16:      .word 0
diskPacket:
    # Tell the BIOS that we're not using the `extendedtransferBuffer` element
    # in this disk address packet.
    sizeofPacket: .byte 0x10
    packetReserved: .byte 0
    # At the moment, we only even want to transfer one block.
    numBlocks:      .word 1
    # When reading the second part, load the data just after ourselves in
    # memory. Doesn't really matter where we load it, but that's a nice safe
    # place.
    transferBuffer: .long 0x7e00
    # Where to read from, set by the calling code.
    startBlock:     .quad 1
    # The below would be needed if needed to specify a 64 bit address for the
    # transfer buffer.
    # extendedtransferBuffer: .quad 0


. = _start + 0x1b8
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
        # Partition type  "BootIt"  (Just like the name).
        .byte 0xdf
        # CHS address of last absolute sector in partition
            .byte 0x00, 0x00, 0x00
        # LBA of first absolute sector in partition
        # GRUB recommends 2048 sectors to install itself, so we put the
        # partition in the same place that GRUB would to ease with transition
        # in the future.
            .byte 0x00, 0x08, 0x00, 0x00
        # Number of sectors in partition.
        .long 100

_end:
    . = _start + 510
    .byte 0x55
    .byte 0xaa
