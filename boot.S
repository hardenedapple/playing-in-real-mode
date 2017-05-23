.code16
.file "boot.S"
.text 0
    .globl _start

# The following has some nice pointers for where to look for different things.
# http://wiki.osdev.org/BIOS

#define datastart .text 1
#define dataend .text 0

#define secondstage .text 2

#define printString(str) movw str, %si; call BIOSprint
#define ERRMSG(str) movw $str, %si; call errmsg
#define BADREG(reg, str) movw reg, reg16; call printReg; ERRMSG(str)

_bootsector:
    # Just in case any odd BIOS has a non-standard %cs:%eip setup.
    ljmp $0, $_start
_start:
    # If an interrupt were called while we set up segment registers, then I'm
    # not sure what would happen. Only allow interrupts when the stack segment
    # & pointer is internally consistent with the code segment.
    cli

    # Set up those segments that we need.
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    # Though you can *address* any size up to 1MB (a little higher once A20 is
    # enabled), only up to 640kB is thought of as free RAM, while the last 384kB of
    # memory is reserved for BIOS use, video memory, memory mapped I/O.
    # Of this 640kB of RAM, the BIOS reserves the first 1.25kB and the last 1kB
    # The first 1kB is the BIOS's IVT -- I could overwrite this if I wanted (as
    # is done in http://wiki.osdev.org/Babystep5 to replace the keyhandler
    # interrupt).
    # The other reserved 0.25kB at the start of memory is BIOS data area, which
    # I can't change while being confident I'm not going to mess up any other
    # interrupt.
    # The last 1kB at the end of low memory is in order
    #   0x9fc00 1024 bytes of Extended BIOS data area
    #   0xa0000 131072 bytes of Video memory (text screen video memory is at 0xb8000
    #           for colour monitors, on these you have 32kB of text video
    #           memory to use -- getting us up to the 0xc0000 boundary of the
    #           Video BIOS).
    #           I *guess* the rest is non-text video memory, for things like
    #           direct pixel maps.
    #   0xc0000 32768 bytes of Video BIOS
    #   0xc8000 163840 bytes of Memory Mapped I/O
    #   0xf0000 65536 bytes of BIOS.
    #
    # 0x9fc00 - 0x100000 is reserved by the BIOS (as is below 0x500)

    # Put the stack pointer at the top of memory.
    # This may turn out to be a difficulty in the future, because of memory
    # layout restrictions I don't know of.
    movw $0x8fc0, %ax
    movw %ax, %ss
    movw $0xffff, %sp
    sti

    call initialiseDisks
    call clearScreen

    # Load second section into memory
    # Use the values written into diskPacket at build-time.
    call readFromHardDrive

    jmp secondStage_start
    

# Print the location we were called from for debugging purposes.
errmsg:
    call BIOSprint
    popw %ax
    movw %ax, reg16
    pushw %ax
    call printReg
    ret


#include "printing.asm"
#include "disk.asm"
.file "boot.S"

datastart
# Data section -- using text subsection so that I can use the . = _start idiom.
# If I had them in different sections I wouldn't be able to use that, as the
# assembler doesn't know which sections will be linked where.
# At position 440 into file ( 0x1b8 ) is the Disk signature for UEFI disks.
# I don't think this really matters.
diskPacket:
    # Tell the BIOS that we're not using the `extendedtransferBuffer` element
    # in this disk address packet.
    sizeofPacket: .byte 0x10
    # Byte reserved by specification, must be 0.
    packetReserved: .byte 0
    # Calculate the number of blocks needed to load at build-time.
    # Need to round up so all bytes are included, do this by adding 512 to
    # 'secondStage_end'.
    numBlocks:      .word (secondStage_end - secondStage_start) / 512
    # When reading the second part, load the data just after ourselves in
    # memory. Doesn't really matter where we load it, but that's a nice safe
    # place.
    transferBuffer: .long 0x7e00
    # Where to read from, set by the calling code.
    startBlock:     .quad 1
    # The below would be needed if needed to specify a 64 bit address for the
    # transfer buffer.
    # extendedtransferBuffer: .quad 0

successMsg: .asciz "YAY"


# At position 446 into file ( 0x1be ) is the partition table.
# I don't think I need to have that correct.
# For each partition table entry, the first byte determines the boot flag https://en.wikipedia.org/wiki/Boot_flag

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
        # Partition type  "BootIt"  (Just like the name).
        partition_type:
            .byte 0xdf
        # CHS address of last absolute sector in partition
            .byte 0x00, 0x00, 0x00
        # LBA of first absolute sector in partition
        # GRUB recommends 2048 sectors to install itself, so we put the
        # partition in the same place that GRUB would to ease with transition
        # in the future.
        partition_start:
            .byte 0x00, 0x08, 0x00, 0x00
        # Number of sectors in partition.
        .long 100

.org 510
    .byte 0x55, 0xAA

dataend
secondstage

#undef datastart
#undef dataend
#define datastart .text 3
#define dataend .text 2

secondStage_start:
    call enablea20
    call newline
    # Alternate function to find memory size.
    #   This is mentioned at
    #   http://lxr.linux.no/#linux+v4.10.1/Documentation/x86/boot.txt#L85
    #   vimcmd: e +1417 saved_docs/BIOSinterrupts/INTERRUP.B
    #   as the interrupt the boot loader should use to verify how much low memory
    #   is available.
    int $0x12
    # Return is AX = kilobytes of contiguous memory starting at absolute
    # address 00000h.
    # Convert into number of blocks available after the bootloader (i.e. times
    # 2 for kilobytes -> blocks).
    shlw %ax
    jnc 1f
    BADREG(%ax, msgTooMuchSpace)
1:
    # Subtract the space taken up by our bootloader.
    # Can't just use secondStage_end / 0x200 as the assembler doesn't know
    # where secondStage_end is before the linker acts, and the linker has no
    # way to do arithmetic. 
    # boot.S:216: Error: invalid operands (.text and *ABS* sections) for `/'
    # Instead use the offset, which the assembler does know.
    subw $(((secondStage_end - _bootsector + 0x7c00) / 0x200) + 1), %ax
    movw %ax, availSpace

    call readLinux

    # call getready
    printString($successMsg)
    jmp .

findLinux:
    # TODO In the future, we read the partition start from the partition table
    # (just assume first entry). From that table, we'll check for an
    # ext[[:digit:]] fileystem, and find a file matching /boot/vmlinuz-linux-* 
    # The start of that file will be placed in the vmlinuz_block location.

readLinux:
    movw $2, numBlocks
    # Load just after us (wherever that may be)
    movw $secondStage_end, transferBuffer
    # TODO Currently assuming the block position fits in 32 bits.
    # Would be nice to allow 64 bits.
    movl vmlinuz_block, %eax
    movl %eax, startBlock
    call readFromHardDrive
    movl (secondStage_end + 0x202), %eax
    # This checks for the magic signature telling us the Linux boot segment is
    # not too old.
    cmpl $0x53726448, %eax
    je 1f
    ERRMSG(msgReadFailed)
    ret
1:
    # Check the protocol is greater than 2.04 (if not, that means the 'syssize'
    # member of the info flags isn't reliable, I don't account for that).
    movw (secondStage_end + 0x206), %ax
    cmpw $0x204, %ax
    jae 1f
    BADREG(%ax, msgBadVersion)
1:
    # Read how many setup sectors we have to read underneath the memory
    # barrier.
    xorl %eax, %eax
    movb (secondStage_end + 0x1f1), %al
    # If field is zero, real value is 4 http://lxr.linux.no/linux+*/Documentation/x86/boot.txt#L243
    cmpb $0, %al
    jne 1f
    movb $4, %al
1:
    movb %al, linuxSetupSectors
    # Add recommended amount of space for the stack and heap
    addw $0x80, %ax
    cmpw availSpace, %ax 
    jb 1f
    BADREG(%ax, msgNoSpace)
1:
    # Read in all of the real-mode code from the file
    # Doesn't matter that we're overwriting the two blocks we just read.
    movw %ax, numBlocks
    call readFromHardDrive

    # Work with syssize.
    ret

#include "a20.asm"
#include "checkstate.asm"

datastart
availSpace: .word 0
linuxSetupSectors: .byte 0
linuxProtectedSize: .long 0

vmlinuz_block: .long 1579336
msgTooMuchSpace: .asciz "Overflow calculating space"
msgNoMagic: .asciz "no magic linux"
msgBadVersion: .asciz "old Linux boot version"
msgNoSpace: .asciz "not enough space"

linuxCmdLine: .asciz "root=UUID=ff9be8c0-4821-4d00-8046-78db6f7303b4 ro  quiet"
.align 512
secondStage_end:
dataend
