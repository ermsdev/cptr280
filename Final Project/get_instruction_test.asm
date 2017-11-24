# Stephen Ermshar
# CPTR 280
# Final Project: get instruction test
# 2017 NOV 23
# version history: https://github.com/sermshar/cptr280

.data
    # opcode bitpatterns include the two leading 0's (beacuse they're 8 bit) so a right shift logical is all that is needed to get the first 6 bits from an instruction to look just like the opcode list
    opc:        .byte   0x00, 0x08, 0x09, 0x00, 0x00, 0x0C, 0x0F, 0x00, 0x00, 0x0D, 0x00, 0x0A, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x01, 0x01, 0x07, 0x06, 0x01, 0x01, 0x05, 0x00, 0x02, 0x03, 0x00, 0x00, 0x10, 0x10, 0x00, 0x20, 0x24, 0x21, 0x25, 0x23, 0x28, 0x29, 0x2B
    prompt:     .asciiz "\n"
.text
    main:
        la      $t0,    opc
    loop:
        lb      $a0,    0($t0)

        li		$v0,	1				# syscall_1: print int
        syscall

        la		$a0,	prompt
        li		$v0,	4				# syscall_4: print string
        syscall

        addi	$t0, $t0, 1

        j loop




    # main:
    #     la      $t0,    opc
    #     lb      $s0,    0($t0)
    #     srl     $s0,    $s0,    

    #     la		$t0,    0x00400000
    #     lw		$a0,    0($t0)
    #     lw      $s1,    0($t0)
    #     srl     $s1,    $s1,    26

    #     # lb loads the last bit, not the first, instructions will need to be loaded as words if they are to be parsed opcode first

    #     li		$v0,	1				# syscall_1: print int
    #     syscall