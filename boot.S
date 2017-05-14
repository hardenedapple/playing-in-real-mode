.code16
.file "boot.S"
.text 0
    .globl _start

#define datastart .text 1
#define dataend .text 0

#define secondstage .text 2

    # Just in case any odd BIOS has a non-standard %cs:%eip setup.
    ljmp $0, $_start
_start:
    call saveDiskNum
    call initialiseDisks
    call clearScreen

    # Set up those segments that we need.
    xorw %ax, %ax
    movw %ax, %ds
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

    # # TODO Stack pointer -- top of non-reserved memory.
    # # (why not?).
    # movw $0x8fc0, %ax
    # movw %ax, %ss
    # movw $0xffff, %sp

    movw %ax, %ss
    movw $0x9c00, %sp

    # Read in the second sector of my bootloader.
    movb $0x01, %al # Number of sectors to read TODO calculate this from size.
    movb $0x00, %ch # cylinder number
    # sector number in bits 0-5,
    # high two bits of cylinder in 6-7 for hard-disks
    # Take this value from the argument passed by the caller.
    # Getting it from the stack makes the most sense, as ax, cx, and dx are
    # used for the BIOS call, and bx is used as a destination.
    movb 0x2(%bp),  %cl
    movb $0x00, %dh # head number
    # call

hang:
    jmp .

#include "printing.asm"
#include "checkstate.asm"
#include "disk.asm"

datastart
# Data section -- using text subsection so that I can use the . = _start idiom.
# If I had them in different sections I wouldn't be able to use that, as the
# assembler doesn't know which sections will be linked where.
# At position 440 into file ( 0x1b8 ) is the Disk signature for UEFI disks.
# I don't think this really matters.

# At position 446 into file ( 0x1be ) is the partition table.
# I don't think I need to have that correct.
# For each partition table entry, the first byte determines the boot flag https://en.wikipedia.org/wiki/Boot_flag

    . = _start + 510
    .byte 0x55, 0xAA

secondstage

#undef datastart
#undef dataend
#define datastart .text 4
#define dataend .text 3

secondStage_start:
    call enablea20

#include "a20.asm"
