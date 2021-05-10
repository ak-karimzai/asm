public sec_part
public print_string
; extrn _data:near
extrn quit:near

STK_SEG SEGMENT para stack 'STACK'
    db 100 dup(0)
STK_SEG ENDS

DATA_SEG segment para common 'data'
    ORG 1
    _data label byte
    new_line db 13, 10, '$'
DATA_SEG ends

CODE_SEG SEGMENT para public 'code'
    ASSUME CS:CODE_SEG, SS:STK_SEG, DS:DATA_SEG

print_string proc near
    mov dx, offset new_line
    mov ah, 09
    int 21h
    mov dx, 0
    int 21h
    ret
print_string endp

_inc:
    inc si
    jmp __label

_upper:
    add byte ptr [_data + si], 32
    jmp _inc

_label:
    cmp dl, 'A'
    jb _inc
    
    cmp dl, 'Z'
    ja _inc

    jmp _upper
    jmp __label

sec_part:
    mov ax, DATA_SEG
    mov ds, ax
    
    mov si, 0
    
__label:
    mov dl, byte ptr [_data + si]
    cmp dl, '$'
    je print
    
    test si, 1b
    jne _label
    jmp _inc

print:
    call print_string

    jmp quit

CODE_SEG ENDS
END sec_part