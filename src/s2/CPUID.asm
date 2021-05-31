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
    mov eax, 0x80000001
    cpuid
    test edx, 1 << 29
    jz NoLongmode
    ret

NoLongmode:
    mov bx, longerrStr
    call PrintString
    hlt ; TODO: 

CPUIDFailed:
    mov bx, CpuiderrStr
    call PrintString
    hlt ; TODO