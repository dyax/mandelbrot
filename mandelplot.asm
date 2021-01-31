
    bits 64
    cpu X64

    %include 'macros.asm'

    global plotmandel

section .text

plotmandel:
    push rbp
    mov rbp, rsp
    SHADOWSPACE



    SHADOWREMOVE
    mov rsp,rbp
    pop rbp
ret
