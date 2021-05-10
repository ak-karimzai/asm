    .model tiny
    .code
    .186
    org 100h
start proc near
    mov ax, 321ch
    int 21h
    mov word ptr old_int1ch, bx
    mov word ptr old_int1ch + 2, es

    mov ax, 251ch
    mov dx, offset int1ch_handler
    int 21h

    mov ah, 1
    int 21h

    mov ax, 251ch
    mov dx, word ptr old_int1ch + 2
    mov ds, dx
    mov dx, word ptr cs:old_int1ch
    int 21h
    ret
old_int1ch dd ?
start_position dw 0
start endp

int1ch_handler proc far
    pusha
    push es
    push ds

    push cs
    pop ds
    mov ah, 02h
    int 1ah
    jc exit_handler

    call bcd2acs

    mov byte ptr outputline[2], ah
    mov byte ptr outputline[4], al

    mov al, cl
    call bcd2acs
    mov byte ptr outputline[10], ah
    mov byte ptr outputline[12], al

    mov al, dh

    call bcd2acs
    mov byte ptr outputline[16], ah
    mov byte ptr outputline[18], ah

    mov cx, outputline_1

    push 0b800h
    pop es
    mov di, word ptr start_position
    mov si, offset outputline
    cld
    rep movsb
exit_handler:
    pop ds
    pop es

    popa
    jmp cs:old_int1ch
bcd2acs proc near
    mov ah, al
    and al, 0fh
    shr ah, 4
    or ax, 3030h
    ret
bcd2acs endp

outputline db ' ', 1fh, '0', 1fh, '0', 1fh, 'h', 1fh
           db ' ', 1fh, '0', 1fh, '0', 1fh, ':', 1fh
           db '0', 1fh, '0', 1fh, ' ', 1fh

outputline_1 equ $-outputline

int1ch_handler endp
end start