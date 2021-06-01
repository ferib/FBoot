Keyboard:
.ScanToASCII:
    iret
    ;; TODO: fix
    push edx
    push eax
    xor eax, eax
    mov edx, eax
    pop eax
    mov edx, KEYMAP_QWERTY
    cmp bl, 0
    jz .skip
        add edx, 126
    .skip:
    push ebx
    mov bh, 0
    mov bl, al
    ;mov al, [edx+bx]
    pop ebx
    
    pop edx
    iret

KEYMAP_QWERTY: 
    db 0, 0x1B, '1', '2', '3', '4', '5', '6', '7', '8'
    db '9', '0', '-', '=', 0, 0, 'q', 'w', 'e', 'r'
    db 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 0, 0,
    db 'a', 's', 'd', 'f', 'g', 'h', 'j', 'k' ,'l', 0x3B
    db 0x27, 0, 0, '\', 'z', 'x', 'c', 'v', 'b', 'n'
    db 'm', ',', '.', '/'
    TIMES 126-($-KEYMAP_QWERTY) db 0
KEYMAP_QWERTY_SHIFT:
    db 0, 0x1B, '!', '@', '#', '$', '%', '^', '&', '*'
    db '(', ')', '_', '+', 0, 0, 'Q', 'W', 'E', 'R'
    db 'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', 0, 0
    db 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':'
    db 0x22, 0, 0, '|', 'Z', 'X', 'C', 'V', 'B', 'N'
    db 'M', '<', '>', '?'
    TIMES 126-($-KEYMAP_QWERTY_SHIFT) db 0
