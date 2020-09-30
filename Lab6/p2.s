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
    jr      $ra
