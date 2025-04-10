.data //memória par guardar os dados
input:    .space 3         # 3 bites para a entrada
output:   .space 2         # 2 bites para a saída incluindo /n
.text //inicio do código executável
.globl _start //tipo o main

_start:
    li a0, 0           # stdin
    la a1, input       # a1 = endereço para o input
    li a2, 3           # 3 bytes esperados
    li a7, 63          # código syscall 63= leitura
    ecall //executa
    # Converte input[0] (primeiro número)
    la t0, input //coloca o input num registrador temporario
    lb t1, 0(t0)       # t1 = '3' lb = load byte (pega da memoria)
    li t2, 48          # ASCII de '0'
    sub t1, t1, t2     # t1 = 3
    # Converte input[2] (segundo número)
    lb t3, 2(t0)       # t3 = '4'
    sub t3, t3, t2     # t3 = 4
    # Soma os dois números
    add t4, t1, t3     # t4 = 7
    # Converte o resultado pra ASCII
    add t4, t4, t2     # volta pra caractere: 7 + 48 = '7'
    # Armazena o resultado no buffer de saída
    la t5, output
    sb t4, 0(t5)       # resultado sb = store byte (guarda na memoria)
    li t6, 10
    sb t6, 1(t5)       # \n
    # Escreve o resultado
    li a0, 1           # stdout
    la a1, output
    li a2, 2           # 1 caractere + \n
    li a7, 64 //64 = write
    ecall
    # Finaliza
    li a0, 0
    li a7, 93 //93 = exit
    ecall
