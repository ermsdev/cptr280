## Procedure call to add 10 to input parameter

## The original code procCallsProg1.asm has been modified:
## in particular we show "pretend" spilling of registers
## into the stack. 
## We see here that, because the stack size varies, the 
## offset of a variable in the stack from the stack pointer 
## varies as well. Therefore, it would be more efficient to
## to use a frame pointer.
	
	.text
 	.globl main
	
main:
	addi $s0, $0, 5
	add  $a0, $s0, $0  # load $a0 with parameter to pass to callee procedure
	
	jal  add10         # jump and link: return address saved in register $ra
	
	add  $s1, $v0, $0  # value returned by callee procedure is in $v0
	add  $s0, $s1, $0
	
	li  $v0, 10        # load code for program end
	syscall	           # exit	
	
add10:
	addi $sp, $sp, -4  # make space in stack to
	sw   $s0, 0($sp)   # save register for caller

        ## PART BELOW HAS BEEN ADDED
	
        addi $t0, $0, 6    # "use" register t0
        addi $t1, $0, 7    # "use" register t1
        addi $t2, $0, 8    # "use' register t2
	
        addi $sp, $sp, -8  # "pretend" we have so many variables we now have to free 
                           #  up t0 and t1, so we make space in the stack to save their    
                           # current values
        sw   $t0, 4($sp)   # save t0
        sw   $t1, 0($sp)   # save t1
                           
                           # after "a lot of work"
        lw   $t0, 4($sp)   # we need the old t0 again
        addi $t0, $t0, 2   # "use" it again
        sw   $t0, 4($sp)   # store it back again

        addi $sp, $sp, -4  # now pretend we have to free up t2 so we have to
        sw   $t2, 0($sp)   # save its current value    

                           # after "more work"   
        lw   $t0, 8($sp)   # we need the old t0 again
                           # COMPARE THE OFFSET FROM $sp FROM THE THE LAST TIME WE
                           # LOADED the old t0 - IT HAS CHANGED!!
       
        ## END OF PART THAT HAS BEEN ADDED

	addi $s0, $a0, 10  # add 10 to input parameter
	add  $v0, $s0, $0  # return value placed in register $v0

	lw   $s0, 12($sp)  # restore register before returning to caller - OFFSET CHANGED

	addi $sp, $sp, 16  # restore stack before returning to caller - STACK SIZE DIFFERENT
  
	jr   $ra           # jump to return address to give control back to caller

