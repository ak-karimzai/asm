stk_seg segment para stack 'stack'
    db 100 dup(0)
stk_seg ends

data_seg segment para public 'data'
    rows db 4
    cols db 8
    matrix db 81 dup(0)
    msg1 db 13, 10, "number of rows: $"
    msg2 db 13, 10, "number of cols: $"
    msg3 db 13, 10, "Elements: $"
    err_msg db 13, 10, "Incorect Input! $"
    elem_sum db 0
    new_line_sym db 13, 10, '$'
data_seg ends

code_seg segment para public 'code'
    ASSUME SS:stk_seg, DS:data_seg, CS:code_seg

read_matrix proc public
    mov cl, ds:rows
    mov si, 0
    mov ah, 08
_loop_1:
    mov di, cx
    mov cl, ds:cols

_loop_2:
    int 21h
    mov [matrix + si], al
        
    inc si

    loop _loop_2

    mov bx, ax ; push

    mov dx, offset ds:new_line_sym
    mov ah, 09
    int 21h

    mov ax, bx ; pop

    mov cx, di
    
    loop _loop_1
    ret
read_matrix endp

display_matrix proc public
    mov dx, offset msg3
    mov ah, 09
    int 21h

    mov dx, offset ds:new_line_sym
    int 21h

    mov cl, ds:rows
    mov si, 0
    mov ah, 2
_loop_1:
    mov es, cx
    mov cl, ds:cols

_loop_2:
    mov dl, [matrix + si]
    int 21h

    mov dl, ' ';
    int 21h
    
    inc si

    loop _loop_2

    mov dl, 13
    int 21h
    mov dl, 10
    int 21h
    
    mov cx, es
    
    loop _loop_1
    ret
display_matrix endp

change_hash_tag proc public
    mov cl, ds:rows
    mov si, 0
_loop_1:
    mov es, cx

    mov cl, ds:cols
    mov di, si
    dec di
_loop_2:
    cmp [matrix + si], '#'
    je right_sum

_continue_loop:
    inc si
    loop _loop_2
    ;dec cx
    ;cmp cx, 0
    ;jne _loop_2

    mov cx, es
    
    loop _loop_1
    ;dec cx
    ;cmp cx, 0
    ;jne _loop_1

    jmp return

right_sum:
    mov [elem_sum], 0
    mov bx, si
    mov dx, cx
    add dx, si
increm:
    inc bx
    cmp bx, dx
    je left_sum

    cmp [matrix + bx], '#'
    je left_sum

    cmp [matrix + bx], '0'
    jb increm
    
    cmp [matrix + bx], '9'
    ja increm

    mov ax, 0
    mov al, [matrix + bx]
    sub al, '0'
    add [elem_sum], al
    jmp increm

left_sum:
    mov bx, si
decrem:
    dec bx
    cmp bx, di
    je __write

    cmp [matrix + bx], '#'
    je __write
    
    cmp [matrix + bx], '0'
    jb decrem
    
    cmp [matrix + bx], '9'
    ja decrem  
    
    mov al, [matrix + bx]
    sub al, '0'
    add [elem_sum], al
    jmp decrem

    ;cmp [elem_sum], 0
    ;je _continue_loop

__write:
    cmp [elem_sum], 0
    je _continue_loop

    cmp [elem_sum], 10
    jb __fin

    mov ax, 0
    mov al, [elem_sum]
    mov dx, 0
    mov bx, 10
    idiv bx
    mov bl, dl
    jmp __fin1
__fin:
    mov bl, [elem_sum]
__fin1:
    add bl, '0'
    
    mov [matrix + si], bl
    
    jmp _continue_loop
return:
    ret
change_hash_tag endp

err_msg_lab:
    mov dx, offset ds:err_msg
    mov ah, 09
    int 21h
    jmp exit

check_num:
    cmp al, '0'
    jbe err_msg_lab
    
    cmp al, '9'
    ja err_msg_lab
    
    sub al, '0'
    cmp cx, 2
    je _write

    jmp _write_col

start:
    mov ax, data_seg
    mov ds, ax

    mov cx, 2

    mov dx, offset msg1
    mov ah, 09
    int 21h 

    mov ah, 08
    int 21h

    jmp check_num

_write:
    mov ds:[rows], al
    
    mov dx, offset new_line_sym
    mov ah, 09
    int 21h

read_col:
    mov dx, offset msg2
    int 21h

    mov ah, 08
    int 21h
    
    dec cx  
    jmp check_num

_write_col:
    mov ds:[cols], al
    
    mov dl, 13
    mov ah, 02
    int 21h
    mov dl, 10
    int 21h

    call read_matrix

    call display_matrix

    call change_hash_tag

display:
    call display_matrix
exit:
    mov ah, 4ch
    int 21h
code_seg ends
    end start