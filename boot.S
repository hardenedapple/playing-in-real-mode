.code16
.file "boot.S"
.text 0
    .globl _start

// The following has some nice pointers for where to look for different things.
// http://wiki.osdev.org/BIOS

// Memory layout:
//  0x7c00 -- 0x8600  bootloader code
//  0x8600 -- 0x8800  Linux boot code
//  0x8800 -- (0x21 * 0x200) + 0x8800 = 0xca00  Linux setup code
//  0xca00 -- (0x7f * 0x200) + 0xca00 = 0x1c800 Temporary area for reading in Linux protected code
//      Also
//  0xca00 -- (0x40 * 0x200) + 0xca00 = 0x14a00 stack & heap for linux
//  0x14c00 Kernel command line.
//
//  base_ptr = 0x8800
//  heap_end = (0x14a00 - 0x8600) = 0xc400
//  heap_end_ptr = heap_end - 0x200 = 0xc200
//  cmd_line_ptr = base_ptr + heap_end = 0x8800 + 0x14a00

#define datastart .text 1
#define dataend .text 0

#define secondstage .text 2

#define printString(str) movw str, %si; call BIOSprint
#define ERRMSG(str) movw $str, %si; call errmsg
#define BADREG(reg, str) movw reg, reg16; call printReg; ERRMSG(str)

_bootsector:
    // Just in case any odd BIOS has a non-standard %cs:%eip setup.
    ljmp $0, $_start
_start:
    // If an interrupt were called while we set up segment registers, then I'm
    // not sure what would happen. Only allow interrupts when the stack segment
    // & pointer is internally consistent with the code segment.
    cli

    // Set up those segments that we need.
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    // Though you can *address* any size up to 1MB (a little higher once A20 is
    // enabled), only up to 640kB is thought of as free RAM, while the last 384kB of
    // memory is reserved for BIOS use, video memory, memory mapped I/O.
    // Of this 640kB of RAM, the BIOS reserves the first 1.25kB and the last 1kB
    // The first 1kB is the BIOS's IVT -- I could overwrite this if I wanted (as
    // is done in http://wiki.osdev.org/Babystep5 to replace the keyhandler
    // interrupt).
    // The other reserved 0.25kB at the start of memory is BIOS data area, which
    // I can't change while being confident I'm not going to mess up any other
    // interrupt.
    // The last 1kB at the end of low memory is in order
    //   0x9fc00 1024 bytes of Extended BIOS data area
    //   0xa0000 131072 bytes of Video memory (text screen video memory is at 0xb8000
    //           for colour monitors, on these you have 32kB of text video
    //           memory to use -- getting us up to the 0xc0000 boundary of the
    //           Video BIOS).
    //           I *guess* the rest is non-text video memory, for things like
    //           direct pixel maps.
    //   0xc0000 32768 bytes of Video BIOS
    //   0xc8000 163840 bytes of Memory Mapped I/O
    //   0xf0000 65536 bytes of BIOS.
    #
    // 0x9fc00 - 0x100000 is reserved by the BIOS (as is below 0x500)

    // Put the stack pointer at the top of memory.
    // This may turn out to be a difficulty in the future, because of memory
    // layout restrictions I don't know of.
    movw $0x8fc0, %ax
    movw %ax, %ss
    movw $0xffff, %sp
    sti

    call initialiseDisks
    call clearScreen

    // Load second section into memory
    // Use the values written into diskPacket at build-time.
    call readFromHardDrive

    jmp secondStage_start


// Print the location we were called from for debugging purposes.
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
// Data section -- using text subsection so that I can use the . = _start idiom.
// If I had them in different sections I wouldn't be able to use that, as the
// assembler doesn't know which sections will be linked where.
// At position 440 into file ( 0x1b8 ) is the Disk signature for UEFI disks.
// I don't think this really matters.
diskPacket:
    // Tell the BIOS that we're not using the `extendedtransferBuffer` element
    // in this disk address packet.
    sizeofPacket: .byte 0x10
    // Byte reserved by specification, must be 0.
    packetReserved: .byte 0
    // Calculate the number of blocks needed to load at build-time.
    // Need to round up so all bytes are included, do this by adding 512 to
    // 'secondStage_end'.
    numBlocks:      .word (secondStage_end - secondStage_start) / 512
    // When reading the second part, load the data just after ourselves in
    // memory. Doesn't really matter where we load it, but that's a nice safe
    // place.
    transferBuffer: .long 0x7e00
    // Where to read from, set by the calling code.
    startBlock:     .quad 1
    // The below would be needed if needed to specify a 64 bit address for the
    // transfer buffer.
    // extendedtransferBuffer: .quad 0


// At position 446 into file ( 0x1be ) is the partition table.
// I don't think I need to have that correct.
// For each partition table entry, the first byte determines the boot flag https://en.wikipedia.org/wiki/Boot_flag

.org 0x1b8
diskID:
    .long 0xfeeeebbe
    .word 0
partitionTable:
    partition1:
        // Status - bit 7 set is for active, or bootable.
        .byte 0x80
        // CHS address of first absolute sector in partition
            // Doesn't seem to matter.
            .byte 0x00, 0x00, 0x00
        // Partition type  "BootIt"  (Just like the name).
        partition_type:
            .byte 0xdf
        // CHS address of last absolute sector in partition
            .byte 0x00, 0x00, 0x00
        // LBA of first absolute sector in partition
        // GRUB recommends 2048 sectors to install itself, so we put the
        // partition in the same place that GRUB would to ease with transition
        // in the future.
        partition_start:
            .byte 0x00, 0x08, 0x00, 0x00
        // Number of sectors in partition.
        .long 100

.org 510
    .byte 0x55, 0xAA

dataend
secondstage

#undef datastart
#undef dataend
#define datastart .text 3
#define dataend .text 2

secondStage_end_addr = (secondStage_end - _bootsector + 0x7c00)
// n.b. know because I aligned it with segment break that both of these have no
// rounding.
secondStage_end_sector = secondStage_end_addr / 0x200
secondStage_end_segment = secondStage_end_addr / 0x10

#define HEAP_SEGMENTS 0x40
secondStage_start:
    // call enablea20
    // call newline
    // Alternate function to find memory size.
    //   This is mentioned at
    //   http://lxr.linux.no/#linux+v4.10.1/Documentation/x86/boot.txt#L85
    //   vimcmd: e +1417 saved_docs/BIOSinterrupts/INTERRUP.B
    //   as the interrupt the boot loader should use to verify how much low memory
    //   is available.
    int $0x12
    // Return is AX = kilobytes of contiguous memory starting at absolute
    // address 00000h.
    // Convert into number of blocks available after the bootloader (i.e. times
    // 2 for kilobytes -> blocks).
    shlw %ax
    jnc 1f
    BADREG(%ax, msgTooMuchSpace)
1:
    // Subtract the space taken up by our bootloader.
    // Can't just use secondStage_end / 0x200 as the assembler doesn't know
    // where secondStage_end is before the linker acts, and the linker has no
    // way to do arithmetic.
    // boot.S:216: Error: invalid operands (.text and *ABS* sections) for `/'
    // Instead use the offset, which the assembler does know.
    subw $secondStage_end_sector, %ax
    movw %ax, availSpace

    call readLinux
    printString($msgGetSet)

    // Following the below vimcmd: e +965 Linux_Documentation_x86_boot.txt
    xorw %ax, %ax
    movb linuxSetupSectors, %al
    addw $HEAP_SEGMENTS, %ax
    imulw $0x200, %ax
    movw %ax, %sp
    // Second stage end segment
    movw $secondStage_end_segment, %ax
    movw %ax, %ds
    movw %ax, %ss
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    // Need a memory address to place directly in the instruction stream.
    // The first sector of the real-mode kernel code is not used.
    // We store the address to long-jump to in the first word of that unused
    // sector.
    cli
    // TODO Have hard-coded the position to jump to $(secondStage_end_segment + 0x20)
    // Would be nice to have it calculated.
    ljmp $0x880, $0

    // call getready
    printString($msgShouldNotReach)
    jmp .

findLinux:
    // TODO In the future, we read the partition start from the partition table
    // (just assume first entry). From that table, we'll check for an
    // ext[[:digit:]] fileystem, and find a file matching /boot/vmlinuz-linux-*
    // The start of that file will be placed in the vmlinuz_block location.

    // insert a nop so the symbols findLinux and readLinux are different.
    // With them being the same, the output from objdump only shows findLinux.
    nop

readLinux:
    movw $2, numBlocks
    // Load just after us (wherever that may be)
    movw $secondStage_end, transferBuffer
    // TODO Currently assuming the block position fits in 32 bits.
    // Would be nice to allow 64 bits.
    movl vmlinuz_block, %eax
    movl %eax, startBlock
    call readFromHardDrive
    movl (secondStage_end + 0x202), %eax
    // This checks for the magic signature telling us the Linux boot segment is
    // not too old it is the magic number "HdrS".
    cmpl $0x53726448, %eax
    je 1f
    ERRMSG(msgReadFailed)
    ret
1:
    // Check the protocol is greater than 2.04 (if not, that means the 'syssize'
    // member of the info flags isn't reliable, I don't account for that).
    movw (secondStage_end + 0x206), %ax
    cmpw $0x204, %ax
    jae 1f
    BADREG(%ax, msgBadVersion)
1:
    // Read how many setup sectors we have to read underneath the memory
    // barrier.
    xorl %eax, %eax
    movb (secondStage_end + 0x1f1), %al
    // If field is zero, real value is 4 http://lxr.linux.no/linux+*/Documentation/x86/boot.txt#L243
    cmpb $0, %al
    jne 1f
    movb $4, %al
1:
    // Account for the boot sector too (easier to work with that way).
    incb %al
    movb %al, linuxSetupSectors
    // Add recommended amount of space for the stack and heap, plus one sector
    // for the linux command line.
    addw $(HEAP_SEGMENTS + 1), %ax
    cmpw availSpace, %ax
    jb 1f
    BADREG(%ax, msgNoSpace)
1:
    // Read in all of the real-mode code from the file
    // Doesn't matter that we're overwriting the two blocks we just read.
    xorw %ax, %ax
    movb linuxSetupSectors, %al
    movw %ax, numBlocks
    call readFromHardDrive


    // ram_size is obsolete
    // vid_mode can be ignored -- if user puts "vga=<mode>" on command line,
    //   should place a number corresponding to the given mode in this position.
    // root_dev deprecated for the "root=" argument on the command line.
    // jump -- x86 jump instruction, can be used to determine size of header.
    // header -- magic number -- inspected above.
    // version -- used above
    // realmode_swtch -- bootloader hook to be used as last-resort.
    // start_sys_seg -- obsolete
    // kernel_version -- can point to NUL-terminated human-readable kernel
    //                   version number string. Don't need it.
    //                   Have checked manually this works -- when I checked it
    //                   all was fine.

    // type_of_loader -- obligatory byte, I use unregistered.
    movb $0xff, secondStage_end + 0x210

    // loadflags
    //   Bit 0 defines whether we should load protected-mode code at 0x10000 or
    //   at 0x100000, I know this is set on my test kernel.
    movb secondStage_end + 0x211, %al
    //   Bit 1 i used internally to decide whether to use KASLR -- we can't do
    //   anything about it.

    //   Bit 5 asks the kernel to suppress early messages.
    //   I know this is unset by default on my test kernel, but enure it's unset
    //   anyway.
    andb $(~(1 << 5)), %al
    //   Bit 6 informs the kernel that the segments are all valid when in the 32
    //   bit entry point.
    //   Unset that to get the kernel to do the work for us.
    andb $(~(1 << 6)), %al
    //   Bit 7 indicates that the value stored in heap_end_ptr is valid and
    //   hence that the kernel can use the head.
    orb $(1 << 7), %al
    movb %al, secondStage_end + 0x211
    testb $0x1, %al
    movl $0x10000, %eax
    jz 1f
    imull $0x10, %eax
1:
    movl %eax, protectedLoadAddr

    // setup_move_size -- can be ignored if protocol is 2.02 or higher.
    //                   I check above that protocol >= 2.04
    // code32_start -- optional, either bootloader hook or loading at
    //                 nonstandard address.

    // ramdisk_image -- 32 bit linear address of initial ramdisk or ramfs
    //                   leave at zero if no initial ramdisk.
    movl secondStage_end + 0x218, %eax
    cmpl $0, %eax
    je 1f
    BADREG(%ax, msgRamdiskNotZero)
1:
    // ramdisk_size -- size of initial ramdisk or ramfs
    //                   leave at zero if no initial ramdisk.
    movl secondStage_end + 0x21c, %eax
    cmpl $0, %eax
    je 1f
    BADREG(%ax, msgRamdiskSizeNotZero)
1:
    // bootsect_kludge -- obsolete
    // heap_end_ptr -- handled below
    // ext_loader_ver  -- don't need to write
    //                    vimcmd: e +498 Linux_Documentation_x86_boot.txt
    // ext_loader_type -- don't need to write

    // cmdline_size -- Check our command line isn't too large.
    movl secondStage_end + 0x238, %eax
    cmpl $linuxCmdLineSize, %eax
    jae 1f
    BADREG(%ax, msgCMDtooLong)
1:
    // heap_end_ptr -- offset from beginning of real-mode code to end of
    //                   stack/heap, minus 0x200
    // real-mode code
    xorw %ax, %ax
    movb linuxSetupSectors, %al
    // Plus heap space minus 0x200
    addw $(HEAP_SEGMENTS - 1), %ax
    imulw $0x200, %ax
    movw %ax, secondStage_end + 0x224

    // initrd_addr_max -- read to do with ramdisk -- don't need
    // kernel_alignment -- Don't bother with this as not relocating the kernel.
    // relocatable_kernel -- Don't bother with this as not relocating the kernel.
    // min_alignment -- Don't bother with this as not relocating the kernel.
    // xloadflags:
    //   Bit 1 specifies whether things can be above 4G (ignore, not doing it)
    //   Bit 2, 3, and 4, talk about EFI (ignore, not doing it).
    //   Bit 0 mentions whether the kernel has the legacy 64-bit entry point at
    //           0x200

    // cmdline_size -- handled above
    // hardware_subarch -- paravirtualized environments, optional, are ignoring.
    //   vimcmd: e +630 Linux_Documentation_x86_boot.txt
    // hardware_subarch_data -- unused for x86
    // payload_offset -- offset from beginning of protected-mode code to
    //                   payload, don't know if I need this.
    // payload_length -- length of payload.
    // setup_data -- extra information to the kernel.
    //               don't think I need it.

    // pref_address -- preferred load address for the kernel.
    //   a relocating bootloader should attempt to load at this address.
    //   I'm not a relocating bootloader -- I believe I can ignore this.

    // init_size -- doesn't seem to be needed.
    // handover_offset -- for EFI, can ignore.

    call read32bitLinux

    // Put the command line in the correct place.
    // This has to be done after reading in the protected mode kernel code
    // to ensure it doesn't get overwritten.
    xorl %eax, %eax
    // cmd_line_ptr   -- where we store the linux command line.
    movb linuxSetupSectors, %al
    addw $HEAP_SEGMENTS, %ax
    addw $secondStage_end_sector, %ax
    // * 512 / 16
    // Must be less than the size of the register because we know the size fits
    // within the available space in the 16bit address space.
    imulw $0x20, %ax
    movw %ax, %es
    // Store the cmd_line_ptr in the Linux header, put the flat 32 bit address
    // into %eax.
    imull $0x10, %eax
    movl %eax, secondStage_end + 0x228
    movw $0, %di
    movw $linuxCmdLine, %si
    movw $linuxCmdLineSize, %cx

    // es:di == [destination]:0
    // ds:si == 0:linuxCmdLine
    // cx    == linuxCmdLineSize
    rep; movsb

    // Reset the extended segment.
    xorw %ax, %ax
    movw %ax, %es

    ret

// 0x35b after _bootsector == 0x7f5b
read32bitLinux:
    // Have to make sure we only use the spare space.
    // That is the space after secondStage_end + linuxSetupSectors*512
    // Only read in 0x7f sectors at a time (this limit comes from the BIOS
    // interrupt -- see readFromHardDrive).
    // Double check that 0x7f is less than availSpace - linuxSetupSectors

    movl secondStage_end + 0x1f4, %eax
    movl $0, %edx
    movl $(0x200 / 0x10), %ebx
    divl %ebx
    // Round up if there's a remainder.
    cmpl $0, %edx
    je 1f
    incl %eax
1:
    // Here, %eax contains the number of segments we need to read.
    cmpl $0xffff, %eax
    jb 1f
    ERRMSG(msgTooMuchProtected)
    jmp .
1:
    movw %ax, protectedSegments

    // Find how much space we can use at a time to load the protected mode code.
    xorw %ax, %ax
    movb linuxSetupSectors, %al
    movw availSpace, %bx
    subw %ax, %bx
    cmpw $0x7f, %bx
    jae 1f
    BADREG(%ax, msgNeedReadPartial)
    jmp .
1:

    // Record the position we can load into without overwriting anything.
    imulw $0x200, %ax
    addw $secondStage_end, %ax
    movw %ax, transferBuffer
    movw %ax, moveGDTsource

    // Find where we need to load from -- vmlinuz_block + linuxSetupSectors
    // vimcmd: e +897 Linux_Documentation_x86_boot.txt
    xorl %eax, %eax
    movb linuxSetupSectors, %al
    addl vmlinuz_block, %eax
    movl %eax, startBlock

    // Ensure es is zero for this loop
    movw $0, %ax
    movw %ax, %es
    // Loop
read32:
    //   Read 0x7f sectors from the hard-drive into transferBuffer
    movw $0x7f, numBlocks
    call readFromHardDrive
    //   Move 0x7f sectors (127 * 512 / 2 = 0x7f00 words) from transferBuffer to 0x100000
    movb $0x87, %ah
    movw $0x7f00, %cx
    movw $gdtForMove, %si
    int $0x15
    jae 1f
    BADREG(%ax, msgCopyError)
    jmp .
1:
    // Add 0xfe00 to the destination address (for the next packet)
    // 127 * 512 bytes copied
    addw $0xfe00, moveGDTdest
    adcb $0, moveGDTdest + 2

    // Add 0x7f to the block we need to read from.
    addl $0x7f, startBlock

    //   subtract 0x7f from protectedSegments
    subw $0x7f, protectedSegments

    //   if protectedSegments is still positive, GOTO Loop
    ja read32
    ret



#include "a20.asm"
#include "checkstate.asm"

datastart
availSpace: .word 0
linuxSetupSectors: .byte 0
linuxProtectedSize: .long 0

protectedLoadAddr: .long 0x100000
vmlinuz_block: .long 1579336
msgTooMuchSpace: .asciz "Overflow calculating space"
msgRamdiskNotZero: .asciz "Initial ramdisk pointer is not 0"
msgRamdiskSizeNotZero: .asciz "Initial ramdisk size is not 0"
msgNoMagic: .asciz "no magic linux"
msgBadVersion: .asciz "old Linux boot version"
msgNoSpace: .asciz "not enough space"
msgCMDtooLong: .asciz "linux command line too large"
msgTooMuchProtected: .asciz "too much protected kernel to read"
msgCopyError: .asciz "interrupt failure moving protected mode bytes"
msgHandleLargerAddresses: .asciz "Load address too high for 16 bit value"
msgNeedReadPartial: .asciz "Can't use 0x7f block size reads"
msgShouldNotReach: .asciz "Should not reach this position"
msgGetSet: .asciz "Ready ... Set ... Go!!!\n\r"

readAddr: .word 0
moveAddr: .long 0
protectedSegments: .word 0
availTempSpace: .word 0

// vimcmd: e +5602 saved_docs/BIOSinterrupts/INTERRUP.C
gdtForMove:
    // Space used by BIOS
    .quad 0, 0
    // number of bytes to copy, = 2*cx where cx is always 0x7f00
    .word 0xfe00
moveGDTsource:
    .byte 0, 0, 0
    // access rights
    .byte 0x93
	.word	0

    // Destination part of gdt
	.word	0xffff
moveGDTdest:
    // Start off loading at 0x100000
    // This will be incremented with use.
    .byte 0, 0, 0x10
    // access rights
    .byte 0x93
    .word 0
    // Space used by BIOS
    .quad 0, 0


// TODO Allow user to choose command line.
// linuxCmdLine: .asciz "root=UUID=ff9be8c0-4821-4d00-8046-78db6f7303b4 ro  quiet"
linuxCmdLine: .asciz "auto debug"
linuxCmdLineSize = . - linuxCmdLine
.align 512
secondStage_end:
dataend
