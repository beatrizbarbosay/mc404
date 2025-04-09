li x1, 10       # dividendo
li x2, 3        # divisor
li x3, 0        # quociente (resultado)
mv x5, x1       # cópia do dividendo pra subtrair
                # (se não quiser mudar o valor original de x1)

LOOP:
blt x5, x2, FIM # se x5 < x2, para
sub x5, x5, x2  # subtrai o divisor do valor atual
addi x3, x3, 1  # conta quantas subtrações foram feitas
j LOOP

FIM:
mv x4, x5       # o que sobrou é o resto


//multiplicacao com somas
li x1, 3        # multiplicando
li x2, 4        # multiplicador
li x3, 0        # resultado (acumulador)
li x4, 0        # contador

LOOP:
bge x4, x2, FIM
add x3, x3, x1  # soma x1 no acumulador
addi x4, x4, 1  # incrementa o contador
j LOOP

FIM:


