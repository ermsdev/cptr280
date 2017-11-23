# Stephen Ermshar
# CPTR 280
# Final Project: get instruction test
# 2017 NOV 23
# version history: https://github.com/sermshar/cptr280

.data

.text
    main:
        la		$t0,    0x00400000
        lw		$a0,    0($t0)

        li		$v0,	1				# syscall_1: print int
        syscall