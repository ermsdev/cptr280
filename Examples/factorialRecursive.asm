## Recursive procedure to compute factorial
## Factorial of 4 is displayed
## Procedure fact from COD book Patterson/Hennessy Sec. 3.6
	
	.text
	.globl	main
	
main:
	addi $a0, $0, 4      # load $a0 with number whose factorial is to be computed
	jal fact             # jump and link to recursive fact procedure: return address is saved in $ra
	nop
	move $a0, $v0        # load register $a0 with argument for print_int call	
	li $v0, 1            # load code for print_int call in register $v0
	syscall              # print integer	
	li  $v0, 10          # load code for program exit
	syscall	             # exit
	
fact:
	addi $sp, $sp, -8    # adjust stack for 2 items
	sw $ra, 4($sp)       # save the return address
	sw $a0, 0($sp)       # save the argument n

	slti $t0, $a0, 1     # test for n < 1
	beq $t0, $0, L1      # if n >= 1, go to L1
	nop

	addi $v0, $0, 1      # if n < 1, return 1
	addi $sp, $sp, 8     # pop 2 items off stack
	jr $ra               # return control to after jal
L1:	
	addi $a0, $a0, -1    # n >= 1: argument gets n-1
	jal fact             # call fact with n-1
	nop

	lw $a0, 0($sp)       # return from jal: restore argument n
	lw $ra, 4($sp)       # restore the return address
	addi $sp, $sp, 8     # adjust stack pointer to pop 2 items

	mul $v0, $a0, $v0    # return n * fact(n-1)

	jr $ra               # return to the caller