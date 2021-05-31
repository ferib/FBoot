CONSOLE_COLOR: 
    db 0x07

CONSOLE_CURSOR: 
    dw 0x0000

ConsoleClear:
    mov edi, 0xB800
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
    ; set index to next line
    push eax
    mov eax, [CONSOLE_CURSOR]
    or eax, byte 0x50 ; fore bits 4~5
    mov al, byte 0x00 ; force bits 0~3
    mov [CONSOLE_CURSOR], eax
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
