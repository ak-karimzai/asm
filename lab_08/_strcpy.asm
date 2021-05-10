global _strcpy

section .text

    lea rdx, [rdi]
_strcpy:
    lodsb
    test al, al
    stosb
    jnz _strcpy
    lea rax, [rdx]
    ret