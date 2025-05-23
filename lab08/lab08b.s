.data
input_file: .asciz "image.pgm"
image: .space 4109
mensagem: .space 56
mensagem1: .space 32
mensagem2: .space 24
newline: .byte 10
x: .word 0
y: .word 0
pixel: .byte 0
coluna: .word 0
linha: .word 0


.text
.globl _start
_start:
    jal open
    jal read_image
    jal extrair
    jal separarmensagem
    jal decifrar
    jal esconderbits
    jal desenhar
    //jal imprimir
    jal sair

open:
    la a0, input_file #a0 guarda o endereço do arquivo
    li a1, 0
    li a2, 0
    li a7, 1024 #open syscall
    ecall
    ret 

read_image:
    la a1, image #armazena os dados em imagem
    li a2, 4109
    li a7, 63 # read syscall
    ecall
    ret

extrair:
    la a0, image
    addi a0, a0, 13 #pula cabeçalho
    la t2, mensagem #onde vai guardar a mensagem
    li t3, 55

    novobyte:
        li t5, 0 #contador de bits
        li a2, 0 #byte sendo montado

    loop:
        lbu t0, 0(a0) #carrega byte da imagem
        andi t0, t0, 1 #extrai bit menos significativo
        slli a2, a2, 1 #desloca byte atual
        or a2, a2, t0  #adiciona novo bit
        
        addi a0, a0, 1 #próximo byte da imagem
        addi t5, t5, 1 
        li t1, 8
        blt t5, t1, loop  #loop até ter 8 bits
        #se ja tiver 8 bits:
        sb a2, 0(t2) #armazena byte completo
        addi t2, t2, 1 #avança na mensagem
        addi t3, t3, -1 #incrementa contador de bytes
        bnez t3, novobyte # loop até ter 55 bytes
        ret

separarmensagem:
    la t0, mensagem
    addi t0, t0, 31
    la t1, mensagem2
    li t2, 24

    loop2:
        lb t3, 0(t0) #carrega byte da mensagem
        sb t3, 0(t1) #armazena byte na nova mensagem
        addi t0, t0, 1 #próximo byte da mensagem
        addi t1, t1, 1 #próximo byte da nova mensagem
        addi t2, t2, -1 #decrementa contador de bytes
        bnez t2, loop2 #loop até ter 23 bytes
        ret
    #mensagem2 esta no buffer

decifrar:
    la t0, mensagem2
    li t1, 24

    loop3:
        lbu t3, 0(t0) #Carrega o byte da mensagem
        li t4, 32
        beq t3, t4, salvar 
        li t5, 97 #a
        li t6, 122 #z
        blt t3, t5, check_maiuscula
        bgt t3, t6, check_maiuscula
        addi t3, t3, -12 #se for minuscula
        blt t3, t5, wrap # se ultrapassou 'a', faz wrap
        j salvar

    check_maiuscula:
        li t5, 65 #A
        li t6, 90  #Z
        blt t3, t5, salvar
        bgt t3, t6, salvar
        addi t3, t3, -12 #se for maiuscula
        blt t3, t5, wrap
        j salvar

    wrap:
        addi t3, t3, 26
        j salvar

    salvar:
        sb t3, 0(t0)
        addi t0, t0, 1 #próximo byte
        addi t1, t1, -1
        bnez t1, loop3
        ret

esconderbits:
    la a0, image
    li t1, 3917
    add a0, a0, t1 #para caber os 192 bits escondidos
    la a1, mensagem2
    li t6, 24

    montarbyte:
        lbu t1, 0(a1)
        li t5, 8

    loop4:
        slli t2, t1, 24
        srai t2, t2, 31
        andi t2, t2, 1 #pega o bit mais significativo de t1
        lbu t3, 0(a0)
        andi t3, t3, 254
        or t3, t3, t2 #adiciona o bit da mensagem
        sb t3, 0(a0) 
        slli t1, t1, 1 #proximo bit da mensagem
        addi a0, a0, 1 #proximo pixel
        addi t5, t5, -1
        bnez t5, loop4 

        addi a1, a1, 1 #proxima letra da mensagem
        addi t6, t6, -1
        bnez t6, montarbyte
        ret

desenhar:
    li a0, 64 #largura
    li a1, 64 #altura
    li a7, 2201 #syscall setCanvasSize
    ecall

    la t0, image
    addi t0, t0, 13 #pula cabeçalho
    li t1, 0 #contador linha
    li t2, 0 #contador coluna
    li t3, 64 #largura da imagem
    li t4, 64 #altura da imagem

    loopy: 
        li t1, 0

    loopx:
        mul t5, t2, t3 
        add t5, t5, t1
        add t5, t0, t5

        lbu t6, 0(t5) #carrega byte da imagem

        #pra transformar em rgb
        mv a2, t6        
        slli a2, a2, 8  
        or a2, a2, t6       
        slli a2, a2, 8 
        or a2, a2, t6 
        slli a2, a2, 8  
        addi a2, a2, 0xFF 

        mv a0, t1# x
        mv a1, t2# y
        li a7, 2200 #syscall drawPixel
        ecall

        addi t1, t1, 1 #proxima coluna
        blt t1, t3, loopx #loop ate largura

        addi t2, t2, 1 #proxima linha
        blt t2, t4, loopy #loop ate altura
        ret

/*imprimir:
    li a0, 1 #stdout
    la a1, mensagem2
    li a2, 55 
    li a7, 64 # write syscall
    ecall
    
    li a0, 1
    la a1, newline
    li a2, 1
    li a7, 64
    ecall
    ret*/

sair:
    li a0, 0
    li a7, 93          
    ecall