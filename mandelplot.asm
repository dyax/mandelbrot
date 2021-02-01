
    bits 64
    cpu X64

    %include 'macros.asm'

    global plotmandel

    XMAX equ 1280
    YMAX equ 720
    MAXCOUNT equ 256

section .data
    xscale dq 0.0
    yscale dq 0.0
    zx dq 0.0
    zy dq 0.0
    mx dq 0.0
    my dq 0.0
    tempx dq 0.0
    count dq 0

section .bss
    pass resd 1
    plotarray resd 9216000

section .text

plotmandel:
    push rbp
    mov rbp, rsp
    SHADOWSPACE

    sub rsp, 0x18  ; space for local vars lx, ly, ltemp

    %define ltemp qword[rbp-24]
    %define ly qword[rbp-16]     
    %define lx qword[rbp-8]

    finit

    ; xscale = xside / XMAX
    mov ltemp, r8            ;xside
    fld ltemp  
    mov ltemp, XMAX
    fild ltemp 
    fdiv ltemp
    fstp qword[xscale]  
    
    ; yscale = yscale / YMAX 
    mov ltemp, r8            ;yside
    fld ltemp   
    mov ltemp, YMAX
    fild ltemp
    fdiv ltemp
    fstp qword[yscale]  

    mov ly, 0    ; y
    .L1:                    ; outer loop 0-719
    mov lx, 0     ; x
    .L2:                    ; inner loop 0-1279
    
    ; mx = ((x * xscale) + left)
    fild lx
    fld qword[xscale]
    fmul
    mov ltemp, rcx
    fld ltemp
    fadd
    fstp qword[mx]

    ; my = ((y * yscale) + top)
    fild ly
    fld qword[yscale]
    fmul
    mov ltemp, rdx
    fld ltemp
    fadd
    fstp qword[my]

    mov ltemp, 0
    fild ltemp
    fst qword[zx], 
    fstp qword[zy]
    mov qword[count], -1

    .A3:

    ; tempx = ((zx * zx) - (zy * zy)) + mx
    fld qword[zx]
    fld qword[zx]
    fmul
    fld qword[zy]
    fld qword[zy]
    fmul
    fsub
    fld qword[mx]
    fadd
    fstp qword[tempx]

    ; zy = (zx * zy * 2) + my
    fld qword[zx]
    fld qword[zy]
    mov ltemp, 2
    fild ltemp
    fmul
    fmul
    fld qword[my]
    fadd
    fstp qword[zy]

    mov rax, qword[tempx]
    mov qword[zx], rax

    ; rax = ((zx * zx) + (zy + zy))
    fld qword[zx]
    fld qword[zx]
    fmul
    fld qword[zy]
    fld qword[zy]
    fmul
    fadd
    fstp ltemp
    mov rax, ltemp

    inc qword[count]
    
    cmp rax, 4
    jge .A4

    cmp qword[count], MAXCOUNT
    jl .A3

    .A4:

    mov rcx, qword[count]
    mov rdx, lx
    mov r8, ly
    call fillarray

    lea rax, [rbp-8]
    inc qword[rax]
    cmp qword[rax], XMAX
    jne .L2

    lea rax, [rbp-16]
    inc qword[rax]
    cmp qword[rax], YMAX
    jne .L1

    mov rax, qword[plotarray]

    SHADOWREMOVE
    mov rsp,rbp
    pop rbp
ret

fillarray:
    push rbp
    mov rbp, rsp
    SHADOWSPACE

    mov rax, r8     ; y
    shl rax, 10
    shr r8, 8
    add rax, r8
    add rax, rdx    ;x
    mov qword[plotarray+rax],rcx

    SHADOWREMOVE
    mov rsp, rbp
    pop rbp
ret










