.text
.set gps, 0xFFFF0100
.set rodas, 0xFFFF0120
.set motor, 0xFFFF0121
.set anguloz, 0xFFFF0104

.globl _start

_start:
    li a2, 1
    li a3, motor
    sb a2, 0(a3) // acelera o motor

    loop:
    li t4, gps
    li t5, 1
    sb t5, 0(t4) // ativa o gps
    li a3, anguloz
    lw a4, 0(a3) // salva o angulo x
    li a5, 50
    li a0, 127
    bge a5, a4, virar
    li a0, 0
    li a1, rodas
    sb a0, 0(a1) // roda para a esquerda
    j tempo

    virar:
    li a1, rodas
    sb a0, 0(a1) // roda para a direita
    j loop

tempo:
    li t0, 0
    li t1, 15000
    reto:
        addi t0, t0, 1
        beq t0, t1, fim
        j reto

    fim:
    li a0, 0
    li a7, 93
    ecall


        
    

    



     





