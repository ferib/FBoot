[ORG 0x7E00]
jmp EnterProtectMode

%include "src\print.asm"
%include "src\kernel\GDT.asm"
%include "src\kernel\A20L.asm"

EnterProtectMode:
    call EnableA20L
    call check_a20
    cmp ax, 0
    je .fail
        cli ; Disable interrupts
        lgdt [gdt_descriptor]
        mov eax, cr0
        or eax, 1 ; protected mode enabled
        mov cr0, eax
        jmp codeseg:ProtectedMode 
        jmp $
    .fail:
    sti
    mov bx, a20errStr
    call PrintString
    jmp $

[BITS 32]
%include "src\kernel\paging.asm"
%include "src\kernel\CPUID.asm"
%include "src\util\console.asm"
%include "src\util\screen.asm"
%include "src\drivers\keyboard.asm"

ProtectedMode:
    mov ax, dataseg
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Print bootscreen
    call Screen.Startup

    ; Do something usefull? NOTE: we only have 8 console lines to print!
    mov ebx, MenuScanStr
    call Screen.WriteItem

    ; Keep it real!
    call CPUIDDetect
    call DetectLongmode ; NOTE: does longmode exists in VirtualBox??
    call SetupPaging
    call UpdateGDT ; Enabled 64BIT mode
    jmp codeseg:Heaven
    jmp $

[BITS 64]
Heaven:
    ; Just in case we get to heaven
    mov ebx, .HeavenStr
    call Screen.WriteItem
    jmp $

.HeavenStr:
    db "Welcome to 64bit!", 0

times 4096 - ($-$$) db 0x00
