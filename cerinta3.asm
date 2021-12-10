.data
	str: .space 401
	chDelim: .asciz " "
	formatPrintf: .asciz "%d\n"
	formatPrintfChr: .asciz "%s\n"
	valori_litere: .long 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
	res: .space 4
	x: .space 4
	lungime: .long 0
	sir_auxiliar: .space 101
	salvare: .long 0
	semn: .long -1
	aux: .space 4
	sir: .space 101
	testt: .space 1
	numar_nou: .long 0
	caracter_nou: .space 4
	pozitie_caracter_nou: .long 0
	reziduu: .space 4
	primul: .space 4
	doilea: .space 4
	primulchar: .space 4
	doileachar: .space 4
	semnvaloare1: .long -1
	semnvaloare2: .long -1
	valoare1: .space 4
	valoare2: .space 4

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
	movl %eax, sir_auxiliar
	pushl res
	call atoi
	popl %ebx
	movl %eax, res
	cmp $0, res
	je verificare_litera_sau_operatie
	pushl res
	pushl $1
	
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
	movl %eax, sir_auxiliar
	cmp $0, res
	je verificare_litera_sau_operatie
	pushl res
	pushl $1
	jmp et_for

verificare_litera_sau_operatie:
	movl sir_auxiliar, %eax
    pushl %eax
    call strlen
    popl %ebx
    movl %eax, lungime
	cmp $1, lungime
	je variabila
	jmp operatie

variabila:
	pushl sir_auxiliar
	pushl $0
	jmp et_for

operatie:
	movl sir_auxiliar, %eax
	movl %eax, sir
    movl sir, %edi
    xorl %ecx, %ecx
    movb (%edi, %ecx, 1), %al
    movb %al, res
	cmp $108, res
	je let
	popl semnvaloare1
	popl valoare1
	popl semnvaloare2
	popl valoare2
	cmp $0, semnvaloare1
	je transformare1
	cmp $0, semnvaloare2
	je transformare2
	pushl valoare2
	pushl $1
	pushl valoare1
	pushl $1
	jmp operatie_continuare

transformare1: 
	xorl %ecx, %ecx
	xorl %eax, %eax
	movl valoare1, %esi
	movb (%esi, %ecx, 1), %al
	subl $97, %eax
	movl %eax, pozitie_caracter_nou
	movl pozitie_caracter_nou, %ecx
	xorl %eax, %eax
	movl $valori_litere, %esi
	movl (%esi, %ecx, 4), %eax
	movl %eax, valoare1
	cmp $0, semnvaloare2
	je transformare12
	pushl valoare2
	pushl $1
	pushl valoare1
	pushl $1
	jmp operatie_continuare

transformare2:
	xorl %ecx, %ecx
	xorl %eax, %eax
	movl valoare2, %esi
	movb (%esi, %ecx, 1), %al
	subl $97, %eax
	movl %eax, pozitie_caracter_nou
	movl pozitie_caracter_nou, %ecx
	xorl %eax, %eax
	movl $valori_litere, %esi
	movl (%esi, %ecx, 4), %eax
	movl %eax, valoare2
	pushl valoare2
	pushl $1
	pushl valoare1
	pushl $1
	jmp operatie_continuare

transformare12:
	xorl %ecx, %ecx
	xorl %eax, %eax
	movl valoare2, %esi
	movb (%esi, %ecx, 1), %al
	subl $97, %eax
	movl %eax, pozitie_caracter_nou
	movl pozitie_caracter_nou, %ecx
	xorl %eax, %eax
	movl $valori_litere, %esi
	movl (%esi, %ecx, 4), %eax
	movl %eax, valoare2
	pushl valoare2
	pushl $1
	pushl valoare1
	pushl $1
	jmp operatie_continuare


operatie_continuare:
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
	popl %edx
	popl x
	popl x
	addl x, %edx
	pushl %edx
	pushl $1
	jmp et_for

scadere:
	popl x
	popl x
	popl %edx
	popl %edx
	subl x, %edx
	pushl %edx
	pushl $1	
	jmp et_for

multiplicare:
	popl %eax
	popl %eax
	popl x
	popl x
	mull x
	pushl %eax
	pushl $1		
	jmp et_for

divide:
	xorl %edx, %edx
	popl x
	popl x
	popl %eax
	popl %eax
	cmp $0, %eax
	jl numarator_negativ
	cmp $0, x
	jl numitor_negativ
	divl x
	pushl %eax
	pushl $1	
	jmp et_for

numarator_negativ:
	mull semn
	xorl %edx, %edx
	cmp $0, x
	jl numarator_numitor_negative
	divl x
	mull semn
	pushl %eax
	pushl $1	
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
	pushl $1
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
	pushl $1
	jmp et_for

let:
	popl numar_nou
	popl numar_nou
	popl caracter_nou
	popl caracter_nou
	xorl %ecx, %ecx
	xorl %eax, %eax
	movl caracter_nou, %esi
	movb (%esi, %ecx, 1), %al
	subl $97, %eax
	movl %eax, pozitie_caracter_nou
	movl pozitie_caracter_nou, %ecx
	movl $valori_litere, %esi
	movl (%esi, %ecx, 4), %eax
	movl numar_nou, %eax
	movl %eax, (%esi, %ecx, 4)
	jmp et_for

exit:
	popl res
	popl res
	pushl res
	pushl $formatPrintf
	call printf
	popl %ebx
	popl %ebx
	
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
