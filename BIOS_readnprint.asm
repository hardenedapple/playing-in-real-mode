
; Printing to the screen using BIOS interrupts.
; Require character already in ax (i.e. the in al)
printregBIOS:
    mov ah, byte 0x0e
    int 0x10

; Returns the BIOS scancode in AH, and the ascii character in AL.
getkeyBIOS:
    xor ax, ax
    int 0x16
