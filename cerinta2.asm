.data
	str: .space 401
	chDelim: .asciz " "
	formatPrintf: .asciz "%d\n"
	formatPrintfChr: .asciz "%s\n"
	res: .space 4
	x: .space 4
	salvare: .long 0
	semn: .long -1
	aux: .space 4
	sir: .space 101

.text

.global main

main:

	pushl $str
	call gets
	popl %ebx

	pushl $chDelim
	pushl $str
	call strtok 
	popl %ebx
	popl %ebx


	movl %eax, res
	pushl res
	call atoi
	popl %ebx
	movl %eax, res
	
	pushl res
	
et_for:

	pushl $chDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 
	

	cmp $0, %eax
	je exit

	pushl %eax

	movl %eax, res
	pushl res
	call atoi
	popl %ebx
	movl %eax, res
	
	popl %eax
	cmp $0, res
	je operatie

	pushl res
	jmp et_for


operatie:
	movl %eax, sir
    
    movl sir, %edi
    xorl %ecx, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, res

	cmp $97, res
	je adunare
	cmp $115, res
	je scadere
	cmp $109, res
	je multiplicare
	cmp $100, res
	je divide

	jmp et_for	
		
adunare:

	popl %edx
	popl x
	addl x, %edx
	pushl %edx
	jmp et_for

scadere:
	popl x
	popl %edx
	subl x, %edx
	pushl %edx
	jmp et_for

multiplicare:
	popl %eax
	popl x
	mull x
	pushl %eax	
	jmp et_for

divide:

	xorl %edx, %edx
	popl x
	popl %eax

	cmp $0, %eax
	jl numarator_negativ

	cmp $0, x
	jl numitor_negativ

	divl x
	pushl %eax
	jmp et_for

numarator_negativ:

	mull semn
	xorl %edx, %edx
	cmp $0, x
	jl numarator_numitor_negative
	
	divl x
	mull semn
	pushl %eax
	jmp et_for

numitor_negativ:
	movl %eax, salvare
	movl x, %eax
	mull semn
	movl %eax, x
	movl salvare, %eax
	
	xorl %edx,  %edx
	divl x
	mull semn
	pushl %eax
	jmp et_for


numarator_numitor_negative:

	movl %eax, salvare
	movl x, %eax
	mull semn
	movl %eax, x
	movl salvare, %eax
	xorl %edx, %edx

	divl x
	pushl %eax
	jmp et_for

exit:
	popl res
	pushl res
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx

	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
