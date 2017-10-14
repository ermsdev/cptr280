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

# (b)
.text
.globl main
    main:
        # Prompt for the number
        li $v0, 4
        la $a0, prompt2
        syscall
        # Read the integer and save it in $s0
        li $v0, 5            # syscall: 5: read integer
        syscall
        move $s0, $v0        # put user input in $s0
        move $s1, $zero      # $s1 <- 0, initialize accumulator 
	    move $s2, $zero         # $s2 <- 0, initialize iterations counter
        addi $s0, $s0, 1     # increment user input so beq directive goes all the way

    loop: 
        slt $s3, $s2, $s0    # "set on less than":  $s3->1 if $s2<$s0
        beq $s3, $0, end_lop # "branch on equal": if $s2=0: go to end-lop
        add $s1, $s1, $s2    # $s1 <- $s1 + $s2, add number
        addi $s2, $s2, 1     # $s1 <- $s1 + 1, update counter of iterations
        j loop               # go to loop
        nop
	
    end_lop: 
        move $a0, $s1         # $a0 <- $s4, load result of sum
        li $v0,1             # $v0 <- service #1 (data is already in $a0)
        syscall              # call to system service
	
        # Exit the program.
        li $v0, 10
        syscall
.data
    prompt2: .asciiz "Enter n less than 500: "