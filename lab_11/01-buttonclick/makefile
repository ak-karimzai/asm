main.exe : main.o
	ld -s -m elf_x86_64 main.o -o main -lc --dynamic-linker /lib64/ld-linux-x86-64.so.2 `pkg-config --libs gtk+-3.0`

main.o : main.asm
	nasm -felf64 -o main.o -l main.lst main.asm