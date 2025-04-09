li x1, 4
li x2, 2
li x3, 10
li x4, 7

sub x5, x3, x1
sub x6, x4, x2

mul x5, x5, x5
mul x6, x6, x6

add x7, x5, x6

li x8, 0
li x10, 0 //pra guardar o valor da hipotenusa
LOOP:
mul x9, x8, x8
bge x9, x7 QP //pra conferir se é quadrado perfeito
mv x10, x8
add x8, x8, 1
j LOOP

QP:
beq x9, x7 quadradoperfeito
j FIM

quadradoperfeito:
mv x10, x8


FIM



