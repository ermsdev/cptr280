# Stephen Ermshar
# CPTR 280
# Final Project
# 2017 DEC 11
# version history: https://github.com/sermshar/cptr280

.data
# http://alumni.cs.ucr.edu/~vladimir/cs161/mips.html
# used a spreadsheet and textwrangler to turn the table in the link into these two lines
# TODO: try pre-sorting these and using a binary search
# NOTE: many instructions share a common initial 6 bits, like sycall and sll (000000) and differ in the last 6 bits.
    opc:        .byte   0x20, 0x21, 0x08, 0x09, 0x24, 0x0C, 0x1A, 0x1B, 0x18, 0x19, 0x27, 0x25, 0x0D, 0x00, 0x04, 0x03, 0x07, 0x02, 0x06, 0x22, 0x23, 0x26, 0x0E, 0x19, 0x18, 0x2A, 0x29, 0x0A, 0x09, 0x04, 0x07, 0x06, 0x05, 0x02, 0x03, 0x09, 0x08, 0x20, 0x24, 0x21, 0x25, 0x23, 0x28, 0x29, 0x2B, 0x10, 0x12, 0x11, 0x13, 0x1A
    opc_txt:    .asciiz "add    ", "addu   ", "addi   ", "addiu  ", "and    ", "andi   ", "div    ", "divu   ", "mult   ", "multu  ", "nor    ", "or     ", "ori    ", "sll    ", "sllv   ", "sra   ", "srav   ", "srl    ", "srlv   ", "sub    ", "subu   ", "xor    ", "xori   ", "lhi    ", "llo    ", "slt    ", "sltu    ", "slti    ", "sltiu  ", "beq    ", "bgtz   ", "blez   ", "bne    ", "j      ", "jal    ", "jalr   ", "jr     ", "lb     ", "lbu    ", "lh     ", "lhu    ", "lw     ", "sb     ", "sh     ", "sw     ", "mfhi   ", "mflo   ", "mthi   ", "mtlo   ", "trap   "

    prompt:     .asciiz "enter the integer decimal representation of an opcode: "
    prompt2:    .asciiz "success"
    prompt3:    .asciiz "fail"
.text
    main:
        la		$a0,	prompt
        li		$v0,	4				# syscall_4: print string
        syscall

        li		$v0,	5				# syscall_5: read int
        syscall 
        move 	$s0,    $v0             # save input to $s0

        # base address of opcode bitpatterns
        la      $s1,    opc
        # base address of opcode strings
        la      $s2,    opc_txt
        # offset for search loop
        li      $s3,    0
    search:
        add		$s4, $s3, $s1       # add the offset and base address of opcode bitpatterns
        # $s4 is now the address of the current bitpattern
        lb      $s5,    0($s4)
        # $s5 is now the current bitpattern
        beq		$s5, $s0, found     # if the input and the current bitpattern are the same, branch to found
        nop
        # bne     $s3, $s0, n_found
        # nop
        addi    $s3,    $s3,    1   # otherwise increment the offset and...
        j		search              # check again
        

    found:
        li      $t0,    8
        mult    $s3,    $t0
        mflo    $s3
        add     $a0,    $s3,    $s2     # add offset * 2 and opcode string base address
        li		$v0,	4				# syscall_4: print string
        syscall

        j end
        nop

    n_found:
        la		$a0,	prompt3
        li		$v0,	4				# syscall_4: print string
        syscall
        j end

    end:
        li		$v0, 10		# $v0 =10 
        syscall
    
        

# use shifts and bools to compare non-byte aligned patterns
#   get first 8 bits (byte) of instruction
#   shift right logical so the last 6 bits of selected byte are the opcode
#   use boolean to compare to opcode table
#   return the offset of the opcode in the table
#   use the offset to find the corresponding ascii opcode
#   