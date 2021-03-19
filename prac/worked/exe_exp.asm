dsg segment word 'data'
    msg db "Ahmad Khalid Karimzai", 0dh, 0ah, '$'
dsg ends

ssg segment para 'stack'
    db 0h dup (?)
ssg ends

csg segment word 'code'
    ASSUME CS:csg, Ds:dsg

set_add_of_string:
    mov dx, offset msg
print:
    mov ah, 09
    int 21h
end_prog:
    mov ah, 4ch
    int 21h
start:
    mov ax, dsg
    mov ds, ax
    jmp set_add_of_string
    jmp print
    jmp end_prog
csg ends
    end start