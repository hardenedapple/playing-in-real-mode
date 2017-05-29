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
    //
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

#define setup_sects           secondStage_end + 0x1f1
#define root_flags            secondStage_end + 0x1f2
#define syssize               secondStage_end + 0x1f4
#define ram_size              secondStage_end + 0x1f8
#define vid_mode              secondStage_end + 0x1fa
#define root_dev              secondStage_end + 0x1fc
#define boot_flag             secondStage_end + 0x1fe
#define jump                  secondStage_end + 0x200
#define header                secondStage_end + 0x202
#define version               secondStage_end + 0x206
#define realmode_swtch        secondStage_end + 0x208
#define start_sys_seg         secondStage_end + 0x20c
#define kernel_version        secondStage_end + 0x20e
#define type_of_loader        secondStage_end + 0x210
#define loadflags             secondStage_end + 0x211
#define setup_move_size       secondStage_end + 0x212
#define code32_start          secondStage_end + 0x214
#define ramdisk_image         secondStage_end + 0x218
#define ramdisk_size          secondStage_end + 0x21c
#define bootsect_kludge       secondStage_end + 0x220
#define heap_end_ptr          secondStage_end + 0x224
#define ext_loader_ver        secondStage_end + 0x226
#define ext_loader_type       secondStage_end + 0x227
#define cmd_line_ptr          secondStage_end + 0x228
#define initrd_addr_max       secondStage_end + 0x22c
#define kernel_alignment      secondStage_end + 0x230
#define relocatable_kernel    secondStage_end + 0x234
#define min_alignment         secondStage_end + 0x235
#define xloadflags            secondStage_end + 0x236
#define cmdline_size          secondStage_end + 0x238
#define hardware_subarch      secondStage_end + 0x23c
#define hardware_subarch_data secondStage_end + 0x240
#define payload_offset        secondStage_end + 0x248
#define payload_length        secondStage_end + 0x24c
#define setup_data            secondStage_end + 0x250
#define pref_address          secondStage_end + 0x258
#define init_size             secondStage_end + 0x260
#define handover_offset       secondStage_end + 0x264

#define HEAP_SEGMENTS 0x40
secondStage_start:
    call enablea20
    call newline
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
    ljmp $0x8a0, $0

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
    movl (header), %eax
    // This checks for the magic signature telling us the Linux boot segment is
    // not too old it is the magic number "HdrS".
    cmpl $0x53726448, %eax
    je 1f
    ERRMSG(msgReadFailed)
    ret
1:
    // Check the protocol is greater than 2.04 (if not, that means the 'syssize'
    // member of the info flags isn't reliable, I don't account for that).
    movw (version), %ax
    cmpw $0x204, %ax
    jae 1f
    BADREG(%ax, msgBadVersion)
1:
    // Read how many setup sectors we have to read underneath the memory
    // barrier.
    xorl %eax, %eax
    movb (setup_sects), %al
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
    movb $0xff, type_of_loader

    // loadflags
    //   Bit 0 defines whether we should load protected-mode code at 0x10000 or
    //   at 0x100000, I know this is set on my test kernel.
    movb loadflags, %al
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
    movb %al, loadflags
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

    // NOTE We will set these in readInitrd, but for now we just check that
    // they are both 0 by default.
    // ramdisk_image -- 32 bit linear address of initial ramdisk or ramfs
    //                   leave at zero if no initial ramdisk.
    movl ramdisk_image, %eax
    cmpl $0, %eax
    je 1f
    BADREG(%ax, msgRamdiskNotZero)
1:
    // ramdisk_size -- size of initial ramdisk or ramfs
    //                   leave at zero if no initial ramdisk.
    movl ramdisk_size, %eax
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
    movl cmdline_size, %eax
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
    movw %ax, heap_end_ptr

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

    // handover_offset -- for EFI, can ignore.

    // Find how much space we can use at a time to load in code that has to be
    // moved afterwards.
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

    call read32bitLinux
    call readInitrd

    // Put the command line in the correct place.
    // This is done after reading in the protected mode kernel code so we can
    // not worry about overwriting it while we load in the protected mode code.
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
    movl %eax, cmd_line_ptr
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

    movl syssize, %eax
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
    movw %ax, numSegments

    // Find where we need to load from -- vmlinuz_block + linuxSetupSectors
    // vimcmd: e +897 Linux_Documentation_x86_boot.txt
    xorl %eax, %eax
    movb linuxSetupSectors, %al
    addl vmlinuz_block, %eax
    movl %eax, startBlock

    call readAndMove
    ret

setInitRdFlags:
    // initrd_addr_max -- Maximum address that the ramdisk can use.
    movl initrd_addr_max, %eax
    // Compare initrd_addr_max to initrdLoadAddr + length of first
    movl initrdFirstLength, %ebx
    addl initrdSecondLength, %ebx
    imull $0x200, %ebx
    jno 1f
    ERRMSG(msgInitrdOverflowAddr)
    jmp .
1:
    addl initrdLoadAddr, %ebx
    cmpl %ebx, %eax 
    ja 1f
    ERRMSG(msgInitrdLowAddr)
    jmp .
1:
    // init_size -- amount of linear contiguous memory starting at the kernel
    // runtime start address, that the kernel needs before it's capable of
    // examining its memory map.
    // TODO Should calculate the load address given these values.
    movl init_size, %eax
    addl protectedLoadAddr, %eax
    movl initrdLoadAddr, %ebx
    cmpl %eax, %ebx
    ja 1f
    ERRMSG(msgNotEnoughSpare)
    jmp .
1:

    // ramdisk_size -- size of initial ramdisk or ramfs
    // Can't know this without parsing the filesystem information.
    // I got this number from `wc -c`
    movl initrdByteSize, %eax
    movl %eax, ramdisk_size
    // ramdisk_image -- 32 bit linear address of initial ramdisk or ramfs
    //                   leave at zero if no initial ramdisk.
    movl initrdLoadAddr, %eax
    movl %eax, ramdisk_image

    ret

readInitrd:
    // transfer buffer is already set before calling this function.
    xorw %ax, %ax
    // moveDest currently points to the end of the kernel.
    // Change it to point to where we want the ramdisk loaded.
    movl initrdLoadAddr, %eax
    movl %eax, moveDest
    call setInitRdFlags

    movl initrdFirstBlock, %eax
    movl %eax, startBlock
    movl initrdFirstLength, %eax
    movl %eax, numSegments
    call readAndMove

    // TODO This shouldn't be necessary, but getting things to work without
    // hard-coding is harder than with. I'll get round to it later.
    movl initrdLoadAddr, %eax
    addl initrdFirstLengthBytes, %eax
    movl %eax, moveDest

    movl initrdSecondBlock, %eax
    movl %eax, startBlock
    movl initrdSecondLength, %eax
    movl %eax, numSegments
    call readAndMove
    ret
    
readAndMove:
    // Called with the following setup
    // transferBuffer   temporary load area containing at least 0x7f sectors
    // startBlock       first block (LBA) to read from.
    // numSegments      number of segments to read (and move).
    // moveDest      final destination address of data
    //
    // Always copy 0xfe00 bytes at a time (because that's how much we can read
    // in at a time, and we round up rather than handle remainders).
    xorl %eax, %eax
    movw transferBuffer, %ax
    movw $datadesc, %bx
    call setDescriptorBase
    xorw %ax, %ax
    movw %ax, %es

readandMoveLoop:
    movw $0x7f, numBlocks
    call readFromHardDrive

    // Set the segment we'll use for the extended segment register.
    // This will have the base address of a moveDest
    movl moveDest, %eax
    movw $extradesc, %bx
    call setDescriptorBase

    //      Disallow interrupts -- we'll be in protected mode, but without an
    //      IDT table, better safe than sorry.
    cli
        //      Save real mode segments
        push %ds
        push %es

        // Turn on protected-mode
        lgdt gdtinfo
        movl %cr0, %eax
        orb  $1, %al
        movl %eax, %cr0

        // Set the data segment and extended segment to a nice flat descriptor.
        // TODO See if I actually need to set the data segment -- all bytes in the
        // source can be addressed with 16 bit registers.
        movw $0x08, %bx
        movw %bx, %ds
        // Use extradesc for the extended segment.
        shlw $1, %bx
        movw %bx, %es

        // Move 0x7f sectors (127 * 512 / 2 = 0x7f00 words) from transferBuffer to moveDest
        // Move %ecx double words -- each double word consists of 4 bytes
        movl $0xfe00, %ecx
        xorl %esi, %esi
        xorl %edi, %edi
        // ds:si == transferBuffer:0
        // es:di == moveDest:0
        // cx == num double words.
        rep;
        movsb

        // Reset back to realmode
        andb $0xfe, %al
        movl %eax, %cr0
        // Get back old segments
        pop %ds
        pop %es

    // Turn interrupts back on
    sti

    // Add 0xfe00 to the destination address (for the next packet)
    // 127 * 512 bytes copied
    addl $0xfe00, moveDest
    jnc 1f
    ERRMSG(msgMoveTooMuch)
    jmp .
1:
    // Add 0x7f to the block we need to read from.
    addl $0x7f, startBlock
    //   subtract 0x7f from numSegments
    subw $0x7f, numSegments
    //   if numSegments is still positive, GOTO Loop
    ja readandMoveLoop
//     For now, we're not handling the fact that we round up.
//     we're just going to hard-code that to try and get something working, and
//     then come back to it later.
//     // numSegments contains minus the number of segments moved more than what
//     // we were asked to move.
//     // In order to leave moveDest in the correct position, we multiply by 0x200
//     // and add that to moveDest.
//     xorl %eax, %eax
//     movswl numSegments, %eax
//     imull $0x200, %eax
//     addl %eax, moveDest
//     jns 1f
//     BADREG(%ax, msgSegmentProblem)
// 1:
    ret

setDescriptorBase:
    // Given a base address in %eax, and a descriptor offset in %bx, set the
    // base address of the descriptor to the address specified in %eax.
    movw %ax, 2(%bx)
    shrl $0x10, %eax
    movb %al, 4(%bx)
    movb %ah, 7(%bx)
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
msgInitrdOverflowAddr: .asciz "Guessed load address of initrd overflows"
msgInitrdLowAddr: .asciz "Guessed load address of initrd is too high"
msgInitrdTooLarge: .asciz "Overflow calculating initrd size"
msgMoveTooMuch: .asciz "Overflow reading & moving data"
msgSegmentOverflow: .asciz "Subtracting number of bytes from moveDest overflow"
msgSegmentProblem: .asciz "Sign set after arithmetic on moveDest"
msgNotEnoughSpare: .asciz "Not enough space after the kernel."

readAddr: .word 0
moveAddr: .long 0
numSegments: .word 0
availTempSpace: .word 0

// For now hard-code initrd load address, in the future should calculate from
// the initrd_addr_max value, and the max memory address of the kernel.
// NOTE: This was manually taken from 
//      sudo hdparm --fibmap /mnt/usb/boot/initrd.img-3.16.0-4-686-pae
initrdLoadAddr: .long 0xb00000
initrdFirstBlock: .long 0x3d0800
initrdFirstLength: .long 0x4000
initrdFirstLengthBytes: .long 8388608
initrdSecondBlock: .long 0x3d4e00
initrdSecondLength: .long 0x2f18
// Can't get this by adding up the number of segments and multiplying by 512
// because the last segment can be only partially used.
// We get this value from `wc -c <initrdfile>`.
initrdByteSize: .long 0xde27a4

gdtinfo:
    .word gdt_end - gdt - 1 // last byte in table
    .long gdt               // start of table

gdt:        .long 0, 0  // entry 0 is always unused.
datadesc:   .byte 0xff, 0xff, 0, 0, 0, 0b10010011, 0b1001111, 0
extradesc:    .byte 0xff, 0xff, 0, 0, 0, 0b10010011, 0b1001111, 0
gdt_end:

moveDest: .long 0x100000


// TODO Allow user to choose command line.
linuxCmdLine: .asciz "debug root=UUID=ff9be8c0-4821-4d00-8046-78db6f7303b4 ro console=ttyS0,115200,8,n"
# linuxCmdLine: .asciz "root=UUID=ff9be8c0-4821-4d00-8046-78db6f7303b4 auto debug"
linuxCmdLineSize = . - linuxCmdLine
.align 512
secondStage_end:
dataend
