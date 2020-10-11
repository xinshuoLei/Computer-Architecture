# #define MAX_GRIDSIZE 16
# #define MAX_MAXDOTS 15

# /*** begin of the solution to the puzzle ***/

# // encode each domino as an int
# int encode_domino(unsigned char dots1, unsigned char dots2, int max_dots) {
#     return dots1 < dots2 ? dots1 * max_dots + dots2 + 1 : dots2 * max_dots + dots1 + 1;
# }
.globl encode_domino
encode_domino:  
        bge     $a0, $a1, else                          # if dots1 < dots2
        mul     $t0, $a0, $a2                           # $t0 =  dots1 * max_dots
        add     $t0, $t0, $a1                           
        add     $t0, $t0, 1                             # $t0 =  dots1 * max_dots + dots2 + 1
        move    $v0, $t0
        jr      $ra                                     # return dots1 * max_dots + dots2 + 1    
else:
        mul     $t0, $a1, $a2                           # $t0 = dots2 * max_dots
        add     $t0, $t0, $a0
        add     $t0, $t0, 1                             # $t0 = dots2 * max_dots + dots1 + 1
        move    $v0, $t0
        jr      $ra                                     # return dots2 * max_dots + dots1 + 1

# // main solve function, recurse using backtrack
# // puzzle is the puzzle question struct
# // solution is an array that the function will fill the answer in
# // row, col are the current location
# // dominos_used is a helper array of booleans (represented by a char)
# //   that shows which dominos have been used at this stage of the search
# //   use encode_domino() for indexing
# int solve(dominosa_question* puzzle, 
#           unsigned char* solution,
#           int row,
#           int col) {
#
#     int num_rows = puzzle->num_rows;
#     int num_cols = puzzle->num_cols;
#     int max_dots = puzzle->max_dots;
#     int next_row = ((col == num_cols - 1) ? row + 1 : row);
#     int next_col = (col + 1) % num_cols;
#     unsigned char* dominos_used = puzzle->dominos_used;
#
#     if (row >= num_rows || col >= num_cols) { return 1; }
#     if (solution[row * num_cols + col] != 0) { 
#         return solve(puzzle, solution, next_row, next_col); 
#     }
#                                                                                                                              
#     unsigned char curr_dots = puzzle->board[row * num_cols + col];
#                                                                                                
#     if (row < num_rows - 1 && solution[(row + 1) * num_cols + col] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[(row + 1) * num_cols + col],
#                                         max_dots);
#
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[(row + 1) * num_cols + col] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;                                    
#             solution[row * num_cols + col] = 0;
#             solution[(row + 1) * num_cols + col] = 0;
#         }
#     }
#     if (col < num_cols - 1 && solution[row * num_cols + (col + 1)] == 0) {                               
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[row * num_cols + (col + 1)],
#                                         max_dots);
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[row * num_cols + (col + 1)] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[row * num_cols + (col + 1)] = 0;
#         }
#     }
#     return 0;
# }
.globl solve
solve:
        # Plan out your registers and their lifetimes ahead of time. You will almost certainly run out of registers if you
        # do not plan how you will use them. If you find yourself reusing too much code, consider using the stack to store
        # some variables like &solution[row * num_cols + col] (caller-saved convention).

        lw      $t0, 0($a0)                             # $t0 = int num_rows = puzzle->num_rows
        lw      $t1, 4($a0)                             # $t1 = int num_cols = puzzle -> num_cols
        
        blt     $a2, $t0, check_col                     # if row >= num_rows
        li      $v0, 1
        jr      $ra                                     # return 1

check_col:
        blt     $a3, $t1, check_nonzero
        li      $v0, 1
        jr      $ra


check_nonzero:
        mul     $t2, $a2, $t1                           # $t2 = row * num_cols
        add     $t2, $t2, $a3                           # $t2 = row * num_cols + col
        add     $t5, $t2, $a1
        lb      $t3, 0($t5)                             # solution[row * num_cols + col]
        beq     $t3, 0, condition_1                     # if (solution[row * num_cols + col] != 0)

        sub     $sp, $sp, 4
        sw      $ra, 0($sp)
        sub     $t4, $t1, 1                             # $t4 = num_cols - 1
        bne     $t4, $a3, row_same
        add     $a2, $a2, 1                             # $a2 = newt_row = row + 1
row_same:
        add     $a3, $a3, 1
        rem     $a3, $a3, $t1                            # $a3 = next_col = (col + 1) % num_cols
        jal     solve
        lw      $ra, 0($sp)
        add     $sp, $sp, 4
        jr      $ra                                     # return solve(puzzle, solution, next_row, next_col); 

        
 condition_1:
        sub     $sp, $sp, 52
        sw      $ra, 0($sp)
        sw      $a0, 4($sp)
        sw      $a1, 8($sp)
        sw      $a2, 12($sp)
        sw      $a3, 16($sp)
        sw      $s0, 20($sp)
        sw      $s1, 24($sp)
        sw      $s2, 28($sp)
        sw      $s3, 32($sp)
        sw      $s4, 36($sp)
        sw      $s5, 40($sp)
        sw      $s6, 44($sp)
        sw      $s7, 48($sp)

        move    $s0, $t2                                # $s0 = $t2 = row * num_cols + col
        add     $t2, $t2, 12
        add     $t2, $t2, $a0
        lb      $s1, 0($t2)                             # $s1 =  unsigned char curr_dots = puzzle->board[row * num_cols + col]
        move    $s2, $t1                                # $s2 =  int num_cols

        sub     $t1, $t0, 1                             # $t1 = num_rows - 1
        bge     $a2, $t1, condition_2                   # row < num_rows - 1

        add     $s3, $a2, 1                             # $s3 = (row + 1)
        mul     $s3, $s3, $s2
        add     $s3, $s3, $a3                           # $s3 = (row + 1) * num_cols + col
        add     $t1, $s3, $a1                           
        lb      $t1, 0($t1)                             # $t1 =  solution[(row + 1) * num_cols + col]
        bne     $t1, 0, condition_2                     # solution[(row + 1) * num_cols + col] == 0

        add     $t3, $s3, 12
        add     $t3, $t3, $a0
        lb      $a1, 0($t3)                             # $a1 = puzzle->board[(row + 1) * num_cols + col]
        lw      $a2, 8($a0)                             # $a2 = max_dots
        move    $a0, $s1                                # $a0 = curr_dots
        jal     encode_domino
        move    $s4, $v0                                # $s4 =  int domino_code

        lw      $a0, 4($sp)
        lw      $a1, 8($sp)
        lw      $a2, 12($sp)
        lw      $a3, 16($sp)

        add     $t5, $s4, 268
        add     $t5, $t5, $a0
        lb      $t6, 0($t5)                             # $t6 = dominos_used[domino_code]
        bne     $t6, 0, condition_2                     # dominos_used[domino_code] == 0
        
        li      $t6, 1
        sb      $t6, 0($t5)                             # dominos_used[domino_code] = 1     

        add     $t2, $s0, $a1
        sb      $s4, 0($t2)                             # solution[row * num_cols + col] = domino_code

        add     $t2, $s3, $a1
        sb      $s4, 0($t2)                             # solution[(row + 1) * num_cols + col] = domino_code

        sub     $t0, $s2, 1                             # $t0 = num_cols - 1
        bne     $t0, $a3, row_same_
        add     $s5, $a2, 1                             # $s5 = newt_row = row + 1
        j       next_col
row_same_:
        move    $s5, $a2
next_col:
        add     $t0, $a3, 1
        rem     $s6, $t0, $s2                           # $s6 = next_col = (col + 1) % num_cols

        move    $a2, $s5                                # $a2 = next_row
        move    $a3, $s6                                # $a3 = next_col
        jal     solve

        bne     $v0, 1, continue_condition1             # if (solve(puzzle, solution, next_row, next_col))
        li      $v0, 1

        lw      $ra, 0($sp)
        lw      $a0, 4($sp)
        lw      $a1, 8($sp)
        lw      $a2, 12($sp)
        lw      $a3, 16($sp)
        lw      $s0, 20($sp)
        lw      $s1, 24($sp)
        lw      $s2, 28($sp)
        lw      $s3, 32($sp)
        lw      $s4, 36($sp)
        lw      $s5, 40($sp)
        lw      $s6, 44($sp)
        lw      $s7, 48($sp)      
        add     $sp, $sp, 52

        jr      $ra                                     # return 1

continue_condition1:
        lw      $a0, 4($sp)
        lw      $a1, 8($sp)
        lw      $a2, 12($sp)
        lw      $a3, 16($sp)        

        add     $t5, $s4, 268
        add     $t5, $t5, $a0
        
        li      $t6, 0
        sb      $t6, 0($t5)                             # dominos_used[domino_code] = 0

        add     $t2, $s0, $a1
        sb      $t6, 0($t2)                             # solution[row * num_cols + col] = 0

        add     $t2, $s3, $a1
        sb      $t6, 0($t2)                             # solution[(row + 1) * num_cols + col] = 0

condition_2:
        sub     $t0, $s2, 1                             # $t0 = num_cols - 1
        bge     $a3, $t0, end                           # col < num_cols - 1
        
        add     $s7, $s0, 1                             # $s7 =  row * num_cols + (col + 1)
        add     $t0, $s7, $a1
        lb      $t0, 0($t0)                             # $t0 = solution[row * num_cols + (col + 1)] 
        bne     $t0, 0, end                             # solution[row * num_cols + (col + 1)] == 0

        add     $t1, $s7, 12
        add     $t1, $t1, $a0
        lb      $a1, 0($t1)                             # $a1 = puzzle->board[row * num_cols + (col + 1)]
        lw      $a2, 8($a0)                             # $a2 = max_dots
        move    $a0, $s1                                # $a0 = curr_dots
        jal     encode_domino
        move    $s4, $v0                                # $s4 = int domino_code

        lw      $a0, 4($sp)
        lw      $a1, 8($sp)
        lw      $a2, 12($sp)
        lw      $a3, 16($sp)  

        add     $t5, $s4, 268
        add     $t5, $t5, $a0
        lb      $t6, 0($t5)                             # $t6 = dominos_used[domino_code]
        bne     $t6, 0, end                             # dominos_used[domino_code] == 0
        
        li      $t6, 1
        sb      $t6, 0($t5)                             # dominos_used[domino_code] = 1     

        add     $t2, $s0, $a1
        sb      $s4, 0($t2)                             # solution[row * num_cols + col] = domino_code

        add     $t2, $s7, $a1
        sb      $s4, 0($t2)                             # solution[row * num_cols + (col + 1)] = domino_code

        move    $a2, $s5                                # $a2 = next_row
        move    $a3, $s6                                # $a3 = next_col
        jal     solve

        bne     $v0, 1, continue_condition2             # if (solve(puzzle, solution, next_row, next_col))
        li      $v0, 1

        lw      $ra, 0($sp)
        lw      $a0, 4($sp)
        lw      $a1, 8($sp)
        lw      $a2, 12($sp)
        lw      $a3, 16($sp)
        lw      $s0, 20($sp)
        lw      $s1, 24($sp)
        lw      $s2, 28($sp)
        lw      $s3, 32($sp)
        lw      $s4, 36($sp)
        lw      $s5, 40($sp)
        lw      $s6, 44($sp)
        lw      $s7, 48($sp)      
        add     $sp, $sp, 52
        jr      $ra                                     # return 1

continue_condition2:

        add     $t5, $s4, 268
        add     $t5, $t5, $a0
        li      $t6, 0
        sb      $t6, 0($t5)                             # dominos_used[domino_code] = 0     

        add     $t2, $s0, $a1
        sb      $t6, 0($t2)                             # solution[row * num_cols + col] = 0

        add     $t2, $s7, $a1
        sb      $t6, 0($t2)                             # solution[row * num_cols + (col + 1)] = 0

end:
        li      $v0, 0 

        lw      $ra, 0($sp)
        lw      $a0, 4($sp)
        lw      $a1, 8($sp)
        lw      $a2, 12($sp)
        lw      $a3, 16($sp)
        lw      $s0, 20($sp)
        lw      $s1, 24($sp)
        lw      $s2, 28($sp)
        lw      $s3, 32($sp)
        lw      $s4, 36($sp)
        lw      $s5, 40($sp)
        lw      $s6, 44($sp)
        lw      $s7, 48($sp)      
        add     $sp, $sp, 52

        jr      $ra                                     # return 0