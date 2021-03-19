stk_seg segment para public 'stack'
    db 100 dup(0)
stk_seg ends

data_seg segment para public 'data'
    msg db 13, 10, "Hi$"
data_seg ends

code_seg segment para public 'code'
    assume cs:code_seg, ds:data_seg, ss:stk_seg


check_sym:
    cmp dl, 'A'
    ret

print_sym:
    call check_sym
    mov dl, [msg + 2]
    mov ah, 02
    int 21h
    ret

start:
    mov ax, data_seg
    mov ds, ax
    call print_sym
    mov ah, 4ch
    int 21h
code_seg ends
    end start