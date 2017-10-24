## Program that computes the average of 4 bytes of a word
	
	.data	
# bval is the address in memory that we are going to read from
bval:	.word 0x10203040

# lval is reserving a space in memory where we will write out answer
lval:	.space 4
	.align 2

	.text
	.globl main
	
main:	
	lw	$t2,bval	# put bval in $t2
	li	$t1,8		# load 8 - the shift value - into $t1

#	first byte -- can put results directly into t3 (running sum) since this
#	is the first value
	andi	$t3,$t2,0x000000FF	# AND to get the lowest byte
	
#	next byte
	srl	$t2,$t2,$t1		# $t2 is shifted right 8 bits ($t1=8)
	andi	$t5,$t2,0x000000FF	# $t5 = $t2 AND 0x000000FF
	add	$t3,$t3,$t5		# $t3=$t3+$t5

#	next byte
	srl	$t2,$t2,$t1		# same as above
	andi	$t5,$t2,0x000000FF
	add	$t3,$t3,$t5

#	last byte -- no need to perform AND
	srl	$t2,$t2,$t1		# $t2 now has 0x000000XX, where XX is what
					# was originally the leftmost 8 bits of bval
	add	$t3,$t3,$t2		# $t3=$t3+$t2

#	total now in $t3
	li	$t1,2			# shift value
	srl	$t3,$t3,$t1		# divide by 4, put answer in $t3

#	now lets put the answer back into memory
	sw	$t3,lval		# memory at lval = $t3

#	system call to exit
	li	$v0,10
	syscall


