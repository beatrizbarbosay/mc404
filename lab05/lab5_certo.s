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

    lb t1, 1(t0) //primeiro numero da entrada
    lb t2, 2(t0) //segundo numero da entrada
    addi t1, t1, -48 //transforma em int
    addi t2, t2, -48
    li t3, 10
    mul t1, t1, t3 //transforma em decimal
    add t1, t1, t2 //t1 = x1

    lb t2, 4(t0) //faz o mesmo para y1
    lb t3, 5(t0)
    addi t2, t2, -48
    addi t3, t3, -48
    li t4, 10
    mul t2, t2, t4
    add t2, t2, t3  //t2 = y1

    lb t3, 9(t0)
    lb t4, 10(t0)
    addi t3, t3, -48
    addi t4, t4, -48
    li t5, 10
    mul t3, t3, t5
    add t3, t3, t4 //t3 = x2

    lb t4, 20(t0)
    lb t5, 21(t0)
    addi t4, t4, -48
    addi t5, t5, -48
    li t6, 10
    mul t4, t4, t6
    add t4, t4, t5 //t4 = y3


    sub a0, t3, t1
    mul a0, a0, a0 // a0 = (x2 - x1)²

    sub a1, t4, t2
    mul a1, a1, a1 //a1 = (y3 - y1)²

    add a2, a0, a1 //a2 = x² + y²

    li t0, 0  //contador
    li t1, 0  // para guardar o resultado

loop:
    mul t2, t0, t0
    bge t2, a2, quadradoperfeito
    mv t1, t0
    addi t0, t0, 1
    j loop

quadradoperfeito:
    beq t2, a2, raiz_perfeita
    j fim

raiz_perfeita:
    mv t1, t0

fim:
    la t3, result //carrega o endereço do resultado
    li t4, 100
    div t5, t1, t4 //t5 = t1 / 100, para converter em string
    addi t5, t5, 48 // tabela ASCII
    sb t5, 0(t3) //guarda no primeiro bit

    rem t1, t1, t4 //pega o resto da divisao
    li t4, 10 //faz o mesmo para o resto do código
    div t5, t1, t4
    addi t5, t5, 48
    sb t5, 1(t3)

    rem t1, t1, t4
    addi t1, t1, 48
    sb t1, 2(t3)

    li t6, 10 // /n na tabela ASCII
    sb t6, 3(t3)
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