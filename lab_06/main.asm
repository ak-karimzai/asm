public start_menu
extern signed_inp:near
extern unsigned_inp:near
extern to_binary:far
extern to_octal:far
extern to_hexadeciaml:far
extern print:far
extern binary:byte
extern octal:byte
extern hexa_dicimal:byte

pass_print_arg macro param
    mov bx, param
endm

data_seg segment para common 'data'
    org 0
    over_flow label byte
    org 7
    incorect_msg label byte
    org 25
    msg label byte 
data_seg ends

stk_seg segment para stack 'stack'
    db 50 dup(0)
stk_seg ends

code_seg segment para public 'code'
    assume ds:data_seg, cs:code_seg, ss:stk_seg

call_binary:
    call unsigned_inp

    cmp [over_flow], 1
    je incorect_input
    
    call to_binary
    
    pass_print_arg offset binary
    call print
    
    jmp start_menu

call_octal:
    call signed_inp

    cmp [over_flow], 1
    je incorect_input
    
    call to_octal
    pass_print_arg offset octal
    call print
    
    jmp start_menu

call_hexadecimal:
    call signed_inp

    cmp [over_flow], 1
    je incorect_input

    call to_hexadeciaml
    pass_print_arg offset hexa_dicimal
    call print

    jmp start_menu

start:
    mov ax, data_seg
    mov ds, ax

start_menu:
    mov ah, 09
    mov dx, offset msg
    int 21h

    xor al, al
    mov ah, 08
    int 21h

    cmp al, '1'
    je call_octal

    cmp al, '2'
    je call_binary
    
    cmp al, '3'
    je call_hexadecimal

    cmp al, '4'
    je exit

incorect_input:
    mov dx, offset incorect_msg
    mov ah, 09
    int 21h

exit:
    mov ah, 4ch
    int 21h
code_seg ends
    end start