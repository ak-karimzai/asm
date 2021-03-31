public to_octal
extern number:word
extern sign:byte
extern binary:byte
extern octal:byte
extern hexa_dicimal:byte
extern new_line:byte

code_seg segment para public 'code'
    assume cs:code_seg
start:
to_binary proc near
    mov bx, [number]
    mov cx, 16
    mov si, 15
    top:
        shl bx, 1
        jc write_one
        
        mov [binary + si], '0'

        continue_loop:
            inc si
            
        loop top
    ret
    write_one:
        mov[binary + si], '1'
        jmp continue_loop
to_binary endp

to_octal proc near
    jmp put_dot
_start:
    mov ax, [number]
    mov bx, 08
    mov si, 19
    jmp _check
    divide:
        xor dx, dx
        idiv bx
        add dx, '0'
        mov [octal + si], dl
        dec si
        jmp _check

    _check:
        cmp ax, 0
        jne divide
    cmp [sign], 1
    je write_sign
return:
    ret
    write_sign:
        mov [octal + si], 45
        jmp return
    put_dot:
        mov si, 14
        mov cx, 6
        write_dot:
            mov [octal + si], '.'
            inc si
            loop write_dot
        jmp _start
to_octal endp

to_hexadeciaml proc near
    jmp put_dot
    _start:
    mov ax, [number]
    mov bx, 16
    mov si, 24
    jmp _check
    divide:
        xor dx, dx
        idiv bx
        cmp dx, 9
        ja hex_part
        add dx, '0'
        write_bit:
            mov [hexa_dicimal + si], dl
        dec si
        jmp _check

    hex_part:
        add dx, 55
        jmp write_bit

    _check:
        cmp ax, 0
        jne divide
    cmp [sign], 1
    je write_sign
return:
    ret
    write_sign:
        mov [hexa_dicimal + si], 45
        jmp return
    put_dot:
        mov si, 20
        mov cx, 5
        write_dot:
                mov [hexa_dicimal + si], '.'
                inc si
                loop write_dot
        jmp _start
to_hexadeciaml endp
code_seg ends
    end start