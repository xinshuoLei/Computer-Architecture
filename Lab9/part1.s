.data
# syscall constants
PRINT_STRING            = 4
PRINT_CHAR              = 11
PRINT_INT               = 1

# memory-mapped I/O
VELOCITY                = 0xffff0010
ANGLE                   = 0xffff0014
ANGLE_CONTROL           = 0xffff0018

BOT_X                   = 0xffff0020
BOT_Y                   = 0xffff0024

TIMER                   = 0xffff001c

REQUEST_PUZZLE          = 0xffff00d0  ## Puzzle
SUBMIT_SOLUTION         = 0xffff00d4  ## Puzzle

BONK_INT_MASK           = 0x1000
BONK_ACK                = 0xffff0060

TIMER_INT_MASK          = 0x8000      
TIMER_ACK               = 0xffff006c 

REQUEST_PUZZLE_INT_MASK = 0x800       ## Puzzle
REQUEST_PUZZLE_ACK      = 0xffff00d8  ## Puzzle

PICKUP                  = 0xffff00f4

### Puzzle
GRIDSIZE = 8
has_puzzle:        .word 0                         
puzzle:      .half 0:2000             
heap:        .half 0:2000
#### Puzzle



.text
main:
# Construct interrupt mask
	    li      $t4, 0
        or      $t4, $t4, REQUEST_PUZZLE_INT_MASK # puzzle interrupt bit
        or      $t4, $t4, TIMER_INT_MASK	  # timer interrupt bit
        or      $t4, $t4, BONK_INT_MASK	  # timer interrupt bit
        or      $t4, $t4, 1                       # global enable
	    mtc0    $t4, $12

#Fill in your code here
        sw      $0,  ANGLE($0)
        li      $t3, 1
        li      $t2, 1
        sw      $t2, ANGLE_CONTROL($0)
        li      $t1, 10
        sw      $t1, VELOCITY($0)
check_position:
        lw      $t1, BOT_X($0)
        lw      $t2, BOT_Y($0)
point1:
        bne     $t1, 12, point2
        bne     $t2, 4, point2
        li      $t0, 45
        sw      $t0,  ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
point2:
        bne     $t1, 76, point3
        bne     $t2, 68, point3
        li      $t0, 90
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
point3:
        bne     $t1, 76, corn1
        bne     $t2, 100, corn1
        li      $t0, 45
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
corn1:
        bne     $t1, 108, point4
        bne     $t2, 132, point4
        sw      $t3, PICKUP($0)
point4:
        bne     $t1, 132, point5
        bne     $t2, 156, point5
        li      $t0, 90
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
point5:
        bne     $t1, 132, point6
        bne     $t2, 196, point6
        li      $t0, 135
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
point6: 
        bne     $t1, 92, corn2
        bne     $t2, 236, corn2
        li      $t0, 180
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
corn2:
        bne     $t1, 84, point7
        bne     $t2, 236, point7
        sw      $t3, PICKUP($0)
        li      $t0, 0
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
        li      $t4, 1                                  # corn2 picked up
point7:
        bne     $t1, 92, point8
        bne     $t2, 236, point8
        bne     $t4, 1, point8
        li      $t0, 315
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
point8:
        bne     $t1, 132, point9
        bne     $t2, 196, point9
        bne     $t4, 1, point9
        li      $t0, 0
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
point9:
        bne     $t1, 164, point10
        bne     $t2, 196, point10
        li      $t0, 45
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
point10:
        bne     $t1, 188, corn3
        bne     $t2, 220, corn3
        li      $t0, 315
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
corn3:
        bne     $t1, 220, point11
        bne     $t2, 188, point11
        sw      $t3, PICKUP($0)
        li      $t0, 45
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
point11:
        bne     $t1, 244, point12
        bne     $t2, 212, point12
        li      $t0, 90
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
point12:
        bne     $t1, 244, corn4
        bne     $t2, 236, corn4
        li      $t0, 45
        sw      $t0, ANGLE($0)
        sw      $t3, ANGLE_CONTROL($0)
corn4:
        bne     $t1, 284, continue
        bne     $t2, 276, continue
        sw      $t3, PICKUP($0)
        sw      $0,  VELOCITY($0)       

continue:
        j       check_position

infinite:
        j       infinite              # Don't remove this! If this is removed, then your code will not be graded!!!




.kdata
chunkIH:    .space 8  #TODO: Decrease this
non_intrpt_str:    .asciiz "Non-interrupt exception\n"
unhandled_str:    .asciiz "Unhandled interrupt type\n"
.ktext 0x80000180
interrupt_handler:
.set noat
        move      $k1, $at              # Save $at
.set at
        la      $k0, chunkIH
        sw      $a0, 0($k0)             # Get some free registers
        sw      $v0, 4($k0)             # by storing them to a global variable

        mfc0    $k0, $13                # Get Cause register
        srl     $a0, $k0, 2
        and     $a0, $a0, 0xf           # ExcCode field
        bne     $a0, 0, non_intrpt

interrupt_dispatch:                     # Interrupt:
        mfc0    $k0, $13                # Get Cause register, again
        beq     $k0, 0, done            # handled all outstanding interrupts

        and     $a0, $k0, BONK_INT_MASK # is there a bonk interrupt?
        bne     $a0, 0, bonk_interrupt

        and     $a0, $k0, TIMER_INT_MASK # is there a timer interrupt?
        bne     $a0, 0, timer_interrupt

        and 	$a0, $k0, REQUEST_PUZZLE_INT_MASK
        bne 	$a0, 0, request_puzzle_interrupt

        li      $v0, PRINT_STRING       # Unhandled interrupt types
        la      $a0, unhandled_str
        syscall
        j       done

bonk_interrupt:
        sw      $0, BONK_ACK
#Fill in your code here
        j       interrupt_dispatch      # see if other interrupts are waiting

request_puzzle_interrupt:
        sw      $0, REQUEST_PUZZLE_ACK
#Fill in your code here
        j	interrupt_dispatch

timer_interrupt:
        sw      $0, TIMER_ACK
#Fill in your code here
        j   interrupt_dispatch
non_intrpt:                             # was some non-interrupt
        li      $v0, PRINT_STRING
        la      $a0, non_intrpt_str
        syscall                         # print out an error message
# fall through to done

done:
        la      $k0, chunkIH
        lw      $a0, 0($k0)             # Restore saved registers
        lw      $v0, 4($k0)

.set noat
        move    $at, $k1                # Restore $at
.set at
        eret
