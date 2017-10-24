## Program to print in a loop
	
	.text			
	.globl main

main:	
	li $v0, 1		# v0 = 1 = code for print_int syscall
	li $t0, 10		# t0 = 10
	add $a0, $zero, $zero	# a0 = 0

loop:
	syscall			# print_int
	addi $a0, $a0, 1	# a0 = a0 + 1 
	ble  $a0, $t0, loop	# if (a0 <= t0)
				# then goto loop 


