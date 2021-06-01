CONSOLE_COLOR: 
    db 0x07

CONSOLE_CURSOR: 
    dw 0x0000

ConsoleClear:
    mov edi, 0xB8000
    mov eax, 0x0020
    mov ecx, 4000
    rep stosb
    ret

ConsoleSetColor:
    ; bl = Collor Byte
    mov [CONSOLE_COLOR], bl
    ret ; I think i just inline this?

ConsoleWriteLine:
    ; ebx = StrPtr
    call ConsoleWrite
    push eax
    push edx
    mov eax, [CONSOLE_CURSOR]
    mov bx, 0xA0 ; alternative: add [CONSOLE_CURSOR],([CONSOLE_CURSOR] // 0x50) - 0x50)
    div bx
    mov dx, 0xA0
    inc ax ; line += 1
    mul dx
    mov [CONSOLE_CURSOR], eax
    pop edx
    pop eax
    ret

ConsoleWrite:
    ; ebx = StrPtr
    push eax
    push edx
    push ecx
    mov edi, 0xB8000
    add di, word [CONSOLE_CURSOR]
    mov ah, byte [CONSOLE_COLOR] ; set color
    .PrintChar:
        cmp [ebx], byte 0
        je .exit
        mov al, byte [ebx] ; set char next to color
        mov [edi], word ax ; write color and char
        add edi, 0x02
        inc ebx
        loop .PrintChar
    .exit:
    sub edi, 0xB8000 ; save state
    mov [CONSOLE_CURSOR], edi
    pop ecx
    pop edx
    pop eax
    ret

DisableCursor:
    pushf
    push eax
    push edx
    mov dx, 0x03D4
    mov al, 0x0A    ; low cursor shapre reg
    out dx, al
    inc dx
    mov al, 1 << 5    ; disable cursor bit
    out dx, al
    pop edx
    pop eax
    popf
    ret
