public BUFFER

public print
public quit

EXTRN sec_part:far


STK_SEG SEGMENT para stack 'STACK'
    db 100 dup(0)
STK_SEG ENDS

DATA_SEG SEGMENT para public 'data'
    BUFFER db 100, 100 dup('$')

    new_line db 13, 10, '$'
DATA_SEG ENDS

CODE_SEG SEGMENT para public 'code'
    ASSUME CS:CODE_SEG, SS:STK_SEG, DS:DATA_SEG

goto_newline_s proc near
    mov ah, 09
    mov dx, offset new_line
    int 21h
    ret
goto_newline_s endp

print_string_s proc near
    call goto_newline_s
    mov ah, 09
    mov dx, 2
    int 21h
    ret
print_string_s endp

get_input proc near
    mov ah, 0ah
    mov dx, 0
    int 21h
    call goto_newline_s
    ret
get_input endp

_inc:
    inc si
    jmp _label

_upper:
    sub byte ptr [BUFFER + si], 32
    jmp _inc

main:
    mov ax, DATA_SEG
    mov ds, ax

    call get_input
    
    mov si, 0

    _label:
        mov dl, byte ptr [BUFFER + si]
        cmp dl, '$'
        je print

        cmp dl, 'a'
        jb _inc
        
        cmp dl, 'z'
        ja _inc
        
        jmp _upper

print:
    call print_string_s
    jmp sec_part

quit:
    mov ah, 4ch
    int 21h

CODE_SEG ENDS
END main