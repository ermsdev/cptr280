## Procedure call to swap two array words
	
	.text
	.globl	main
	
main:
	la	$a0, array	# load $a0 with parameter(=array address) to pass to callee procedure
	addi	$a1, $0, 0      # load $a1 with parameter(= 0) to pass to callee procedure

	addi	$sp, $sp, -4	# make space in stack to 	
	sw	$ra, 0($sp)     # save #ra (return address) value though
				# there is no procedure that called the current one
	
	jal	swap            # jump and link: return address stored in register $ra

	lw	$ra, 0($sp)     # control comes back here from callee; restore $ra
	addi	$sp, $sp, 4     # restore stack 
	
	jr	$ra             # give control to calling procedure (default, there is none)

#       equivalent C code:	
#	swap(int v[], int k)
#	{
#		int temp;
#		temp = v[k];
#		v[k] = v[k+1];
#		v[k+1] = temp;
#	}

# swap contents of elements $a1 and $a1+1 of the array that starts at $a0 
swap:	add	$t1, $a1, $a1	# $t1 = 2*$a1	
	add	$t1, $t1, $t1   # $t1 = 4*$a1
	add	$t1, $a0, $t1   # $t1 = array + 4*$a1
	lw	$t0, 0($t1)     # $t0 = array[$a1]
	lw	$t2, 4($t1)     # $t2 = array[$a1+1]
	sw	$t2, 0($t1)     # array[$a1] = array[$a1+1]
	sw	$t0, 4($t1)     # array[$a1+1] = array[$a1]
	jr	$ra             # jump to return address to give control back to caller

	.data
array:	.word 5, 4, 3, 2, 1

