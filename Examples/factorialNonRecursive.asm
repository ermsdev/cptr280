## Program computes the factorial of a number between
## 0 and 10 (inclusive). Any other numbers entered are ignored by the program.
	
        .data
        .align 2
        .space 12
String: .space 16
Input:  .asciiz "\nEnter an integer number between (0 and 10) = "
Output: .asciiz "\n\nThe factorial of number entered is "

        .text
        .globl main
	
main:
        li $2,4                         # System call code for print string
        la $4,Input                     # Argument string as Input
        syscall                         # Print the string

        li $2,5                         # System call code to read int input
        syscall                         # Read it
        move $16,$2                     # move the num entered into $16

        move $4,$2                      # Value read passed to subroutine
        jal Check                       # call subroutine convert
        nop

        addiu $17,$0,1                  # initialize $17 to 1
        move $15,$16                    # make a copy ($15) of the original num
while:  beqz $15,Answer                 # if(num == 0) jump to Answer
        nop

        mul $17,$17,$15                 # $17 = $17 * $15
        addi $15,$15,-1                 # $15 = $15 - 1
        b while                         # branch to while

Answer:
        li $2,4                         # System call code for print string
        la $4,Output                    # Argument string as Input
        syscall                         # Print the string

        li $2,1                         # system call code for print int
        move $4,$17                     # return_value as argument
        syscall

        b Exit                          # branch to Exit

        .text
        .align 2
Check:                                  # Subroutine Check for error checking
        move $8,$4                      # $8 = Number whose factorial is needed
        bltz $8,Exit                    # if($8 < 0) jump to Exit
        nop                             # else
        bgt $8,10,Exit                  # if($8 > 10) jump to Exit
        nop                             # else
        jr $31

Exit:
        li $2,10                        # System call code for exit
        syscall                         # exit

