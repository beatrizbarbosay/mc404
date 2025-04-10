.data
result_str: .space 4     # 3 dígitos + \n

.bss
input_buffer: .skip 24

.text
.globl _start

_start:
    jal read_input
    jal parse_and_compute
    jal write_result

    # Finaliza o programa
    li a0, 0
    li a7, 93
    ecall

read_input:
    li a0, 0
    la a1, input_buffer
    li a2, 24
    li a7, 63
    ecall
    ret

parse_and_compute:
    la t0, input_buffer  # t0 = ptr

    # x1 = (input[1]-'0')*10 + (input[2]-'0')
    lb t1, 1(t0)
    lb t2, 2(t0)
    addi t1, t1, -48
    addi t2, t2, -48
    li t3, 10
    mul t1, t1, t3
    add t1, t1, t2       # t1 = x1

    # y1 = (input[4]-'0')*10 + (input[5]-'0')
    lb t2, 4(t0)
    lb t3, 5(t0)
    addi t2, t2, -48
    addi t3, t3, -48
    li t4, 10
    mul t2, t2, t4
    add t2, t2, t3       # t2 = y1

    # x2 = (input[9]-'0')*10 + (input[10]-'0')
    lb t3, 9(t0)
    lb t4, 10(t0)
    addi t3, t3, -48
    addi t4, t4, -48
    li t5, 10
    mul t3, t3, t5
    add t3, t3, t4       # t3 = x2

    # y3 = (input[20]-'0')*10 + (input[21]-'0')
    lb t4, 20(t0)
    lb t5, 21(t0)
    addi t4, t4, -48
    addi t5, t5, -48
    li t6, 10
    mul t4, t4, t6
    add t4, t4, t5       # t4 = y3

    # x = abs(x2 - x1)
    sub a0, t3, t1
    blt a0, zero, abs_x
    j square_x
abs_x:
    neg a0, a0
square_x:
    mul a0, a0, a0       # a0 = x²

    # y = abs(y3 - y1)
    sub a1, t4, t2
    blt a1, zero, abs_y
    j square_y
abs_y:
    neg a1, a1
square_y:
    mul a1, a1, a1       # a1 = y²

    # soma dos quadrados
    add a2, a0, a1       # a2 = x² + y²
    
    li t0, 0             # contador
    li t1, 0             # resultado

loop:
    mul t2, t0, t0
    bge t2, a2, test_eq
    mv t1, t0
    addi t0, t0, 1
    j loop

test_eq:
    beq t2, a2, raiz_perfeita
    j fim

raiz_perfeita:
    mv t1, t0

fim:
    # resultado em t1

    # conversão p/ string
    la t3, result_str
    li t4, 100
    div t5, t1, t4
    addi t5, t5, 48
    sb t5, 0(t3)

    rem t1, t1, t4
    li t4, 10
    div t5, t1, t4
    addi t5, t5, 48
    sb t5, 1(t3)

    rem t1, t1, t4
    addi t1, t1, 48
    sb t1, 2(t3)

    li t6, 10
    sb t6, 3(t3)

    ret

write_result:
    li a0, 1
    la a1, result_str
    li a2, 4
    li a7, 64
    ecall
    ret
