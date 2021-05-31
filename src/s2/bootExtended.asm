[ORG 0x7E00]
jmp EnterProtectMode

%include "src\s1\print.asm"
%include "src\s2\GDT.asm"
%include "src\s2\A20L.asm"

EnterProtectMode:
    call EnableA20L
    call check_a20
    cmp ax, 0
    je .skip
        cli ; Disable interrupts
        lgdt [gdt_descriptor]
        mov eax, cr0
        or eax, 1 ; protected mode enabled
        mov cr0, eax
        jmp codeseg:StartProtectedMode 
        jmp $
    .skip:
    sti
    mov bx, a20errStr
    call PrintString
    jmp $

[BITS 32]
%include "src\s2\CPUID.asm"
%include "src\s2\paging.asm"

StartProtectedMode:
    mov ax, dataseg
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Test
    mov [0xB8000], byte 'H'

    ; Do kewl stuff
    call BootScreen

    ; Keep it real!
    call CPUIDDetect
    call DetectLongmode
    call SetupPaging
    call UpdateGDT ; Enabled 64BIT mode
    jmp codeseg:Gate

[BITS 64]
Gate:
    mov edi, 0xB8000
    mov rax, 0x1F201F201F201F20
    mov ecx, 500
    rep stosq
    mov [edi], rax
    jmp $

times 4096 - ($-$$) db 0x00
