extern printf
global main

SECTION .data

; Input data (hardcoded for simplicity)
x:      dq 722
y:      dq 354

; Printing format
fmt:    db "Part %d: %d", 10, 0

SECTION .text           

;=====================================
; Constants
;=====================================
%define NUM_ITER1   40000000
%define NUM_ITER2   5000000

%define MULX        16807
%define MULY        48271
%define DIV         2147483647

%define MASK        0xFFFF
%define MASK1       3
%define MASK2       7

;=====================================
; Main entry point
;=====================================
main:
    push    rbp
    call    part1
    call    part2

    ; restore stack and return 0 as return value
    pop     rbp    
    mov     rax, 0
    ret

;=====================================
; Part 1
;=====================================
part1:
    mov     rdi, [x]
    mov     rsi, [y]
    mov     rbx, DIV

    xor     rbp, rbp
    xor     rcx, rcx

while:

    ; multiplication/remainder for x
    xor     rdx, rdx
    imul    rax, rdi, MULX
    div     rbx
    mov     rdi, rdx

    ; multiplication/remainder for y
    xor     rdx, rdx
    imul    rax, rsi, MULY
    div     rbx
    mov     rsi, rdx

    ; check if masked parts match
    mov     rax, rdi

    and     rdx, MASK
    and     rax, MASK

    cmp     rax, rdx

    sete	al
    movzx	eax, al
    add     ecx, eax

    inc     ebp
    cmp     ebp, NUM_ITER1
    jl      while

    ; print result of part 1
    mov     rdx, rcx
    mov     rdi, fmt
    mov     rax, 0
    mov     rsi, 1
    call    printf
    ret

;=====================================
; Part 2
;=====================================
part2:
    mov     rdi, [x]
    mov     rsi, [y]
    mov     rbx, DIV

    xor     rbp, rbp
    xor     rcx, rcx

    ; multiplication/remainder for x
whilex:
    xor     rdx, rdx
    imul    rax, rdi, MULX
    div     rbx
    mov     rdi, rdx
    test    rdx, MASK1
    jne     whilex

    ; multiplication/remainder for y
whiley:
    xor     rdx, rdx
    imul    rax, rsi, MULY
    div     rbx
    mov     rsi, rdx
    test    rdx, MASK2
    jne     whiley

    ; check if masked parts match
    mov     rax, rdi

    and     rdx, MASK
    and     rax, MASK

    cmp     rax, rdx

    sete	al
    movzx	eax, al
    add     ecx, eax

    inc     ebp
    cmp     ebp, NUM_ITER2
    jl      whilex

    ; print result of part 2
    mov     rdx, rcx
    mov     rdi, fmt
    mov     rax, 0
    mov     rsi, 2
    call    printf    
    ret
