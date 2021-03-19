;  ******************************
;  *   Лабораторная работа N1*
;  *   Изучение отладчика AFD   *
;  ******************************
;  ------------------------------
; Примечание: Программа выводит на дисплей сообщение и
;         и ожидает  нажатия клавиши , код символа
;             помещается в регистр AL; Справка...: DS:DX -адрес строки
;
;             Функции DOS :
;             09h выдать на дисплей строку,
;             07h ввести символ без эха,
;             4Ch завершить процесс 
;
;             INT   21h -вызов  функции DOS
;
StkSeg SEGMENT PARA STACK 'STACK'
        DB      0h DUP (?)
StkSeg ENDS
;
Datas SEGMENT WORD 'DATA'
HelloMessage    DB 13
                DB 10
                DB 'Ahmad Khalid Karimzai$'
                ;DB '$'
Datas ENDS

;
Code SEGMENT WORD 'CODE'
    ASSUME CS:Code, Ds:Datas

DispMsg:
    mov AX,DataS 
    mov DS,AX 
    mov DX,OFFSET HelloMessage
    mov AH,9 
    mov cx, 3
    lab:
        int 21h
    loop lab
    ;mov AH,7
    ;INT 21h 
    mov AH,4Ch 
    int 21h 
Code ENDS
    END DispMsg