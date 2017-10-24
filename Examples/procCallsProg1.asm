## Procedure call to add 10 to input parameter
	
	.text
 	.globl main
	
main:
	addi $s0, $0, 5
	add  $a0, $s0, $0  # load $a0 with parameter to pass to callee procedure
	
	jal  add10         # jump and link: return address saved in register $ra
	
	add  $s1, $v0, $0  # value returned by callee procedure is in $v0
	add  $s0, $s1, $0
	
	li  $v0, 10        # load code for program end
	syscall	           # exit	
	
add10:
	addi $sp, $sp, -4  # make space in stack to
	sw   $s0, 0($sp)   # save register for caller
	
	addi $s0, $a0, 10  # add 10 to input parameter
	add  $v0, $s0, $0  # return value placed in register $v0

	lw   $s0, 0($sp)   # restore register before returning to caller
	addi $sp, $sp, 4   # restore stack before returning to caller

	jr   $ra           # jump to return address to give control back to caller

