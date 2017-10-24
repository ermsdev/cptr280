# Stephen Ermshar
# CPTR 280
# HW 4
# 2017 OCT 18
# version history: https://github.com/sermshar/cptr280

# PART 1

.data
    array_1:    .space  20                  # allocate 5 words (20 bytes) for array in (f)
    hello_w:    .asciiz "Hello World"

.text
.globl main
    main:
        # a) t3=t4+t5–t6; (5)
        li      $t4,    20
        li      $t5,    30
        li      $t6,    40
        add     $t3,    $t4,    $t5
        sub     $t3,    $t3,    $t6

        # b) s3 = t2/(s1 – 5); (5 + 38)
        li      $s1,    20
        li      $t2,    105
        li      $t0,    5
        sub     $s3,    $s1,    $t0
        div     $t2,    $s3
        mflo    $s4

        # c) sp=sp–16; (1)
        addi $sp, $sp, -16

        # d) cout << t3; (4)
        li      $t3,    'a'
        move    $a0,    $t3
        li      $v0,    1                   # syscall_1 = print_int_$a0
        syscall

        # e) cin >> t0; (3)
        li      $v0,    5                   # syscall_1 = read_int
        syscall
        move    $t0,    $v0

        # f) a0 = &array; (1)
        la      $a0,    array_1             # load base address of array1 into $a0

        # g) t8 = mem(a0); (1)
        lw      $t8,    0($a0)

        # h) mem(a0 + 16) = 32768; (2)
        li      $s0,    32768
        sw      $s0,    16($a0)

        # i) Cout << “Hello World”; (3)
        la      $a0,    hello_w
        li      $v0,    4                   # syscall_4 = print_string_$a0
        syscall

        # j) t0 = 2147483647 – 2147483648; (3)
        li      $t0,    2147483647          # must use li, because numbers this big don't
        li      $t1,    -2147483648			# fit in the addi comand
        add     $t0,    $t0,    $t1

        # k) s0=-1*s0; (2 + 32)
        li      $t0,    -1
        mult    $t0,    $s0                 # $t0 * $s0 = Hi and Lo registers
        mflo    $s0                         # copy $Lo to $s0

        # l) s1=s1*a0; (32 + 1)
        mult    $a0,    $s1
        mflo    $s1                         # copy $Lo to $s0

        # m) s2=s4*8; (32 + 2)
        li      $t0,    8
        mult    $s4,    $t0                 # $s4 * $t0 = Hi and Lo registers
        mflo    $s2                         # copy $Lo to $s2

        # exit program (2)
        li      $v0     10
        syscall

# PART 2

# Everything seems to run correctly in QtSpim, however, I did run into issues with memory allocation with my hello world cout. I think part (h) was over-extending from the beginning of the array, all the way into memory that was intended for "hello world". the solution was to extend the size of the space allocated for the array, so when part (h) accessed memory at a 16 byte offset from the beginning of the array, it was still within the array. the alternative was to just change the order of "hello world" and the array in memory.


# PART 3

# If each command takes 1 clock cycle, multiplication takes 32, and devision takes 38, this program should use about 169 cycles.