## Program shows memory storage and access (big vs. little endian)
## SPIM's memory storage depends on that of the underlying machine,
## e.g., Intel 80x86 processors are little-endian

	.data                   # load data into memory data area	
here:	.word 0xabc89725, 100   # word placement in memory is exactly the same in big or 
	                        # little endian -
	                        # these two words are placed starting at byte ddresses 
	                        # 0x10010000 and 0x10010004 going from most significant bit
	                        # at left to least significant at right 
	
	.byte 0, 1, 2, 3        # byte placement in memory differs depending on the machine -
	                        # big-endian: word starting at byte address
				# 0x10010008 is 0x00010203 (bytes are placed left to right) 
	                        # little-endian: word starting at byte address
				# 0x10010008 is 0x03020100 (bytes are placed right to left)
	
	.asciiz "Sample text"   # char placement in memory differs depending on the machine
				# (refer to an ASCII table, e.g., http://www.asciitable.com,
				# for the byte code of each char) -
				# big-endian: bytes corresponding to chars are placed in a
	                        # word going from left to right
				# little-endian: bytes corresponding to chars are placed in a
	                        # word going from right to left
		
there:	.space 6                # keeps 6 empty bytes with bytes being counted starting from
	                        # the left of a word in big-endian or the right in
	                        # little-endian
	
	.byte 85
	
	.align 2		# aligns the next datum at a word boundary
        .byte 32
	
	.text 			# text section
	.globl main		# call main by SPIM	
main:		
	 la $t0, here           
	 lbu $t1, 0($t0)        # load byte depends on the machine -
	                        # big-endian: bytes are counted in a word starting from
	                        # the leftmost (most significant) as byte 0 to rightmost
	                        # (least significant) as byte 3
	                        # little-endian: bytes are counted in a word starting from
	                        # the rightmost (least significant) as byte 0 to leftmost
	                        # (most significant) as byte 3
	
	 lbu $t2, 1($t0)        # the next byte...
	
	 lw  $t3, 0($t0)        # load word is exactly the same in big or little endian -
	                        # it is a copy from a memory word to a register
	
	 sw  $t3, 36($t0)       # store word is exactly the same in big or little endian -
				# is is a copy from a register to a memory word
	
	 sb  $t3, 41($t0)       # store byte depends on the machine, because of the byte
	                        # numbering in a word, in exactly the same way as load
	                        # byte depends
	
