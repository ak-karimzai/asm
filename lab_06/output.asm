extern new_line:byte
public print

code_seg segment para public 'code'
    assume cs:code_seg
start:
    print proc near
        mov dx, offset new_line
        mov ah, 09
        int 21h

        mov dx, bx
        int 21h
        
        mov dx, offset new_line
        int 21h
        ret
    print endp
code_seg ends
    end start