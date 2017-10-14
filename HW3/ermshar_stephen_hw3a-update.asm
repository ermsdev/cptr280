# Stephen Ermshar
# CPTR 280
# HW 3
# 2017 OCT 13

# Referencing your online text book, do the following programming exercises in 
# either QTSpim or the MARS development environment:
#     a. Chapter 2, exercise #1.
#     b. Write a program that will read in an integer between 1 and 500, and output 
#        an integer sum of all integers between 1 and the integer you entered, 
#        inclusive of the end points.

# C2-E1) (i) Write a program which prompts the user to enter their favorite type of pie. 
#        The program should then print out "So you like _____ pie", where the blank 
#        line is replaced by the pie type entered. (ii) What annoying feature of syscall 
#        service 4 makes it impossible at this point to make the output appear on a 
#        single line?

# (a.i)
.text
.globl main
    main:
        # Prompt for the user's favorite pie.
        li $v0, 4
        la $a0, prompt
        syscall
        # Read the pie string.
        li $v0, 8
        la $a0, input
        lw $a1, inputSize
        syscall
        # Output the first part of the response.
        li $v0, 4
        la $a0, output
        syscall
        # Output the pie.
        li $v0, 4
        la $a0, input
        syscall
        # Output the rest of the response.
        li $v0, 4
        la $a0, output2
        syscall
        # Exit the program.
        li $v0, 10
        syscall
.data
    input:     .space  81
    inputSize: .word   80
    prompt:    .asciiz "Favorite Pie: "
    output:    .asciiz "\nSo you like  "
    output2:   .asciiz " pie."

# (a.ii)
# syscall records the new line charachter from the end of the user's input, so in the output
# it starts a new line at the end of the user's answer.