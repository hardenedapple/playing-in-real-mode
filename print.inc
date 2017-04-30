dochar:
    call cprint         ; print one character
sprint:
    lodsb      ; string char to AL
    cmp al, 0
    jne dochar   ; else, we're done
    add byte [ypos], 1   ;down one row
    mov byte [xpos], 0   ;back to left
    ret

; Printing to screen information can be found here
; http://wiki.osdev.org/Printing_To_Screen
; The basics are that you put data into the video memory.
; For each character on screen you write two bytes into the memory, one is the
; ASCII code byte, the other is the attribute byte.
; e.g. 'H', 0x07  is lightgrey-on-black 'H'
; The lowest 4 bits of the attribute byte are the foreground colour, the
; highest 3 bits are the background color, and the interpretation of the
; missing byte is dependant on configuration.
;
; So what does putting a newline do? If characters are printed at the position
; specified by the offset into the 
cprint:
    ; Called with the character to print in al
    ; We set the char/attribute, save it in cx
    ; Then we get the yposition into ax (because the mul instruction uses ax)
    ; by multiplying the position we want by 160 (which is 80 columns times 2
    ; bytes -- character/attribute).
    ;
    ; We then get the x position into bx by multiplying xpos by two
    ; (character/attribute).
    ;
    ; Finally, we get the memory position into di by adding the x and y
    ; positions.
    ; Then we write the stored char/attribute word into that position, and
    ; advance to the right.
    ;
    ; n.b. this does absolutely nothing to the cursor position that we can work
    ; with using the BIOS.

    mov ah, 0x0F
    mov cx, ax
    movzx ax, byte [ypos]
    mov dx, 160
    ; dx:ax = dx * ax     (dx is set to the upper 16 bits of the mul result)
    mul dx

    movzx bx, byte [xpos]
    shl bx, 1

    mov di, 0        ; start of video memory
    add di, ax      ; add y offset
    add di, bx      ; add x offset

    mov ax, cx        ; restore char/attribute
    ; Store ax at es:di
    stosw              ; write char/attribute
    add byte [xpos], 1  ; advance to right

    ret

    ;------------------------------------

; Printing the value of a register to screen.
printreg16:
    mov di, outstr16
    mov ax, [reg16]
    mov si, hexstr
    mov cx, 4   ;four places
hexloop:
    rol ax, 4   ;leftmost will
    mov bx, ax   ; become
    and bx, 0x0f   ; rightmost
    mov bl, [si + bx];index into hexstr
    mov [di], bl
    inc di
    dec cx
    jnz hexloop

    mov si, outstr16
    call sprint

    ret

    ;------------------------------------

    xpos   db 0
    ypos   db 0
    hexstr   db '0123456789ABCDEF'
    outstr16   db '0000', 0  ;register value string
    reg16   dw    0  ; pass values to printreg16
    msg   db "What are you doing, Dave?", 0
    ;==================================
