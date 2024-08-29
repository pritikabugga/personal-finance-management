# Assembly version of stencil program
.globl main
.data
B: .space 40      # declares an INT array of size 10
B2: .space 40    # declares an INT array of size 10
M: .word 10      # int M = 10, used for loop upper limit
i: .space 4        # declare loop variable
str1: 
.string "B2["
str2: 
.string "] = "
str3: 
.string "B["
newline: 
.string "\n"
#
.text
main:
    # Get the base addresses of the arrays and variables
    la x18, B      # Load base address of B into register x18
    la x19, B2     # Load base address of B2 into register x19
    la x20, M      # Load M into register x20
    la x23, i      # Initialize loop variable i to 0

    # Loop to fill array B with values from 0 to M-1
fill_B_loop:
    lw x24, 0(x20)   # Load M into register x24
    lw x30, 0(x23)
    Loop: bge x30, x24,fill_B_done # Exit loop if i >= M
    slli x25, x30, 2  # Calculate offset by multiplying by 4 (size of int)
    add x25, x18, x25  # Calculate address of B[i] into x25
    sw x30, 0(x25)     # Store value of i at address B[i]
    addi x30, x30, 1   # Increment i
    beq x0,x0,Loop # Jump back to fill_B_loop


fill_B_done:
    li x27, 0
    li x28, 10
    # Print "B["
    printB_Loop: bge x27, x28,printB_Loop_Done
    la a0, str3    # Load the address of msg1 into a0
    li a7, 4       # System call number for print string
    ecall

    # Print i
    mv a0, x27      # Move i to a0 for printing
    li a7, 1       # System call number for print integer
    ecall

    # Print "] = "
    la a0, str2    # Load the address of msg2 into a0
    li a7, 4       # System call number for print string
    ecall

    # Print B[i]
    slli t1, x27, 2    # t1 = i * 4 (since each int is 4 bytes)
    add t1, x18, t1    # t1 = &B[i]
    lw a0, 0(t1)      # Load B2[i] into a0
    li a7, 1          # System call number for print integer
    ecall

    # Print newline
    la a0, newline    # Load the address of newline into a0
    li a7, 4          # System call number for print string
    ecall

    addi x27, x27, 1    # i++
    j printB_Loop            # Jump back to the start of the loop
    
printB_Loop_Done:
    # Store B[0] into B2[0]
    lw x21, 0(x18)     # Load B[0] into register x21
    sw x21, 0(x19)     # Store value of B[0] at address B2[0]

    # Store B[M-1] into B2[M-1]
    lw x22, 36(x18)    # Load B[M-1] into register x22 (since M is 10 and each int is 4 bytes, B[M-1] is at address B+36)
    sw x22, 36(x19)    # Store value of B[M-1] at address B2[M-1]

    # Loop to compute B2 values
compute_B2_loop:
    li x27, 1          # Initialize loop variable i to 1
    lw x28, 0(x20)     # Load M into register x28
    addi x28, x28, -1   # Calculate M-1
    Loop2: bge x27, x28,compute_B2_done # Exit loop if i >= M-1

    slli x29, x27, 2   # Calculate offset by multiplying by 4 (size of int)
    add x29, x19, x29  # Calculate address of B2[i] into x29

    slli x30, x27, 2   # Calculate offset by multiplying by 4 (size of int)
    add x30, x18, x30  # Calculate address of B[i] into x30

    lw x31, -4(x30)      # Load B[i-1] into register x31
    lw x15, 0(x30)       # Load B[i] into register x32
    lw x16, 4(x30)       # Load B[i+1] into register x33
    add x31, x31, x15    # Compute B[i-1] + B[i]
    add x31, x31, x16    # Compute B[i-1] + B[i] + B[i+1]
    sw x31, 0(x29)       # Store result at address B2[i]
    addi x27, x27, 1     # Increment i
    beq x0,x0,Loop2 # Jump back to compute_B2_loop
   

compute_B2_done:
    li x27, 0
    li x28, 10
    # Print "B2["
    Loop3: bge x27, x28,exit
    la a0, str1    # Load the address of msg1 into a0
    li a7, 4       # System call number for print string
    ecall

    # Print i
    mv a0, x27      # Move i to a0 for printing
    li a7, 1       # System call number for print integer
    ecall

    # Print "] = "
    la a0, str2    # Load the address of msg2 into a0
    li a7, 4       # System call number for print string
    ecall

    # Print B2[i]
    slli t1, x27, 2    # t1 = i * 4 (since each int is 4 bytes)
    add t1, x19, t1    # t1 = &B2[i]
    lw a0, 0(t1)      # Load B2[i] into a0
    li a7, 1          # System call number for print integer
    ecall

    # Print newline
    la a0, newline    # Load the address of newline into a0
    li a7, 4          # System call number for print string
    ecall

    addi x27, x27, 1    # i++
    j Loop3            # Jump back to the start of the loop

exit:
    # Exit the program

 



