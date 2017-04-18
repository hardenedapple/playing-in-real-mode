.code16                 # generate 16-bit code
.text                   #executable code location
    .globl _start
_start:                 # code entry point

    jmp _boot
    data : .byte 'X'
    data1: .byte 'Y'
_boot:
    movw $0x7c0, %ax
    movw %ax, %ds
    movb data - _start, %al # Don't have to rely on the knowledge that the jmp
                            # instruction will be two bytes
    movb $0x0e, %ah
    int $0x10
    movb 0x03, %al
    # movb $0x0e, %ah     # Interrupt list says there is no return value from
                            #  int $0x10,
                            #  vimcmd: e +/AH\ =\ 0E/ saved_docs/BIOSinterrupts/INTERRUP.A
                            #  Hence we don't have to put this here, as it
                            #  should already be there.
    int $0x10
_freeze:
    jmp _freeze

    . = _start + 510    # move to 510th byte from 0 pos
    .byte 0x55          # append boot signature
    .byte 0xaa          # append boot signature

