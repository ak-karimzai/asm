; Name        : buttonclick.asm
;
; Build       : nasm -felf64 -o buttonclick.o -l buttonclick.lst buttonclick.asm
;               ld -s -m elf_x86_64 buttonclick.o -o buttonclick -lc --dynamic-linker /lib64/ld-linux-x86-64.so.2 `pkg-config --libs gtk+-2.0`
; Description : events and signals intro
;
; Remark      : run this program from a terminal
;
; C - source  : http://zetcode.com/tutorials/gtktutorial/gtkevents/
; asm - source: https://github.com/agguro/gtk-programming
;

bits 64

[list -]
     extern    exit
     extern    gtk_button_new_with_label
     extern    gtk_container_add
     extern    gtk_fixed_new
     extern    gtk_fixed_put
     extern    gtk_init
     extern    gtk_main
     extern    gtk_main_quit
     extern    gtk_widget_set_size_request
     extern    gtk_widget_show_all
     extern    gtk_window_new
     extern    gtk_window_set_default_size
     extern    gtk_window_set_position
     extern    gtk_window_set_title
     extern    g_print
     extern    g_signal_connect_data
     extern    gtk_spin_button_new_with_range
     extern    gtk_button_new_with_label
     extern    gtk_label_new
     extern    gtk_label_set_text
     extern    gtk_spin_button_get_value_as_int
     extern    g_strdup_printf
     extern    g_free
     
     %define   GTK_WIN_POS_CENTER       1
     %define   GTK_WINDOW_TOPLEVEL      0
     %define   NULL                     0
     
[list +]

section .data

     window:
     .handle:  dq   0
     .title:   db   "GtkButton", 0
     
     fixed:
     .handle:  dq   0
     
     button:
     .handle:  dq   0
     .label:   db   "Click", 0
     button_new:
     .handle:  dq   0
     .label:   db   "Add", 0

     res_label:
     .handle:  dq   0
     .label:   dq   "0", 0

     int_format dq "Res: %d", 0
     
     spin_a:
          .handle dq 0

     spin_b:
          .handle dq 0
     
     res_str:   dq 0
     signal:
     .clicked: db   "clicked", 0
     .destroy: db   "destroy", 0
     
     message:
     .clicked: db   "Clicked", 10, 0
     
section .text
     global _start
_start:

     xor       rdi, rdi                      ; no commandline arguments will be passed
     xor       rsi, rsi
     call      gtk_init

     mov       rdi, GTK_WINDOW_TOPLEVEL
     call      gtk_window_new
     mov       qword[window.handle], rax
     
     mov       rsi, window.title
     mov       rdi, qword[window.handle]
     call      gtk_window_set_title
     
     mov       rdx, 200
     mov       rsi, 260
     mov       rdi, qword[window.handle]
     call      gtk_window_set_default_size
     
     mov       rsi, GTK_WIN_POS_CENTER
     mov       rdi, qword[window.handle]
     call      gtk_window_set_position

     call      gtk_fixed_new
     mov       qword[fixed.handle], rax
     
     mov       rsi, qword[fixed.handle]
     mov       rdi, qword[window.handle]
     call      gtk_container_add

     mov       rdi, button_new.label
     call      gtk_button_new_with_label
     mov       qword[button_new.handle], rax
     
     mov       rcx, 150
     mov       rdx, 70
     mov       rsi, qword[button_new.handle]
     mov       rdi, qword[fixed.handle]
     call      gtk_fixed_put
     
     mov       rdx, 35
     mov       rsi, 100
     mov       rdi, qword[button_new.handle]
     call      gtk_widget_set_size_request


     mov       rdi, __?float64?__(-2147483648.0)
     movq      XMM0, rdi
     mov       rsi, __?float64?__(+2147483647.0)
     movq      XMM1, rsi
     mov       rdx, __?float64?__(1.0)
     movq      XMM2, rdx
     call      gtk_spin_button_new_with_range 
     mov       qword[spin_a.handle], rax

     mov       rcx, 20
     mov       rdx, 8
     mov       rsi, qword[spin_a.handle]
     mov       rdi, qword[fixed.handle]
     call      gtk_fixed_put
     
     mov       rdx, 0
     mov       rsi, 250
     mov       rdi, qword[spin_a.handle]
     call      gtk_widget_set_size_request

     mov       rdi, __?float64?__(-2147483648.0)
     movq      XMM0, rdi
     mov       rsi, __?float64?__(+2147483647.0)
     movq      XMM1, rsi
     mov       rdx, __?float64?__(1.0)
     movq      XMM2, rdx
     call      gtk_spin_button_new_with_range 
     mov       qword[spin_b.handle], rax

     mov       rcx, 60
     mov       rdx, 8
     mov       rsi, qword[spin_b.handle]
     mov       rdi, qword[fixed.handle]
     call      gtk_fixed_put
     
     mov       rdx, 0
     mov       rsi, 250
     mov       rdi, qword[spin_b.handle]
     call      gtk_widget_set_size_request

     call      gtk_label_new
     mov       qword[res_label.handle], rax

     mov       rdi,qword[res_label.handle]
     mov       rsi,res_label.label
     call      gtk_label_set_text
     mov       rcx, 100
     mov       rdx, 20
     mov       rsi, qword[res_label.handle]
     mov       rdi, qword[fixed.handle]
     call      gtk_fixed_put
     
     mov       rdx, 35
     mov       rsi, 200
     mov       rdi, qword[res_label.handle]
     call      gtk_widget_set_size_request
     
     xor       r9d, r9d
     xor       r8d, r8d
     mov       rcx, NULL
     mov       rdx, button_clicked
     mov       rsi, signal.clicked
     mov       rdi, qword[button_new.handle]
     call      g_signal_connect_data

     xor       r9d, r9d
     xor       r8d, r8d
     mov       rcx, NULL
     mov       rdx, gtk_main_quit
     mov       rsi, signal.destroy
     mov       rdi, qword[window.handle]
     call      g_signal_connect_data

     mov       rdi, qword[window.handle]
     call      gtk_widget_show_all

     call      gtk_main
     
     xor       rdi, rdi
     call      exit

button_clicked:
    push  rsi

    mov         rdi, qword[spin_a]
    call        gtk_spin_button_get_value_as_int
    mov         rdx, rax

    mov         rdi, qword[spin_b]
    call        gtk_spin_button_get_value_as_int

    add         rdx, rax

    mov         rcx, rdx
    mov         rsi, rcx
    mov         rax, 1
    mov         rdi, int_format
    call        g_strdup_printf
    mov         [res_str],  rax

    mov         rdi, qword[res_label.handle]
    mov         rsi, [res_str]
    call        gtk_label_set_text

    mov         rdi, [res_str]
    call        g_free
    mov         qword[res_str], 0

    pop  rsi
    ret