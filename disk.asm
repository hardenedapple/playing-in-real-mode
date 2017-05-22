.file "disk.asm"

initialiseDisks:
    # BIOS initially puts the disk number that we're booting from into %dl.
    # This register value is also the argument that int 0x13 takes to know
    # which disk number to read from.
    # Rather than ensuring I don't change that register all the time, I'm just
    # going to store it in memory.
    # This will be
    # 0x00 for first floppy drive, 0x01 for second,
    # 0x80 for first hard drive,   0x81 for second,
    movb %dl, curdrive

    # Before interacting with the disks, apparently we have to reset the disk
    # system to a known state using BIOS interrupt
    # vimcmd: e +1579 saved_docs/BIOSinterrupts/INTERRUP.B
    # I read this in saved_docs/bootloader-from-scratch.pdf
    movb $0, %ah
    int $0x13
    jc 1f

ignoreerror:
    # Check if LBA is supported.
    # This bootloader is solely aimed at running on a hard-disk, so without LBA
    # we're helpless.
	movb	$0x41, %ah
	movw	$0x55aa, %bx
	int	$0x13
    
    # Check return values
	jc  2f
	cmpw	$0xaa55, %bx
	jne	2f
    # Ensure the extended disk access functions are supported.
	andw	$1, %cx
	jz	2f

    ret
1:
    # Print the status returned.
    movb $0, %al
    movw %ax, reg16
    call printReg
    ERRMSG(msgDiskFail)
    # Carry on anyway, see what happens.
    jmp ignoreerror
2:
    ERRMSG(msgNoLBA)
    jmp .

readFromHardDrive:
    # Store the number of packets that we're requesting to be read.
    # This allows us to check the number we've requested is the same number
    # we received.
    movw numBlocks, %cx
    # Disk packet must be set up by the caller.
    movb curdrive, %dl # drive number
    movw $diskPacket, %si
    movb $0x42, %ah # Read hard-disk function
    int $0x13
    jae 1f
    ERRMSG(msgReadFailed)
1:
    # Interrupt description.
    # vimcmd: e +3590 saved_docs/BIOSinterrupts/INTERRUP.B
    # Operation status table (error code if there was an error) stored in AH.
    # it's zero if successful: vimcmd: e +1602 saved_docs/BIOSinterrupts/INTERRUP.B
    testb %ah, %ah
    jz 1f
    ERRMSG(msgReadFailed)
1:
    cmpw %cx, numBlocks
    jz 1f
    ERRMSG(msgReadFailed)
1:
    ret

copyExtendedMemory:
    # Linux needs 0x8000 for the kernel setup and boot sector
    # *after* that, it needs another 0x8000 for the stack & heap (totalling
    # 0x10000).
    # http://lxr.linux.no/linux+*/Documentation/x86/boot.txt#L92
    # The boot documentation says to use INT 0x12 to find how much memory we
    # have available.
    # vimcmd: e +5602 saved_docs/BIOSinterrupts/INTERRUP.C
    # Also described here
    # http://webpages.charter.net/danrollins/techhelp/0222.HTM

datastart 
curdrive: .byte 0
msgDiskFail: .asciz "disk.asm problem"
msgReadFailed: .asciz "cannot read "
msgNoLBA: .ascii "no installed LBA "
dataend
