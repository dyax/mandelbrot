
    bits 64
    cpu X64

    %include 'macros.asm'

    global plotmandel


section .bss
    pass resd 1

section .text

plotmandel:
    push rbp
    mov rbp, rsp
    SHADOWSPACE

    xor rax,rax
    mov qword[pass], rax   

    mov dword[pass], 0xffff0000    ;pass color 0x0000ffff -- blue
    mov rax, qword[pass]           ;little endian

    SHADOWREMOVE
    mov rsp,rbp
    pop rbp
ret
