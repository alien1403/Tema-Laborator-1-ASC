.data

    n: .space 4
    m: .space 4
    nume_matrice: .space 1
    matrice: .space 1600
    sir: .space 401
    NewLine: .asciz "\n"
    formatPrintfNumber: .asciz "%d"
    formatPrintfSpace: .asciz " "
    chrDelim: .asciz " "
    formatPrintf: .asciz "%c\n"
    valoare_curenta: .space 4
    index: .long 0
    operatie: .space 4
    dimensiune: .long 0
    res: .space 4
    
    numitor: .long 0
    numarator: .long 0
    rezultat: .long 0
    semn: .long -1 
    salvare: .long 0

    start: .long 0
    index_curent: .long 0
    numar_curent: .long 0


.text

.global main

main:

    pushl $sir
    call gets
    popl %ebx

    pushl $chrDelim
    pushl $sir
    call strtok
    popl %ebx
    popl %ebx

    movl %eax, nume_matrice
    
    pushl $chrDelim
    pushl $0
    call strtok
    popl %ebx
    popl %ebx

    pushl %eax
	call atoi
	popl %ebx
    movl %eax, n

    pushl $chrDelim
    pushl $0
    call strtok
    popl %ebx
    popl %ebx

	pushl %eax
	call atoi
	popl %ebx
	movl %eax, m

    movl %eax, m

    movl n, %eax
    mull m
    movl %eax, dimensiune

    movl $matrice, %esi

valori_matrice:
    movl index, %ecx
    cmp dimensiune, %ecx
    je instructiune

    pushl $chrDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 

    pushl %eax
	call atoi
	popl %ebx

    movl index, %ecx

    movl %eax, (%esi, %ecx, 4)
    
    incl index

    jmp valori_matrice 

instructiune:
    pushl $chrDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 

    pushl $chrDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 

    pushl $chrDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 
    
    pushl %eax
	call atoi
	popl %ebx

    cmp $0, %eax
    je rotire

    movl %eax, valoare_curenta

    pushl $chrDelim
	pushl $0
	call strtok
	popl %ebx
	popl %ebx 

    movl %eax, operatie
    movl operatie, %esi
    xorl %ecx, %ecx
    movb (%esi, %ecx, 1), %al
    movb %al, res

	cmp $97, res
	je adunare
	cmp $115, res
	je scadere
	cmp $109, res
	je multiplicare
	cmp $100, res
	je divide

	
adunare:

    xorl %ecx, %ecx
    movl $matrice, %esi

et_for_adunare:

    cmp dimensiune, %ecx
    je afisare

    movl (%esi, %ecx, 4), %eax
    addl valoare_curenta, %eax
    movl %eax, (%esi, %ecx, 4)

    incl %ecx
    jmp et_for_adunare


scadere:
    xorl %ecx, %ecx
    movl $matrice, %esi

et_for_scadere:

    cmp dimensiune, %ecx
    je afisare

    movl (%esi, %ecx, 4), %eax
    subl valoare_curenta, %eax
    movl %eax, (%esi, %ecx, 4)

    incl %ecx
    jmp et_for_scadere

multiplicare:
    xorl %ecx, %ecx
    movl $matrice, %esi

et_for_multiplicare:

    cmp dimensiune, %ecx
    je afisare

    movl (%esi, %ecx, 4), %eax
    mull valoare_curenta
    movl %eax, (%esi, %ecx, 4)

    incl %ecx
    jmp et_for_multiplicare

divide:
    xorl %ecx, %ecx
    movl $matrice, %esi
    movl $0, index

et_for_divide:

    movl index, %ecx
    cmp dimensiune, %ecx
    je afisare

    movl (%esi, %ecx, 4), %eax
    movl %eax, numarator
    movl valoare_curenta, %eax
    movl %eax, numitor

    cmp $0, numarator
    jl numarator_negativ
    
    cmp $0, numitor
    jl numitor_negativ

    xorl %edx, %edx
    xorl %eax, %eax

    movl numarator, %eax
    divl numitor
    movl %eax, rezultat
    jmp continuare_et_for_divide


continuare_et_for_divide:
    movl $matrice, %esi

    movl rezultat, %eax
    movl %eax, (%esi, %ecx, 4)
    incl index
    jmp et_for_divide


numarator_negativ:
    movl numarator, %eax
    mull semn
    movl %eax, numarator

    cmp $0, numitor
    jl numarator_numitor_negative

    xorl %edx, %edx

    divl numitor
    mull semn
    movl %eax, rezultat
    jmp continuare_et_for_divide  

numitor_negativ:

    movl numitor, %eax
    mull semn
    movl %eax, numitor

    xorl %edx, %edx
    movl numarator, %eax
    divl numitor
    mull semn
    movl %eax, rezultat
    jmp continuare_et_for_divide  

numarator_numitor_negative:

    movl numitor, %eax
    mull semn
    movl %eax, numitor

    xorl %edx, %edx
    movl numarator, %eax
    divl numitor
    movl %eax, rezultat
    jmp continuare_et_for_divide  

rotire:

    pushl m
    pushl $formatPrintfNumber
    call printf
    popl %ebx
    popl %ebx

    pushl $formatPrintfSpace
    call printf
    popl %ebx
    pushl $0
    call fflush
    popl %ebx

    pushl n
    pushl $formatPrintfNumber
    call printf
    popl %ebx
    popl %ebx

    pushl $formatPrintfSpace
    call printf
    popl %ebx
    pushl $0
    call fflush
    popl %ebx

    movl dimensiune, %eax
    subl m, %eax
    movl %eax, start

    jmp et_for_rotire


et_for_rotire:

    movl start, %ecx
    movl %ecx, index_curent
    cmp dimensiune, %ecx
    je et_exit

et_for_rotire_inapoi:

    movl index_curent, %ecx
    cmp $0, %ecx
    jl continuare_et_for_rotire

    movl $matrice, %esi
    movl (%esi, %ecx, 4), %eax
    movl %eax, numar_curent
    
    pushl numar_curent
    pushl $formatPrintfNumber
    call printf
    popl %ebx
    popl %ebx

    pushl $formatPrintfSpace
    call printf
    popl %ebx
    pushl $0
    call fflush
    popl %ebx

    movl index_curent, %ecx
    subl m, %ecx
    movl %ecx, index_curent

    jmp et_for_rotire_inapoi


continuare_et_for_rotire:

    incl start
    jmp et_for_rotire


afisare:

    pushl n
    pushl $formatPrintfNumber
    call printf
    popl %ebx
    popl %ebx

    pushl $formatPrintfSpace
    call printf
    popl %ebx
    pushl $0
    call fflush
    popl %ebx

    pushl m
    pushl $formatPrintfNumber
    call printf
    popl %ebx
    popl %ebx

    pushl $formatPrintfSpace
    call printf
    popl %ebx
    pushl $0
    call fflush
    popl %ebx

    xorl %ecx, %ecx
    movl $matrice, %esi

et_for_afisare:

    pushl %ecx

    cmp dimensiune, %ecx
    je et_exit

    movl (%esi, %ecx, 4), %eax

    pushl %eax
    pushl $formatPrintfNumber
    call printf
    popl %ebx
    popl %ebx

    pushl $formatPrintfSpace
    call printf
    popl %ebx
    pushl $0
    call fflush
    popl %ebx

    popl %ecx
    incl %ecx
    jmp et_for_afisare 

et_exit:

    pushl $NewLine
    call printf
    popl %ebx

    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
