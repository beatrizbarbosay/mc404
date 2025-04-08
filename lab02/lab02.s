.globl _start

_start:
  li a0, 245609 
  li a1, 0
  li a2, 0
  li a3, -1
loop:
  andi t0, a0, 1 #t0 = a0 & 1, t0=1
  add  a2, a2, t0 #a2 = a2 + t0, a2=1
  xor  a1, a1, t0 #a1 = a1 ^ t0, a1=1
  addi a3, a3, 2 #a3 = a3 + 2, a3=1
  srli a0, a0, 1 #a0 = a0 >> 1, a0=245609 , shift pra direita 
  bnez a0, loop #se a0 != 0, loop

end:
  la a0, result
  sw a2, 0(a0)
  li a0, 0
  li a7, 93
  ecall

result:
  .word 0