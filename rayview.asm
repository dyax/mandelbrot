
    bits 64
    cpu X64

    %include 'macros.asm'

    extern InitWindow
    extern SetTargetFPS
    extern WindowShouldClose
    extern BeginDrawing
    extern EndDrawing
    extern ClearBackground
    extern DrawText
    extern GetColor 
    extern CloseWindow

    extern pstate
    extern exit

    SCREENWIDTH equ 1280
    SCREENHEIGHT equ 720

    global init

section .text
    title db "Mandelbrot Plot",0

section .text

init:
    push rbp
    mov rbp, rsp
    SHADOWSPACE    
    
    mov rcx, SCREENWIDTH
    mov rdx, SCREENHEIGHT
    lea r8, [title]
    call InitWindow

    mov rcx,30
    call SetTargetFPS

    mov qword[pstate], drawloop 
    
    SHADOWREMOVE
    mov rsp,rbp
    pop rbp
ret


drawloop:
    push rbp
    mov rbp, rsp
    SHADOWSPACE

    .loop:
    call BeginDrawing

    mov rcx, 0xff828282
    call ClearBackground

    call EndDrawing

    call WindowShouldClose
    cmp rax,1
    jne .loop

    call CloseWindow

    mov qword [pstate], exit

    SHADOWREMOVE
    mov rsp, rbp
    pop rbp
ret
    
