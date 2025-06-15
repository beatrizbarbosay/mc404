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

    li t2,0
    li t3, 4600 //tempo para virar
    loop:
    addi t2, t2, 1
    beq t2, t3, tempo
    li a0, 127
    li a1, rodas
    sb a0, 0(a1) // roda para a direita
    j loop


tempo: //tempo pra continuar reto
    li t0, 0
    sb x0, 0(a1) //para de girar
    li t1, 15000
    reto:
        addi t0, t0, 1
        beq t0, t1, fim
        j reto

    fim:
    li a0, 0
    li a7, 93
    ecall
