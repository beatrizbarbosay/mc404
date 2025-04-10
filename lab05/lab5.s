.globl _start

_start:
    jal main
    li a0, 0
    li a7, 93 # exit
    ecall


main:
    jal read //o input agora esta em "input adress"
    la t0, input_address
    lb t1, 1(t0) //pega os numeros nos bits da entrada
    lb t2, 2(t0)
    lb t4, 4(t0)
    lb t5, 5(t0)
    lb t9, 9(t0)
    lb t10, 10(t0) 
    lb t12, 12(t0) 
    lb t13, 13(t0) 
    lb t17, 17(t0) 
    lb t18, 18(t0)
    lb t20, 20(t0) 
    lb t21, 21(t0) 

    li t3, 48 //tabela ACSII
    sub t1, t1, t3
    sub t2, t2, t3
    sub t4, t4, t3
    sub t5, t5, t3
    sub t9, t9, t3
    sub t10, t10, t3
    sub t12, t12, t3
    sub t13, t13, t3
    sub t17, t17, t3
    sub t18, t18, t3
    sub t20, t20, t3
    sub t21, t21, t3
    
    li t6, 10 //passa pra decimal
    mul t1, t1, t6
    add x1, t1, t2 //x1
    mul t4, t4, t6
    add x2, t4, t5 //y1
    mul t9, t9, t6
    add x3, t9, t10 //x2
    mul t12, t12, t6
    add x4, t12, t13 //y2
    mul t17, t17, t6
    add x5, t17, t18 //x3
    mul t20, t20, t6
    add x6, t20, t21 //y3

    sub x7, x5, x1
    sub x8, x6, x2

    mul x7, x5, x5
    mul x8, x6, x6

    add x9, x7, x8

    li x10, 0
    li x12, 0 //pra guardar o valor da hipotenusa
    LOOP:
    mul x11, x10, x10
    bge x11, x9 QP //pra conferir se é quadrado perfeito
    mv x12, x10
    add x10, x10, 1
    j LOOP

    QP:
    beq x11, x9 quadradoperfeito
    j FIM

    quadradoperfeito:
    mv x12, x10
    FIM

read:
    li a0, 0             # file descriptor = 0 (stdin)
    la a1, input_address # buffer
    li a2, 24            # size - Reads 24 bytes.
    li a7, 63            # syscall read (63)
    ecall
    ret

write:
    li a0, 1            # file descriptor = 1 (stdout)
    la a1, result           # buffer
    li a2, 4            # size - Writes 4 bytes.
    li a7, 64           # syscall write (64)
    ecall
    ret


.bss

input_address: .skip 0x18  # buffer

result: .skip 0x4