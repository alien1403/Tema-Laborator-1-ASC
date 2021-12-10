.data
    sir: .space 101
    aux: .space 2
    formatScanf: .asciz "%s"
    formatSscanf: .asciz "%2x"
    formatPrintf: .asciz "%s"
    variabila: .space 1
    formatSscanfNumar: .asciz "%2d"
    op: .space 1
    res: .space 101
    x: .long 0
    primulCaracter: .space 4
    formatPrintfChar: .asciz "%c"
    formatPrintfNumber: .asciz "%d"
    formatPrintfNumberNegativ: .asciz "%c%d"
    len: .long 0
    cratima: .asciz "-"
    formatPrintfAdd: .asciz "add"
    formatPrintfSub: .asciz "sub"
    formatPrintfMul: .asciz "mul"
    formatPrintfDiv: .asciz "div"
    formatPrintfLet: .asciz "let"
    NewLine: .asciz "\n"
    formatSpatiu: .asciz " "
.text
.global main
main:
    pushl $sir
    pushl $formatScanf
    call scanf
    popl %ebx
    popl %ebx
    movl $sir, %esi

et_for:
    pushl %esi
    call strlen
    popl %ebx
    movl %eax, len
    cmp $0, len
    je et_exit
    xorl %ecx, %ecx
    movb (%esi, %ecx, 1), %al
    movb %al, primulCaracter
    addl $1, %esi
    pushl $2
    pushl %esi
    pushl $aux
    call strncat
    popl %ebx
    popl %ebx
    popl %ebx
    pushl $variabila
    pushl $formatSscanf
    pushl $aux
    call sscanf
    popl %ebx
    popl %ebx
    popl %ebx
    movl $0, aux
    cmp $56, primulCaracter
    je numar_pozitiv
    cmp $57, primulCaracter
    je numar_negativ
    cmp $65, primulCaracter
    je var
    cmp $67, primulCaracter
    je operatie
cont:
    movl $sir, %esi
    addl $3, x
    addl x, %esi
    jmp et_for
flush:
    pushl $formatSpatiu
    call printf
    popl %ebx
    pushl $0
    call fflush
    popl %ebx
    jmp cont
numar_pozitiv:
    pushl variabila
    pushl $formatPrintfNumber
    call printf
    popl %ebx
    popl %ebx
    jmp flush
numar_negativ:
    pushl variabila
    pushl cratima
    pushl $formatPrintfNumberNegativ
    call printf
    popl %ebx
    popl %ebx
    popl %ebx
    jmp flush
var:
    pushl variabila
    pushl $formatPrintfChar
    call printf
    popl %ebx
    popl %ebx
    jmp flush
operatie:
    movl variabila, %eax
    movl %eax, op
    addl $48, op
    cmp $48, op
    je let
    cmp $49, op
    je adunare
    cmp $50, op
    je scadere
    cmp $51, op
    je inmultire
    cmp $52, op
    je impartire
let:
    pushl $formatPrintfLet
    call printf
    popl %ebx
    jmp flush
adunare:
    pushl $formatPrintfAdd
    call printf
    popl %ebx
    jmp flush
scadere:
    pushl $formatPrintfSub
    call printf
    popl %ebx
    jmp flush
inmultire:
    pushl $formatPrintfMul
    call printf
    popl %ebx
    jmp flush
impartire:
    pushl $formatPrintfDiv
    call printf
    popl %ebx
    jmp flush
et_exit:
    pushl $NewLine
    call printf
    popl %ebx
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80
