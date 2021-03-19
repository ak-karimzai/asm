    .model tiny
    .code
    org 100h
start:
    mov ah, 09;
    mov dx, offset msg;
    int 21h;
    mov ah, 4c00h
    int 21h
    ret
msg db "Hello World!", "{Ahmad Khalid Karimzai}", "{Mumtaz Shokorzai}", 0Dh, 0Ah, '$'
    end start