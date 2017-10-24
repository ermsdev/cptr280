## Program showing system calls
## Enter two integers in console window
## Sum is displayed
	
	.text
	.globl main

main:
	la $t0, value 

	li $v0, 5          # load code for read_int call in register $v0
	syscall            # read integer
	sw $v0, 0($t0)     # store integer returned by call (from console)

	li $v0, 5          # load code for read_int call in register $v0
	syscall            # read integer
	sw $v0, 4($t0)     # store integer returned by call (from console)
	
	lw $t1, 0($t0)     
	lw $t2, 4($t0)
	add $t3, $t1, $t2
	sw $t3, 8($t0)

	li $v0, 4          # load code for print_string call in register $v0
	la $a0, msg1       # load register $a0 with argument for print_string call
	syscall            # print string

	li $v0, 1          # load code for print_int call in register $v0
	move $a0, $t3      # load register $a0 with argument for print_int call
	syscall            # print integer

	li  $v0, 10        # load code for program exit
	syscall	           # exit
	
	.data
value:	.word 0, 0, 0
msg1:	.asciiz "Sum = "
