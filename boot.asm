[ORG 0x7c00]      ; add to offsets
    jmp start

    ; Code from babystep 4
    ; This file includes allocated data that the printing functions use.
    %include "print.inc"

start:
    ; Clear screen using a BIOS interrupt (get rid of the qemu/bochs messages)
    mov ax, 0x3
    int 0x10
    cld

    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x9c00   ; 200h past code start

    mov ax, 0xb800   ; text video memory
    mov es, ax

    cli      ;no interruptions
    ; Interrupt number for reading from the keyboard.
    mov bx, 0x09
    shl bx, 2   ;multiply by 4 to get position in interrupt vector table
    xor ax, ax
    mov gs, ax   ;start of memory
    ; Interrupt Vector Table is at the start of memory !
    ; You store a pointer and segment in the table for it to use.
    mov [gs:bx], word keyhandler
    mov [gs:bx+2], ds ; segment
    sti

    jmp $      ; loop forever

keyhandler:
    in al, 0x60   ; get key data
    mov bl, al   ; save it
    mov byte [port60], al

    ; ; http://wiki.osdev.org/Interrupts says that 0x64 is the command port for
    ; ; keyboard controller.
    ; ; According to
    ; ; http://wiki.osdev.org/%228042%22_PS/2_Controller#PS.2F2_Controller_IO_Ports
    ; ; the 0x61 port is to reset the keyboard interrupt request signal in an
    ; ; obsolete controller. The tutorial includes this code, but I think it's
    ; ; just in case, and for completeness.
    ; in al, 0x61   ; keybrd control
    ; mov ah, al
    ; or al, 0x80   ; disable bit 7
    ; out 0x61, al   ; send it back
    ; xchg ah, al   ; get original
    ; out 0x61, al   ; send that back

    ; Tell the PIC that it's OK to resume sending interrupts.
    ; http://wiki.osdev.org/Interrupts
    mov al, 0x20
    out 0x20, al

    ; ; If the interrupt came from the slave PIC, would use the below instead
    ; mov al, 0x20
    ; ; Tell the slave PIC that we've handled the interrupt
    ; out 0xa0, al
    ; ; Tell the master PIC that we've handled the interrupt
    ; out 0x20, al

    ; If the key has just been released, then skip over the code printing the
    ; keycode. This is marked by the keycode having bit 7 set.
    ; This only works if we're using the scan code set 1, which apparently is
    ; not the default (http://wiki.osdev.org/Keyboard).
    ; The keyboard controller supports a translation mode that translates
    ; scan code sets from 2 to 1.
    ; In order to use scan code set 2 you need to disable the translation.
    ; http://wiki.osdev.org/%228042%22_PS/2_Controller#Translation
    ;
    ; the mainboard pretents USB input devices are actually PS/2 devices.
    ; This is called USB Legacy Support.
    ; USB Legacy Support should be disabled as soon as the OS initialises the
    ; USB Controller. This should be done before the OS attempts to initialise
    ; the real PS/2 controller as otherwise the OS would only be initialising
    ; the emulated PS/2 controller, which is likely to cause problems caused by
    ; deficiencies in the firmware's emulation.
    and bl, 0x80   ; key released
    jnz done   ; don't repeat

    mov ax, [port60]
    mov  word [reg16], ax
    call printreg16

done:
    iret

port60   dw 0

    times 510-($-$$) db 0  ; fill sector w/ 0's
    dw 0xAA55        ; req'd by some BIOSes
;==========================================
