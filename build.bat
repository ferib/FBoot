nasm.exe -f bin src\s1\boot.asm -o bin\boot.bin
nasm.exe -f bin src\s2\bootExtended.asm -o bin\bootExtended.bin
copy /b bin\boot.bin + bin\bootExtended.bin bin\boot.img