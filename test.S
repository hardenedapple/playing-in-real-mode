.code16                 # generate 16-bit code
.text                   #executable code location
    .globl _start
_start:                 # code entry point

    jmp _boot
    data : .asciz "This is a boot loader"
    # NOTE, note '(as)Set' in the info manual for `as`, mentions something that
    # may be troublesome ... "Values that are based on expressions involving
    # other symbols are allowed, but some targets may restrict this to only
    # being done once per assembly" ... I don't know whether this is the case
    # on my laptop with x86 target ...
    .macro mprintString start_pos
        pushw %si
        movw \start_pos, %si
        call printString
        popw %si
    .endm
    printString:
        movb $0x0e, %ah
        cld
    # These are local symbols, they aren't stored in the object file.
    # See "(as) Symbol Names" for a reliable source.
    .LprintStringIn:
        lodsb
        cmp $0x0, %al
        je  .LprintStringOut
        int $0x10
        jmp .LprintStringIn
    .LprintStringOut:
    # Original code is below ... I don't like running the movb $0x0e, %ah
    # instruction every iteration through the loop when it's not necessary (see
    # vimcmd: e +/AH\ =\ 0E/ saved_docs/BIOSinterrupts/INTERRUP.A
    # Also, I don't like relying on the direction flag being set.
    # This is probably fine (assuming based on the fact that this tutorial
    # hasn't made any obvious mistakes so far) ... but I haven't found anything
    # saying that it is fine, so I'm not going to assume it.
    #
    #
    # printString:
    # printStringIn:
    #     lodsb
    #     orb %al, %al
    #     jz printStringOut
    #     movb $0x0e, %ah
    #     int $0x10
    #     jmp printStringIn
    # printStringOut:
    ret
_boot:
    movw $0x7c0, %ax
    movw %ax, %ds
    # Get `as` to calculate the offset for me.
    # I don't like relying on the knowledge that the jmp _boot instruction is 2
    # bytes long.
    mprintString $(data - _start)
_freeze:
    jmp _freeze

    . = _start + 510    # move to 510th byte from 0 pos
    .byte 0x55          # append boot signature
    .byte 0xaa          # append boot signature

