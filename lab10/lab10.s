linha: .asciz "\n"
buffer2: .space 100 #buffer para itoa
hanoi: .space 40
.globl puts
.globl gets
.globl atoi
.globl itoa
.globl exit
.globl fatorial_recursive
.globl fibonacci_recursive
.globl torre_de_hanoi
.text

#char string em a0
puts: #imprime string com final \0
    mv t0, a0
    mv t3, a0 #t3 guarda o início da string
    li t1, 0 #contador de caracteres
    contagem:
        lbu t2, 0(t0)
        beq t2, zero, fim_puts
        addi t0, t0, 1 #avança na string
        addi t1, t1, 1
        j contagem
    fim_puts:
        li a0, 1
        mv a1, t3 #usa o início da string
        mv a2, t1 #tamanho da string
        li a7, 64
        ecall

        li a0, 1
        la a1, linha #printa /n
        li a2, 1
        li a7, 64
        ecall
        ret

gets: #guarda um string do usuario em um buffer
    mv t0, a0 #ponteiro para o buffer
    mv t1, a0 #guarda o endereço inicial
    li t2, '\n'      # código ASCII do \n

    loop_gets:
        li a0, 0
        mv a1, t0 
        li a2, 1 #le um byte
        li a7, 63 #syscall read
        ecall

        lbu t4, 0(t0) #carrega o byte lido
        beq t4, t2, fim_gets #se '\n', termina
        addi t0, t0, 1 #avanca na leitura
        j loop_gets

    fim_gets:
        sb zero, 0(t0) #insere '\0' no final
        mv a0, t1 #retorna o ponteiro inicial
        ret


atoi: #converte string para inteiro
    mv t0, a0 #t0 = endereço da string
    li t1, 0 #t1 = resultado
    li t4, 1 #marcador de negativo

    lbu t2, 0(t0) #carrega o primeiro byte da string
    li t3, '-' 
    bne t2, t3, loop_atoi #se não for negativo, vai pro loop
    li t4, -1
    addi t0, t0, 1 #avança na string para o próximo byte

    loop_atoi:
        lbu t2, 0(t0) #carrega byte da string
        beq t2, zero, fim_atoi #se byte for nulo, fim da string
        li t3, 48 
        sub t2, t2, t3 #converte de ASCII para inteiro
        li a4, 10
        mul t1, t1, a4
        add t1, t1, t2 #adiciona o novo dígito
        addi t0, t0, 1 #avança na string
        j loop_atoi 

    fim_atoi:
    mul t1, t1, t4
        mv a0, t1 #resultado final em a0
        ret

# char *itoa ( int value(a0), char *str(a1), int base(a2));
itoa: #converte inteiro para string
    mv t0, a0 #valor a ser convertido
    mv t1, a1 #endereço da string final
    mv t2, a2 #base de conversão

    la t3, buffer2 #buffer temporário para conversão
    mv a4, t3 #marca o inicio do buffer
    beqz t0, ehzero
    li t4, 10
    li t5, 0 #conferir negativo
    bne t2, t4, loop_itoa #nao considera sinal em hexa
    bge t0, zero, loop_itoa #se for positivo vai pro loop
    li t5, 1 #marca como negativo
    neg t0, t0 #torna positivo para conversão

    loop_itoa:
        rem t6, t0, t2 
        div t0, t0, t2 
        li a3, 10
        blt t6, a3, decimal
        addi t6, t6, 55 #conversao hexadecimal
        j armazena
    decimal:
        addi t6, t6, 48 #conversao decimal
    armazena:
        sb t6, 0(t3) #armazena o dígito no buffer
        addi t3, t3, 1 
        bnez t0, loop_itoa 

        beqz t5, fim_itoa #se não for negativo, pula
        li t6, '-' 
        sb t6, 0(t3) #armazena sinal negativo
        addi t3, t3, 1 #avança no buffer

    fim_itoa:
        addi t3, t3, -1 #ultimo digito
    loop_fim:
        lbu t6, 0(t3) 
        sb t6, 0(t1) #armazena no endereço final
        addi t1, t1, 1 #avança no endereço final
        addi t3, t3, -1 #volta no buffer
        bgeu t3, a4, loop_fim 
        li t6, 0 
        sb t6, 0(t1) #adiciona /0
        mv a0, a1 #retorna o endereço da string final
        ret
    ehzero:
        li t6, '0' 
        sb t6, 0(t1) 
        addi t1, t1, 1
        li t6, 0
        sb t6, 0(t1) 
        mv a0, a1 
        ret

fatorial_recursive: # calcula fatorial recursivamente
    addi sp, sp, -16 # reserva espaço na pilha
    sw ra, 12(sp) # salva o endereço de retorno
    sw s0, 8(sp) #valor de s0 antes da funcai
    mv s0, a0 # s0 = n
    li t0, 1 
    beq s0, zero, caso_base # se n == 0
    beq s0, t0, caso_base # se n == 1
    addi a0, s0, -1 #n - 1
    jal fatorial_recursive #chama recursivamente
    mul a0, a0, s0 
    j fim_fatorial 

    caso_base:
        li a0, 1 #retorna 1
        j fim_fatorial
    
    fim_fatorial:
        lw ra, 12(sp) # restaura o endereço de retorno
        lw s0, 8(sp) # restaura o valor de s0
        addi sp, sp, 16 # libera espaço na pilha
        ret

fibonacci_recursive:
    addi sp, sp, -16
    sw ra, 12(sp) 
    sw s0, 8(sp) # valor de s0 antes da funcao
    sw s1, 4(sp)
    mv s0, a0 # s0 = n
    li t0, 1
    beq s0, zero, caso_zero # se n == 0
    beq s0, t0, caso_basefib # se n == 0
    addi a0, s0, -1 # n - 1
    jal fibonacci_recursive # chama recursivamente para n-1
    mv s1, a0
    addi a0, s0, -2
    jal fibonacci_recursive
    add a0, a0, s1
    j fim_fibonacci

    caso_zero:
        li a0, 0 # retorna 0
        j fim_fibonacci
    caso_basefib:
        li a0, 1 # retorna 1
        j fim_fibonacci
    
    fim_fibonacci:
        lw ra, 12(sp) 
        lw s0, 8(sp) 
        lw s1, 4(sp)
        addi sp, sp, 16 
        ret


torre_de_hanoi: 
    addi sp, sp, -32 # reserva espaço na pilha
    sw ra, 28(sp) 
    sw s0, 24(sp) 
    sw s1, 20(sp) 
    sw s2, 16(sp)
    sw s3, 12(sp) 
    sw s4, 8(sp)
    mv s0, a0 # s0 = n
    mv s1, a1 # s1 = origem
    mv s2, a2 # s2 = destino
    mv s3, a3 # s3 = auxiliar
    mv s4, a4 # s4 = string
    beq s0, zero, fim_hanoi
    addi a0, s0, -1 # n - 1
    mv a1, s1 # origem
    mv a2, s3 # auxiliar
    mv a3, s2 # destino
    mv a4, s4 # string
    jal torre_de_hanoi # chama recursivamente para n-1

    la t0, hanoi #para printar
    mv t1, s4
    loop:
        lbu t2, 0(t1) # carrega o próximo caractere da string
        sb t2, 0(t0) # armazena no buffer hanoi
        beq t2, zero, fim_loop # se for nulo, fim da string
        addi t0, t0, 1 # avança no buffer hanoi
        addi t1, t1, 1 # avança na string
        j loop
    fim_loop:
        la t0, hanoi
        addi t1, s0, 48
        sb t1, 12(t0)
        sb s1, 23(t0)
        sb s3, 38(t0)
        mv a0, t0 # ponteiro para o buffer hanoi
        jal puts

    addi a0, s0, -1
    mv a1, s2 
    mv a2, s1 
    mv a3, s3 
    mv a4, s4 
    jal torre_de_hanoi 

    fim_hanoi:
        lw ra, 28(sp)
        lw s0, 24(sp)
        lw s1, 20(sp)
        lw s2, 16(sp)
        lw s3, 12(sp)
        lw s4, 8(sp)
        addi sp, sp, 32 # libera espaço na pilha
        ret

exit:
    li a7, 93
    ecall