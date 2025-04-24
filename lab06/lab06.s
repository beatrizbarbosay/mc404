.globl _start

_start:
    jal read 
    jal main
    jal write
    li a0, 0
    li a7, 93 # exit
    ecall

main:
    la t0, input_address //carrega o endereço do input

    lb t1, 0(t0)  //le todos os bites da entrada
    lb t2, 1(t0) 
    lb t3, 2(t0) 
    lb t4, 3(t0) 
    lb t5, 4(t0) 
    lb t6, 5(t0) 
    lb s2, 6(t0)
    addi t1, t1, -48 //transforma o primeiro em int

    li s1, 32 //caractere em ascii referente a espaço
    bne t2, s1, doisdigitos //se o primeiro numero tiver 2 digitos
    addi t3, t3, -48 //se nao, o terceiro bit é o segundo
    li s1, 10
    bne t4, s1, doisdigitos3 //se o segundo numero tiver 2 digitos
    addi t5, t5, -48 //o quinto bit é o terceiro
    mv a1, t1
    mv a2, t3
    mv a3, t5
    j calculo

doisdigitos:
    addi t2, t2, -48 //converte de char para int
    li s1, 10
    mul t1, t1, s1 //para manter o numero em int na base decimal
    add t1, t1, t2 //t1 = CA1

    addi t4, t4, -48
    bne t5, s1, doisdigitos2 //se o segundo numero tiver 2 digitos
    addi t6, t6, -48
    mv a1, t1
    mv a2, t4
    mv a3, t6
    j calculo

doisdigitos2:
    addi t5, t5, -48 
    li s1, 10
    mul t4, t4, s1
    add t4, t4, t5 //t4 = CO1

    addi s2, s2, -48 
    //CA1 = a1, CO1= a2, CO2 = a3
    mv a1, t1
    mv a2, t4
    mv a3, s2
    j calculo

doisdigitos3:
    addi t3, t3, -48;
    addi t4, t4, -48
    li s1, 10
    mul t3, t3, s1
    add t3, t3, t4 //t3 = CO1
    addi t6, t6, -48
    mv a1, t1
    mv a2, t3
    mv a3, t6

    j calculo

calculo: //calculo do cateto
    mul a4, a1, a3
    div a4, a4, a2
    //CA2 = a4

    la t0, result //carrega o endereço do resultado
    li t2, 10
    div t5, a4, t2 // digito da dezena
    rem t4, a4, t2 // digito da unidade

    li t6, 0
    beq t5, t6, unidade //se nao tiver dezena, para nao printar o 0 na frente
    addi t5, t5, 48
    addi t4, t4, 48
    sb t5, 0(t0) //carrega os valores string no endereço do resultado
    sb t4, 1(t0)
    li t6, 10 // /n na tabela ASCII
    sb t6, 2(t0)
    ret

unidade:
    addi t4, t4, 48
    sb t4, 0(t0)
    li t6, 10 // /n na tabela ASCII
    sb t6, 1(t0)
    ret

read:
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 24            # size - Reads 24 bytes.
    li a7, 63            # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result       # buffer
    li a2, 4            # size - Writes 4 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret



.bss
input_address: .skip 0x18  # buffer
result: .skip 0x4