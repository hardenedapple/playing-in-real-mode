.file "disk.asm"
saveDiskNum:
    # BIOS initially puts the disk number that we're booting from into %dl.
    # This register value is also the argument that int 0x13 takes to know
    # which disk number to read from.
    # Rather than ensuring I don't change that register all the time, I'm just
    # going to store it in memory.
    # This will be
    # 0x00 for first floppy drive, 0x01 for second,
    # 0x80 for first hard drive,   0x81 for second,
    movb %dl, currentdisk
    ret

initialiseDisks:
    # Before interacting with the disks, apparently we have to reset the disk
    # system to a known state using BIOS interrupt
    # vimcmd: e +1579 saved_docs/BIOSinterrupts/INTERRUP.B
    # I read this in saved_docs/bootloader-from-scratch.pdf
    # TODO
    ret

getDiskState:
    # vimcmd: e +2023 saved_docs/BIOSinterrupts/INTERRUP.B
    # The DISK interrupt that GRUB appears to use (gotten from disassembly of
    # the MBR on my laptop).

readSector:
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
    movw $msgFail, %si
    call BIOSprint
    jmp hang
2:
    pushw %ax
3:
    movb $0x02, %ah # Read disk function
    movb (currentdisk), %dl # drive number
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

datastart 
currentdisk: .byte 0
msgFail: .asciz "something has gone wrong ..."
dataend
