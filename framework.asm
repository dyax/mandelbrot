
    bits 64
    cpu X64

    global start
    global pstate
    global exit

    %include 'macros.asm'

    extern ExitProcess
    extern init

section .bss

    pstate resq 1

section .text

start:
    sub rsp, 0x8
    SHADOWSPACE    

    mov qword[pstate], init
    
    .loop:
    call [pstate]
    jmp .loop 

    SHADOWREMOVE
ret

exit:
    sub rsp,0x8

    xor rcx,rcx
    call ExitProcess

    add rsp,0x8
ret

