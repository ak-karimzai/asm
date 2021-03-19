
public main
public BUFFER

STK_SEG SEGMENT para public 'STACK'
    db 100 dup(0)
STK_SEG ENDS

DATA_SEG SEGMENT para public 'data'
    BUFFER db 100, 100 dup('$')

    new_line db 13, 10, '$'
DATA_SEG ENDS

CODE_SEG SEGMENT para public 'code'
    ASSUME CS:CODE_SEG, SS:STK_SEG, DS:DATA_SEG

goto_newline:
    mov ah, 09
    mov dx, offset new_line
    int 21h
    ret

print_string:
    call goto_newline
    mov ah, 09
    mov dx, 2
    int 21h
    ret

get_input:
    mov ah, 0ah
    mov dx, 0
    int 21h
    call goto_newline
    ret

_inc:
    inc si
    jmp __label

_upper:
    add byte ptr [BUFFER + si], 32
    jmp _inc

_label:
    mov dl, byte ptr [BUFFER + si]

    cmp dl, 'A'
    jb _inc
    
    cmp dl, 'Z'
    ja _inc

    jmp _upper
    jmp __label

main:
    mov ax, DATA_SEG
    mov ds, ax

    call get_input
    
    mov si, 0
    
    __label:
        cmp dl, '$'
        je print_quit
        
        test si, 1b
        jne _label
        jmp _inc

print_quit:

    call print_string
    mov ah, 4ch
    int 21h

CODE_SEG ENDS
END main