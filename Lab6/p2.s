# Performs a selection sort on the data with a comparator
# void selection_sort (int* array, int len) {
#   for (int i = 0; i < len -1; i++) {
#     int min_idx = i;
#
#     for (int j = i+1; j < len; j++) {
#       // Do NOT inline compare! You code will not work without calling compare.
#       if (compare(array[j], array[min_idx])) {
#         min_idx = j;
#       }
#     }
#
#     if (min_idx != i) {
#       int tmp = array[i];
#       array[i] = array[min_idx];
#       array[min_idx] = tmp;
#     }
#   }
# }
.globl selection_sort
selection_sort:
    
    sub     $sp, $sp, 28
    sw      $ra, 0($sp)
    sw      $s0, 4($sp)
    sw      $s1, 8($sp)
    sw      $s2, 12($sp)
    sw      $s3, 16($sp)
    sw      $s4, 20($sp)
    sw      $s5, 24($sp)
    
    li      $s0, 0                  # $s0 = i
    move    $s1, $a1                # $s1 = len
    move    $s2, $a0                # $s2 = array
    sub     $s3, $s1, 1             # $s3 = len - 1

outer_loop:
    bge     $s0, $s3, end_outer
    move    $s4, $s0                # $s4 = min_idx = i
    add	    $s5, $s0, 1             # $s5 = j = i+1

inner_loop:             
    bge     $s5, $s1, end_inner    
    mul     $t2, $s5, 4
    add     $t2, $t2, $s2
    lw		$a0, 0($t2)		        # $a0 = array[j]
    mul     $t3, $s4, 4
    add     $t3, $t3, $s2
    lw      $a1, 0($t3)             # $a1 = array[min_idx]
    jal		compare
    bne		$v0, 1, skip
    move    $s4, $s5
skip:
    add     $s5, $s5,1              # j++
    j       inner_loop
end_inner:
    beq		$s4, $s0, continue_outer
    mul     $t2, $s0, 4
    add     $t2, $t2, $s2
    lw      $t0, 0($t2)             # $t0 = tmp = array[i]
    mul     $t3, $s4, 4
    add     $t3, $t3, $s2
    lw      $t1, 0($t3)             # $t1 = array[min_idx]
    sw      $t1, 0($t2)             # array[i] = array[min_idx];
    sw      $t0, 0($t3)             # array[min_idx] = tmp;

    
continue_outer:
    add     $s0, $s0, 1             # i++
    j       outer_loop

end_outer:
    lw      $ra, 0($sp)
    lw      $s0, 4($sp)
    lw      $s1, 8($sp)
    lw      $s2, 12($sp)
    lw      $s3, 16($sp)
    lw      $s4, 20($sp)
    lw      $s5, 24($sp)

    add     $sp, $sp, 28
    jr      $ra



# Draws points onto the array
# int draw_gradient(Gradient map[15][15]) {
#   int num_changed = 0;
#   for (int i = 0 ; i < 15 ; ++ i) {
#     for (int j = 0 ; j < 15 ; ++ j) {
#       char orig = map[i][j].repr;
#
#       if (map[i][j].xdir == 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '.';
#       }
#       if (map[i][j].xdir != 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '_';
#       }
#       if (map[i][j].xdir == 0 && map[i][j].ydir != 0) {
#         map[i][j].repr = '|';
#       }
#       if (map[i][j].xdir * map[i][j].ydir > 0) {
#         map[i][j].repr = '/';
#       }
#       if (map[i][j].xdir * map[i][j].ydir < 0) {
#         map[i][j].repr = '\';
#       }

#       if (map[i][j].repr != orig) {
#         num_changed += 1;
#       }
#     }
#   }
#   return num_changed;
# }
.globl draw_gradient
draw_gradient:

    li      $v0, 0                          # num_changed = 0         
    li      $t0, 0                          # $t0 = i       
    
outer_for:
    bge		$t0, 15, end_outer_for          # if i >= 15, end outer
    li      $t1, 0                          # $t1 = j


inner_for:
    bge     $t1, 15, end_inner_for          # if j >= 15, end inner

    mul     $t2, $t0, 180                   # 180 = 15 * 12
    mul     $t3, $t1, 12                    
    add     $t2, $t2, $t3                   # $t2 = i*4*15 + j*4
    add     $t2, $t2, $a0                   # $t2 = address for map[i][j]
    lb      $t4, 0($t2)                     # $t4 = map[i][j].repr
    move    $t7, $t4                        # $t7 = orig
    lw      $t5, 4($t2)                     # $t5 = map[i][j].xdir
    lw      $t6, 8($t2)                     # $t6 = map[i][j].ydir

    bne     $t5, $zero, second_condition    # map[i][j].xdir == 0 
    bne     $t6, $zero, second_condition    # map[i][j].ydir == 0
    li      $t4, '.'
    sb      $t4, 0($t2)                     # map[i][j].repr = '.'

second_condition:
    beq     $t5, $zero, third_condition     # map[i][j].xdir != 0
    bne     $t6, $zero, third_condition     # map[i][j].ydir == 0 
    li      $t4, '_'
    sb      $t4, 0($t2)                     # map[i][j].repr = '_'

third_condition:
    bne     $t5, $zero, fourth_condition    # map[i][j].xdir == 0
    beq     $t6, $zero, fourth_condition    # map[i][j].ydir != 0
    li      $t4, '|'
    sb      $t4, 0($t2)                     # map[i][j].repr = '|'

fourth_condition:
    mul     $t8, $t5, $t6                   # $t8 =  map[i][j].xdir * map[i][j].ydir
    ble		$t8, $zero, fifth_condition     # map[i][j].xdir * map[i][j].ydir > 0
    li      $t4, '/'
    sb      $t4, 0($t2)                     # map[i][j].repr = '/'

fifth_condition:
    bge		$t8, $zero, compare_orig        # map[i][j].xdir * map[i][j].ydir > 0
    li      $t4, '\\'
    sb      $t4, 0($t2)                     # map[i][j].repr = '\'
    
compare_orig:
    beq     $t4, $t7, continue              # map[i][j].repr != orig
    add     $v0, $v0, 1

continue:
    add     $t1, $t1, 1
    j       inner_for

end_inner_for:
    add     $t0, $t0, 1
    j       outer_for


end_outer_for:
    jr      $ra
