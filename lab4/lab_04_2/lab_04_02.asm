public sec_part

extrn BUFFER:far
extrn quit:far

STK_SEG SEGMENT para stack 'STACK'
    db 100 dup(0)
STK_SEG ENDS

DATA_SEG segment para public 'data'
    db 100, 100 dup('$')
    new_line db 13, 10, '$'
DATA_SEG ends

CODE_SEG_1 SEGMENT para public 'code'
    ASSUME CS:CODE_SEG_1, SS:STK_SEG, DS:DATA_SEG

goto_newline proc near
    mov ah, 09
    mov dx, offset new_line
    int 21h
    ret
goto_newline endp

print_string proc near
    call goto_newline
    mov ah, 09
    mov dx, 2
    int 21h
    ret
print_string endp

_inc:
    inc si
    jmp __label

_upper:
    add byte ptr [BUFFER + si], 32
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
        mov dl, byte ptr [BUFFER + si]
        cmp dl, '$'
        je print
        
        test si, 1b
        jne _label
        jmp _inc

    print:
        call print_string

    jmp quit

CODE_SEG_1 ENDS
END sec_part