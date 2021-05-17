app.exe : double.o float.o long_double.o sin.o main.c
	gcc -std=gnu11 -masm=intel -m80387 $^ -o $@

float.o : float.c
	gcc -std=gnu11 -masm=intel -m80387  -c $< -o $@

double.o : double.c
	gcc -std=gnu11 -masm=intel -m80387  -c $< -o $@

long_double.o : long_double.c
	gcc -std=gnu11 -masm=intel -m80387  -c $< -o $@

sin.o : sin_cmp.c
	gcc -std=gnu11 -masm=intel -m80387  -c $< -o $@

clean : 
	rm -rf *.exe *.o