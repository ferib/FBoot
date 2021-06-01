PrintString:
    mov ah, 0x0E ; write char in TTY mode
    .loop:
        cmp [bx], byte 0
        je .exit
        mov al, [bx]
        int 0x10 ; video service
        inc bx
        jmp .loop
    .exit:
        ret

WelcomeStr: 
    db "Welcome to the bootloader!", 13, 10, 0

a20errStr:
    db "A20L failed", 13, 10, 0
