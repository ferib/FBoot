nasm.exe -f bin src\boot.asm -o bin\boot.bin
nasm.exe -f bin src\kernel.asm -o bin\kernel.bin
copy /b bin\boot.bin + bin\kernel.bin bin\boot.img