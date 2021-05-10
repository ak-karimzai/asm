run : app.exe
	./app.exe

app.exe : main.o _strcpy.o
	gcc -masm=intel $^ -o $@

main.s : main.c
	gcc -masm=intel -S $^ -o $@ 

_strcpy.o : _strcpy.asm
	nasm -f elf64 -o _strcpy.o _strcpy.asm

main.o : main.c
	gcc -c -masm=intel main.c 

.PHONY : clean
clean :
	rm -rf *.o *.exe *.s *.out