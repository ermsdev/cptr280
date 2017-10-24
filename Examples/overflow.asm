## Program to show overflow
	
	.text 			# text section
	.globl main		

main:		
	la $t0, value		# load address 'value' into $t0
	lw $t1, 0($t0)		# load maxint into $t1
	lw $t2, 0($t0)		# load maxint into $t2
	
	add $t3, $t1, $t2	# overflow exception on addition - 
				# see registers EPC and Cause
				# read text appendix Sec. A.7 for more information
	
				# replace add by addu - then no exception -
				# but "result" in $t3 is wrong - it is
				# obtained by throwing away the carry-out
				# from the most significant bit
	
	sub $t4, $0, $0         # this statement will not execute because of the exception
				

	.data			# data section
value:	.word 0x7fffffff        # place maxint in memory
