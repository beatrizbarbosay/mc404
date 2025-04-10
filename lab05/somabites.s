.data
input:   .space 20
output:  .space 20

.text
.globl _start

_start:
    # Leitura da entrada
    li a0, 0
    la a1, input
    li a2, 20
    li a7, 63
    ecall

    # Conversão do primeiro número
    la t0, input       # ponteiro pro início da string
    li t1, 0           # acumulador do número 1

loop_num1:
    lb t2, 0(t0)       # carrega caractere
    li t4, 32          # espaço
    beq t2, t4, separador
    li t4, 10          # enter
    beq t2, t4, fim

    li t3, 10
    li t4, 48          # ASCII '0'
    sub t2, t2, t4     # converte pra número
    mul t1, t1, t3
    add t1, t1, t2

    addi t0, t0, 1
    j loop_num1

separador:
    addi t0, t0, 1     # pula espaço
    li t5, 0           # acumulador número 2

loop_num2:
    lb t2, 0(t0)
    li t4, 10
    beq t2, t4, soma

    li t3, 10
    li t4, 48
    sub t2, t2, t4
    mul t5, t5, t3
    add t5, t5, t2

    addi t0, t0, 1
    j loop_num2

soma:
    add t6, t1, t5     # t6 = soma

    # Conversão pra string
    la t0, output
    addi t0, t0, 19    # começa do fim
    li t1, 0           # conta os dígitos

convert_loop:
    li t2, 10
    rem t3, t6, t2
    addi t3, t3, 48
    sb t3, 0(t0)
    div t6, t6, t2
    addi t0, t0, -1
    addi t1, t1, 1
    bnez t6, convert_loop

    addi t0, t0, 1     # volta pra início da string
    li t3, 10
    add t2, t0, t1
    sb t3, 0(t2)


    addi t1, t1, 1     # aumenta tamanho da string

    # Escreve na saída
    li a0, 1
    mv a1, t0
    mv a2, t1
    li a7, 64
    ecall

fim:
    li a0, 0
    li a7, 93
    ecall