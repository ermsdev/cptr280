## Program to swap two memory words
	
	.data           # load data
	.word 7
	.word 3

	.text
	.globl	main
	
main:
	lui $s0, 0x1001 # load data area start address 0x10010000
	lw  $s1, 0($s0)
	lw  $s2, 4($s0)
	sw  $s2, 0($s0)
	sw  $s1, 4($s0)