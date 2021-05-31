; offset 0x0
gdt_nulldescriptor:
	dd 0
    dd 0

; offset 0x8
gdt_code:			; cs should point to this descriptor
	dw 0xffff		; segment limit first 0-15 bits
	dw 0			; base first 0-15 bits
	db 0			; base 16-23 bits
	db 10011010b	; access byte
	db 11001111b	; high 4 bits (flags) low 4 bits (limit 4 last bits)(limit is 20 bit wide)
	db 0			; base 24-31 bits

; offset 0x10
gdt_data:			; ds, ss, es, fs, and gs should point to this descriptor
	dw 0xffff		; segment limit first 0-15 bits
	dw 0			; base first 0-15 bits
	db 0			; base 16-23 bits
	db 10010010b	; access byte
	db 11001111b	; high 4 bits (flags) low 4 bits (limit 4 last bits)(limit is 20 bit wide)
	db 0			; base 24-31 bits

gdt_end:

gdt_descriptor:
    gdt_size:
        dw gdt_end - gdt_nulldescriptor - 1
        dd gdt_nulldescriptor

codeseg equ gdt_code - gdt_nulldescriptor
dataseg equ gdt_data - gdt_nulldescriptor

[BITS 32]
UpdateGDT:
    ; 64 bit
    mov [gdt_code+6], byte 1010111b
    mov [gdt_data+6], byte 1010111b
    ret

[BITS 16]