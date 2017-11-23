# Stephen Ermshar
# CPTR 280
# Final Project: get instruction test
# 2017 NOV 23
# version history: https://github.com/sermshar/cptr280

.data
    opc:        .word   0x3c081001

.text
    main:
        la      $t0,    opc
        lw      $s0,    0($t0)
        srl     $s0,    $s0,    26

        la		$t0,    0x00400000
        lw		$a0,    0($t0)
        lw      $s1,    0($t0)
        srl     $s1,    $s1,    24

        # lb loads the last bit, not the first, instructions will need to be loaded as words if they are to be parsed opcode first

        li		$v0,	1				# syscall_1: print int
        syscall