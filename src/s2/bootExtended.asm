[ORG 0x7E00]
jmp EnterProtectMode

%include "src\s1\print.asm"
%include "src\s2\GDT.asm"
%include "src\s2\A20L.asm"

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
        jmp codeseg:StartProtectedMode 
        jmp $
    .fail:
    sti
    mov bx, a20errStr
    call PrintString
    jmp $

[BITS 32]
%include "src\s2\CPUID.asm"
%include "src\s2\paging.asm"
%include "src\s2\console.asm"
%include "src\s2\screen.asm"
%include "src\s2\keyboard.asm"

StartProtectedMode:
    mov ax, dataseg
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Do kewl stuff
    call BootScreen
    jmp $ ; NOTE: no longmode support for me yet

    ; Keep it real!
    call CPUIDDetect
    call DetectLongmode ; NOTE: does longmode exists in VirtualBox??
    call SetupPaging
    call UpdateGDT ; Enabled 64BIT mode
    jmp codeseg:Heaven
    jmp $

[BITS 64]
Heaven:
    mov edi, 0xB8000
    mov rax, 0x0720072007200720
    mov ecx, 500
    rep stosq
    jmp $

times 4096 - ($-$$) db 0x00
