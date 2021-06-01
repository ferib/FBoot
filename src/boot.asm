[ORG 0x7C00]
jmp BootStart

; TODO: BPB

BootStart:
mov [DISK], dl

; init stack
mov bp, 0x7C00
mov bp, sp

; print msg
mov bx, WelcomeStr
call PrintString

; Load second section and give control
call ReadDisk
jmp PROGRAM_START
jmp $

%include "src\print.asm"
%include "src\disk.asm"

times 510-($-$$) db 0x00

dw 0xAA55