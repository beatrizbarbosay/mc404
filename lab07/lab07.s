.data
newline: .asciz "\n"
buffer: .space 256

.text
.globl _start

_start:
    # Read all input
    li a0, 0            # stdin
    la a1, buffer       # buffer
    li a2, 256          # max length
    li a7, 63           # read syscall
    ecall

    # Parse and calculate
    la a0, buffer
    jal calculate_integral

    # Convert number to string
    mv a1, a0
    la a2, buffer
    jal int_to_string

    # Print result
    li a0, 1            # stdout
    la a1, buffer
    jal strlen
    mv a2, a0
    li a7, 64           # write syscall
    ecall

    # Print newline
    li a0, 1
    la a1, newline
    li a2, 1
    li a7, 64
    ecall

    # Exit
    li a0, 0
    li a7, 93
    ecall

calculate_integral:
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    
    mv s0, a0           # save buffer pointer
    
    # Parse terms
    jal parse_term
    mv s1, a0           # coeff1
    mv s2, a1           # exp1
    mv s0, a2           # new pos
    
    jal parse_term
    mv s3, a0           # coeff2
    mv s4, a1           # exp2
    mv s0, a2
    
    jal parse_term
    mv s5, a0           # coeff3
    mv s6, a1           # exp3
    mv s0, a2
    
    # Parse interval
    jal parse_number
    mv s7, a0           # a
    mv s0, a1
    
    jal parse_number
    mv s8, a0           # b
    
    # Calculate integrals
    mv a0, s1
    mv a1, s2
    mv a2, s7
    mv a3, s8
    jal integral_term
    mv s9, a0
    
    mv a0, s3
    mv a1, s4
    mv a2, s7
    mv a3, s8
    jal integral_term
    add s9, s9, a0
    
    mv a0, s5
    mv a1, s6
    mv a2, s7
    mv a3, s8
    jal integral_term
    add a0, s9, a0
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    lw s9, 40(sp)
    addi sp, sp, 48
    ret

parse_term:
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    
    mv s0, a0
    
    # Get sign
    lb t0, 0(s0)
    li t1, '+'
    beq t0, t1, pos
    li t1, -1
    j get_exp
pos:
    li t1, 1
get_exp:
    addi s0, s0, 2      # skip sign and space
    
    # Parse exponent
    mv a0, s0
    jal parse_number
    mv t2, a0           # exponent
    mv s0, a1           # new pos
    
    # Set coefficient
    mul a0, t1, t2      # coefficient * x^exp
    mv a1, t2           # exponent
    mv a2, s0           # new pos
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 16
    ret

parse_number:
    li t0, 0            # result
    li t1, 10           # base 10
    
loop:
    lb t2, 0(a0)
    li t3, 10           # newline
    beq t2, t3, done
    li t3, 32           # space
    beq t2, t3, done
    
    # Convert digit
    addi t2, t2, -48
    
    # Update number
    mul t0, t0, t1
    add t0, t0, t2
    
    addi a0, a0, 1
    j loop
    
done:
    addi a0, a0, 1      # skip delimiter
    mv a1, a0           # return new pos
    mv a0, t0           # return number
    ret

integral_term:
    # a0: coeff, a1: exp, a2: a, a3: b
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    
    mv s0, a0           # save coefficient
    
    # Calculate (b^(exp+1) - (a^(exp+1)) / (exp+1)
    addi a1, a1, 1      # exp + 1
    
    mv a0, a3           # b
    jal power
    mv t0, a0
    
    mv a0, a2           # a
    jal power
    sub t0, t0, a0      # b^ - a^
    
    div t0, t0, a1      # / (exp+1)
    mul a0, s0, t0      # * coefficient
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 16
    ret

power:
    # a0: base, a1: exponent
    li t0, 1
    li t1, 0
pow_loop:
    beq t1, a1, done_pow
    mul t0, t0, a0
    addi t1, t1, 1
    j pow_loop
done_pow:
    mv a0, t0
    ret

int_to_string:
    # a1: number, a2: buffer
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    
    mv s0, a1           # number
    mv s1, a2           # buffer
    
    # Handle zero case
    bnez s0, not_zero
    li t0, '0'
    sb t0, 0(s1)
    li t0, 0
    sb t0, 1(s1)
    j end_convert
    
not_zero:
    # Handle negative numbers
    bgez s0, positive
    li t0, '-'
    sb t0, 0(s1)
    addi s1, s1, 1
    neg s0, s0
    
positive:
    mv a0, s0
    mv a1, s1
    jal itoa
    
end_convert:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 16
    ret

itoa:
    # a0: number, a1: buffer
    addi sp, sp, -16
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    
    mv s0, a0           # number
    mv s1, a1           # buffer
    
    # Find end of buffer
    mv t0, s1
find_end:
    lb t1, 0(t0)
    beqz t1, end_found
    addi t0, t0, 1
    j find_end
end_found:
    
    # Convert digits
convert_loop:
    li t2, 10
    rem t3, s0, t2      # digit = num % 10
    div s0, s0, t2      # num = num / 10
    
    addi t3, t3, '0'    # convert to ASCII
    sb t3, 0(t0)        # store digit
    
    addi t0, t0, 1      # move pointer
    
    bnez s0, convert_loop
    
    # Null terminate
    sb zero, 0(t0)
    
    # Reverse string
    mv a0, s1
    mv a1, t0
    addi a1, a1, -1
    jal reverse
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 16
    ret

reverse:
    # a0: start, a1: end
    bge a0, a1, reverse_done
    
    lb t0, 0(a0)
    lb t1, 0(a1)
    sb t1, 0(a0)
    sb t0, 0(a1)
    
    addi a0, a0, 1
    addi a1, a1, -1
    j reverse
    
reverse_done:
    ret

strlen:
    # a1: string, returns length in a0
    mv a0, a1
strlen_loop:
    lb t0, 0(a0)
    beqz t0, strlen_done
    addi a0, a0, 1
    j strlen_loop
strlen_done:
    sub a0, a0, a1
    ret