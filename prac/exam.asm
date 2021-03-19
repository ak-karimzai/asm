    .model tiny
    .code
    .286
    org 100h
start:
    mov dx, offset msg1
    mov ah, 9
    int 21h
    mov dx, offset buffer
    mov ah, 0ah
    int 21h
    mov dx, offset crlf
    mov ah, 9
    int 21h
    xor di, di
    xor ax, ax
    mov cl, blength
    xor ch, ch
    xor bx, bx
    mov si, cx
    mov cl, 10
asc2hex:
    mov bl, byte ptr bcon[di]
    sub bl, '0'
    jb asc_error
    cmp bl, 9
    ja asc_error
    mul cx
    add ax, bx
    inc di
    cmp di, si
    jb asc2hex
    push ax
    mov ah, 9
    mov dx, offset msg2
    int 21h
    pop ax
    
    push ax
    xchg ah, al
    call print_al
    pop ax
    call print_al
    ret
asc_error:
    mov dx, offset err_msg
    mov ah, 9
    int 21h
    ret

print_al:
    mov dh, al
    and dh, 0fh
    shr al, 4
    call print_nibble
    mov al, dh
print_nibble:
    cmp al, 10
    sbb al, 69h
    das
    mov dl, al
    mov ah, 2
    int 21h
    ret
msg1 db "decimal number: $"
msg2 db "hexadecimal num: $"
err_msg db "Input Error: $"
crlf db 0dh, 0ah, '$'
buffer db 6
blength db ?
bcon:
    end start