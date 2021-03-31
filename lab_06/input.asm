extern start_menu:near
public number
public sign
public octal
public hexa_dicimal
public binary
public new_line

data_seg segment para common 'data'
    over_flow db 0
    sign db 0
    number dw 0
    new_line db 13, 10, '$'
    incorect_msg db "Incorect Input!", 13, 10, '$'
    msg db "1: decimal to octal.", 13, 10
    db "2: unsigned to binary.", 13, 10
    db "3: decimal to hexadicimal", 13, 10
    db "4: Exit", 13, 10, '$'
    num_msg db "Number: $"
    octal db "Octal Number: ", "......", '$'
    hexa_dicimal db "hexadecimal number: ",".....$"
    binary db "Binary number: "
    db 18 dup('$')
    uint_16 db 20
    blength db 0
data_seg ends

code_seg segment para public 'code'
    assume cs:code_seg, ds:data_seg
start:
    input proc near
        jmp _zero_buffer
        start_func:
            mov [sign], 0

            mov dx, offset num_msg
            mov ah, 09
            int 21h

            mov dx, offset uint_16
            mov ah, 10
            int 21h
            ret
            _zero_buffer:
                xor cx, cx
                mov cl, 20
                mov si, 0
                _put_dollar_sign:
                    mov [uint_16 + si], '.'
                    inc si
                    loop _put_dollar_sign
                jmp start_func
    input endp

    ; signed number input
    signed_inp proc near
        call input

        xor si, si
        xor ax, ax
        xor dx, dx
        xor cx, cx
        mov bx, 10
        xor di, di
        mov si, 2
        mov cl, [blength]
        jmp check_first_sym
    _check_input:
        mov dl, [uint_16 + si]

        cmp dl, '0'
        jb err_input

        cmp dl, '9'
        ja err_input

        mov es, dx

        mov ax, di
        mul bx

        jc err_input

        mov dx, es

        mov di, ax
        sub dx, '0'
        add di, dx

        inc si
        loop _check_input

        cmp [uint_16 + 2], '-'
        je add_last_bit

        jmp return

    increment_index:
        inc si
        dec cx
        jmp _check_input

    check_first_sym:
        cmp [uint_16 + si], '-'
        je increment_index

        cmp [uint_16 + si], '+'
        je increment_index

        jmp _check_input

    add_last_bit:
        add di, 8000h
        
        jc err_input

        mov [sign], 1
        sub di, 8000h

        jmp return

    err_input:
        mov [over_flow], 1

    return:
        mov [number], di
        ret
    signed_inp endp

    ; unsigned number input
    unsigned_inp proc near
        call input

        xor si, si
        xor ax, ax
        xor dx, dx
        xor cx, cx
        mov bx, 10
        xor di, di
        mov si, 2
        mov cl, [blength]
    _check_input:
        mov dl, [uint_16 + si]

        cmp dl, '0'
        jb err_input

        cmp dl, '9'
        ja err_input

        mov es, dx

        mov ax, di
        mul bx

        jc err_input

        mov dx, es

        mov di, ax
        sub dx, '0'
        add di, dx

        inc si
        loop _check_input

        mov [number], di
        
    return:
        ret
        err_input:
            mov [over_flow], 1
            jmp return
    unsigned_inp endp
    
code_seg ends
    end start