command = gcc -Wall -Werror -O7 -mavx -masm=intel

app.exe : main.c
	$(command) -o $@ $^ 

main.s : main.c
	$(command) -o $@ $^ -S

.PHONY : clean

clean:
	rm -rf *.out *.exe *.s