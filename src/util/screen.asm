Screen:
.Startup:
    call Console.DisableCursor
    ; 2: padding
    ; 11: logo
    ; 1: padding
    ; 2: note
    ; 2 padding?
    ; 6 menu

    call .DrawLogo

    mov [CONSOLE_CURSOR], word (0xA0*11) + 66 ; line 14, index 13/2 - 80/2  *2
    mov ebx, WebsiteStr
    call Console.Write

    mov [CONSOLE_CURSOR], word (0xA0*14); // line 17
    mov [CONSOLE_COLOR], byte 0x0E ; light yellow

    mov ebx, MenuWelcomeStr
    call .WriteItem
    ret

.WriteItem:
    push ebx
    mov al, byte [CONSOLE_COLOR]
    mov [CONSOLE_COLOR], byte 0x07 ; black & white
    mov ebx, MenuStrPrefix
    call Console.Write
    pop ebx
    mov [CONSOLE_COLOR], byte al
    call Console.WriteLine
    ret

.DrawLogo:
    mov edi, 0xB8000
    mov eax, 0x0020
    mov ecx, 0x50*2
    rep stosw
    
    ; TODO: make this out logo
    ;mov eax, 0x0DDB
    ;mov ecx, 0x50*11
    ;rep stosw
    sub edi, 0xB8000 
    mov [CONSOLE_CURSOR], edi
    mov eax, [CONSOLE_COLOR]
    mov [CONSOLE_COLOR], byte 0x03 ; black cyan
    push eax
    mov ebx, ASCIIArt
    call Console.WriteLine
    pop eax
    mov [CONSOLE_COLOR], eax

    ; padding?
    mov eax, 0x3320
    mov ecx, 0x50*1
    rep stosw

    ret

; High ASCII
; 176 - low
; 177 - medium
; 178 - high
; 219 - full
; 254 - lil square
; 249 - middle dot
; 174, 175 - doubble >> and <<
ASCIIArt:
    db "  ________               ________      ________      ________      _________     |\  _____\             |\   __  \    |\   __  \    |\   __  \    |\___   ___\   \ \  \__/  __________  \ \  \|\ /_   \ \  \|\  \   \ \  \|\  \   \|___ \  \_|    \ \   __\|\__________\ \ \   __  \   \ \  \\\  \   \ \  \\\  \       \ \  \      \ \  \_|\|__________|  \ \  \|\  \   \ \  \\\  \   \ \  \\\  \       \ \  \      \ \__\                 \ \_______\   \ \_______\   \ \_______\       \ \__\      \|__|                  \|_______|    \|_______|    \|_______|        \|__| ", 0

WebsiteStr:
    db "www.ferib.dev", 0

MenuWelcomeStr:
    db "Ferib's Bootloader v1.0 - Welcome!", 0

MenuScanStr:
    db "Scanning Disk Sections...", 0

MenuStrPrefix:
    db 0x20, 0xAF, 0x20, 0 ; > 
