CPUIDDetect:
    pushfd
    pop eax
    mov ecx, eax ; save
    xor eax, 1 << 21 ; set 21th bit
    push eax
    popfd

    pushfd
    pop eax
    push ecx
    popfd

    xor eax, ecx ; check match
    jz CPUIDFailed
    ret

DetectLongmode:
    mov eax, 0x80000000
    cpuid
    cmp eax, 0x80000001
    jb NoLongmode
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz NoLongmode
    ret

NoLongmode:
    mov [CONSOLE_COLOR], byte 0x04 ; black red
    mov ebx, NoLongmodeStr
    call Screen.WriteItem ; TOOD: fix?
    hlt 

CPUIDFailed:
    mov [CONSOLE_COLOR], byte 0x04 ; black red
    mov ebx, NoCPUIDStr
    call Screen.WriteItem ; TODO: fix?
    hlt

NoLongmodeStr:
    db "No longmode supported!", 0

NoCPUIDStr:
    db "No CPUID supported!", 0