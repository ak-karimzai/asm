EXTRN output_X: near

STK SEGMENT PARA STACK 'STACK'
	db 100 dup(0)
STK ENDS

DSEG SEGMENT PARA PUBLIC 'DATA'
	X db 'R'
      db 'Ahmad Khalid KArimzai$'
DSEG ENDS

CSEG SEGMENT PARA PUBLIC 'CODE'
	assume CS:CSEG, DS:DSEG, SS:STK
main:
	mov ax, DSEG
	mov ds, ax

	call output_X	

    mov ax, 09
    int 21h
	mov ax, 4c00h
	int 21h
CSEG ENDS

PUBLIC X

END main