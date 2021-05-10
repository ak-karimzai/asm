; public BUFFER

public print
public quit

EXTRN sec_part:near
extrn print_string:near


STK_SEG SEGMENT para stack 'STACK'
    db 100 dup(0)
STK_SEG ENDS

DATA_SEG SEGMENT para common 'data'
    db 13, 10
    db 100, 100 dup('$')
    new_line db 13, 10, '$'
    ORG 2
    BUFFER label byte
DATA_SEG ENDS

CODE_SEG SEGMENT para public 'code'
    ASSUME CS:CODE_SEG, SS:STK_SEG, DS:DATA_SEG

_inc:
    inc si
    jmp _label

_upper:
    sub byte ptr [BUFFER + si], 32
    jmp _inc

main:
    mov ax, DATA_SEG
    mov ds, ax

    mov ah, 0ah
    mov dx, 0
    int 21h

    mov ah, 09
    mov dx, offset new_line
    int 21h
    
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
    mov dx, offset BUFFER
    mov ah, 09
    int 21h

    mov dx, offset new_line
    int 21h

    jmp sec_part

quit:
    mov ah, 4ch
    int 21h

CODE_SEG ENDS
END main