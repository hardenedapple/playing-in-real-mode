.file "checkstate.asm"
// General functions to check the current state of the world.
// Loaded in real-mode as an MBR -- may very well be as part of the boot1 stage.
// Makes heavy use of the BIOS provided interrupts.
#
// http://wiki.osdev.org/Rolling_Your_Own_Bootloader
readMemorySize:
    // Contigious memory 
    // vimcmd: e +1417 saved_docs/BIOSinterrupts/INTERRUP.B
    #
    // In newer BIOSes, get system memory map
    // vimcmd: e +69 saved_docs/BIOSinterrupts/INTERRUP.D
    // NOTE:
    //   The description linked above says the two ways that BIOS's are
    //   permitted to indicate the end of the list are to return %ebx with $0 or
    //   to return non-zero %ebx and set the CF on the next iteration.
    //       I don't account for the second option.
    // Magic numbers.
    movl $0x534D4150, %edx
    // Continuation value (see the BIOS interrupt link above).
    movl $0, %ebx
loop_again:
    movl $0x0000e820, %eax
    // Size of buffer for result.
    movl $(memmap_end - memmap_start), %ecx
    // Location of buffer (assuming %es is at 0).
    movw $memmap_start, %di
    int $0x15
    jnc 1f
    ERRMSG(msgMemSizeFailed)
    jmp .
1:
    cmpl $0x534D4150, %eax
    je 1f
    ERRMSG(msgMemSizeFailed)
    jmp .
1:
    cmpl $20, %ecx
    je 1f
    ERRMSG(msgMemSizeFailed)
    jmp .
1:
    pushl %ebx
    movw $memmap_start, %ax
    call printQWORD
    movw $(memmap_start + 8), %ax
    call printQWORD
    movw $(memmap_start + 0x10), %ax
    call printDWORD
    call newline

    popl %ebx
    cmpl $0, %ebx
    je memmapexit
    jmp loop_again
memmapexit:
    ret
    // Print out information about the system map
    // Not really much else interesting to do, we're not loading anything as yet.


getAvailableVideoModes:
    // Have no idea how to do this at the moment, but the
    // Rolling_Your_Own_Bootloader wiki page says it's easier in Real mode.
    #

datastart
// Buffer for memory map, load one entry at a time.
// Loading one entry at a time to fully exercise the iteration code, once that
// seems to be working fine, I'll go on to loading 2 at a time to make sure the
// counter increments correctly before finally loading however many entries my
// machine returns at a time to make sure the edge case of no iteration is
// handled correctly too.
msgMemSizeFailed: .asciz "getting memory size failed"
memmap_start:
    // .skip 100, 0
    .skip 20, 0
memmap_end:
dataend
