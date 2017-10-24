## Nonsense program to show address calculations for 
## branch and jump instructions
	
	.text 			# text section
	.globl main		# call main by SPIM

# Nonsense code
# Load in SPIM to see the address calculations
main:		
	j label
	add $0, $0, $0
	beq $8, $9, label
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
	add $0, $0, $0
label:
	add $0, $0, $0
