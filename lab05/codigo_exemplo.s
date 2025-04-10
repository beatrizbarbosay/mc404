.data
input: .skip 2
output: .skip 2

.text
.globl _start

_start:  
    # Lê a entrada
    li a0, 0           # file descriptor = 0 (stdin)
    la a1, input       # buffer
    li a2, 2          # size
    li a7, 63          # syscall read (63)
    ecall

    la a0, input       # Carrega o endereço do input
    la a1, output      # Carrega o endereço do output
    
    # Carrega o último byte do input para o output
    lb t0, 1(a0)
    sb t0, 1(a1)
    # Carrega o penúltimo byte do input para o output
    lb t0, 0(a0)
    sb t0, 0(a1)

    # Escreve na saída
    li a0, 1  # file descriptor = 1 (stdout)
    la a1, output #  buffer to write the data
    li a2, 2  # size (reads only 1 byte)
    li a7, 64 # syscall write (6)
    ecall

    #Saída do programa
    li a0, 0 # Descreve o código de saída
    li a7, 93 # código de saída
    ecall