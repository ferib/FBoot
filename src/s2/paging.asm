PageTableEntry equ 0x1000

; TODO: improve basic paging
SetupPaging:
    mov edi, PageTableEntry ; PML4T
    mov cr3, edi
    mov dword [edi], 0x2003 ; PDPT
    add edi, 0x1000
    mov dword [edi], 0x3003 ; PDT
    add edi, 0x1000
    mov dword [edi], 0x4003 ; PT
    add edi, 0x1000

    ; 2MB for PT tables
    mov ebx, 0x00000003
    mov ecx, 512
    .SetEntry:
        mov dword [edi], ebx
        add ebx, 0x1000
        add edi, 8
        loop .SetEntry
    
    mov eax, cr4
    or eax, 1 << 5 ; Physical Address Extension
    mov cr4, eax

    mov ecx, 0xC0000000
    rdmsr
    or eax, 1 << 8 ; idk?
    wrmsr
    mov eax, cr0
    or eax, 1 << 31 ; Paging
    mov cr0, eax
    ret