BootScreen:
    call DisableCursor
    ; 2: padding
    ; 11: logo
    ; 1: padding
    ; 2: note
    ; 2 padding?
    ; 6 menu

    mov ebx, WebsiteStr
    call ConsoleWrite

    mov edi, 0xB8000
    mov eax, 0x0020
    mov ecx, 0x50*2
    rep stosw
    
    ; TODO: make this out logo
    mov eax, 0x0DDB
    mov ecx, 0x50*11
    rep stosw

    ; padding?
    mov eax, 0x00DB
    mov ecx, 0x50*1
    rep stosw

    mov [CONSOLE_CURSOR], word (0xA0*14) + 66 ; line 14, index 13/2 - 80/2  *2
    mov ebx, WebsiteStr
    call ConsoleWrite

    mov [CONSOLE_CURSOR], word (0xA0*17); // line 17
    mov [CONSOLE_COLOR], byte 0x0E ; light yellow

    mov ebx, MenuWelcomeStr
    call WriteMenuItem

    mov ebx, MenuScanStr
    call WriteMenuItem 

    ; TODO: Do something usefull?

    ret

WriteMenuItem:
    push ebx
    mov al, byte [CONSOLE_COLOR]
    mov [CONSOLE_COLOR], byte 0x07 ; black & white
    mov ebx, MenuStrPrefix
    call ConsoleWrite
    pop ebx
    mov [CONSOLE_COLOR], byte al
    call ConsoleWriteLine
    ret

DrawImg:
    ret

;BootBanned:
    ; NOTE: padding top: 3 rows,
    ;       padding left & rigth: 5
;    db 0

; High ASCII
; 176 - low
; 177 - medium
; 178 - high
; 219 - full
; 254 - lil square
; 249 - middle dot
; 174, 175 - doubble >> and <<

TestStr:
    db "X", 0

WebsiteStr:
    db "www.ferib.dev", 0

MenuWelcomeStr:
    db "Ferib's Bootloader v1.0 - Welcome!", 0

MenuScanStr:
    db "Scanning Disk Sections...", 0

MenuStrPrefix:
    db 0x20, 0xAF, 0x20, 0 ; > 