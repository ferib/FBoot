PROGRAM_START equ 0x7E00

ReadDisk:
    mov ah, 0x02 ; Read Sectors
    mov bx, PROGRAM_START
    mov al, 8 ; sectors count
    mov dl, [DISK] ; select current disk
    mov ch, 0x00
    mov dh, 0x00
    mov cl, 0x02
    int 0x13 ; LL Disk Service
    jc DiskError ; flag 0 on failure
    ret

DiskError:
    mov bx, DiskErrorStr
    call PrintString
    jmp $

DiskErrorStr:
    db "Failed Reading Disk!", 13, 10, 0

DISK: 
    db 0