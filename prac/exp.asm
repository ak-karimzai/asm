data_seg segment word 'data'
msg db 'Ahmad Khalid Karimzai', 0dh, 0ah, '$'
data_seg ends

stack_seg segment para 'stack'
    db 100h dup (?)
stack_seg ends

code_seg segment word 'code'
    ASSUME Cs:code_seg, Ds:data_seg

start:
    mov ax, data_seg
    mov ds, ax
    mov dx, offset msg
    mov ah, 09
    int 21h
    mov ah, 4ch
    int 21h
code_seg ends
    end start