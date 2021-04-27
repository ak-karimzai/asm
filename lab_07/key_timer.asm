    .model tiny
    .code
    .186
    org 100h

main:
    cur_sec db 0
    speed db 01fh
    old_int dd ?
    int_installed db 'I'

init:
    mov ax, 351ch
    int 21H

    cmp es:int_installed, 'I'
    je reset

    mov word ptr old_int, bx
    mov word ptr old_int + 2, es

    mov ax, 251ch
    mov dx, offset set
    int 21h

    mov dx, offset init
    int 27h

set:
    pusha
    pushf
    push es
    push ds

    mov ah, 02h
    int 1ah

    cmp dh, cur_sec
    mov cur_sec, dh
    jz end_loop
    
    mov al, 0F3h
    out 60h, al
    mov al, speed
    out 60h, al

    dec speed

    cmp speed, 0
    jz reset_speed

    jmp end_loop
    
    reset_speed:
        mov speed, 01fh

    end_loop:
        pop ds
        pop es

        popf
        popa
        jmp cs:old_int

reset:
    pusha
    
    push es
    push ds

    pushf

    mov al, 0f3h
    out 60h, al
    mov al, 0
    out 60h, al

    mov dx, word ptr es:old_int
    mov ds, word ptr es:old_int + 2

    mov ax, 251ch
    int 21h

    popf

    pop ds
    pop es
    
    popa

    mov ah, 49h
    int 21h

    mov ah, 4ch
    int 21h

end main