# #define NULL 0

# // Note that the value of op_add is 0 and the value of each item
# // increments as you go down the list
# //
# // In C, an enum is just an int!
# typedef enum {
#     op_add,         
#     op_sub,         
#     op_mul,         
#     op_div,         
#     op_rem,         
#     op_neg,         
#     op_paren,
#     constant
# } node_type_t;

# typedef struct {
#     node_type_t type;
#     bool computed;
#     int value;
#     ast_node* left;
#     ast_node* right;
# } ast_node;

# int value(ast_node* node) {
#     if (node == NULL) { return 0; }
#     if (node->computed) { return node->value; }

#     int left = value(node->left);
#     int right = value(node->right);

#     // This can just implemented with successive if statements (see Appendix)
#     switch (node->type) {
#         case constant:
#             return node->value;
#         case op_add:
#             node->value = left + right;
#             break;
#         case op_sub:
#             node->value = left - right;
#             break;
#         case op_mul:
#             node->value = left * right;
#             break;
#         case op_div:
#             node->value = left / right;
#             break;
#         case op_rem:
#             node->value = left % right;
#             break;
#         case op_neg:
#             node->value = -left;
#             break;
#         case op_paren:
#             node->value = left;
#             break;
#     }
#     node->computed = true;
#     return node->value;
# }
.globl value
value:
        bne     $a0, 0, not_null
        jr      $ra 

not_null:
        lb      $t0, 4($a0)                     # $t0 = computed
        bne     $t0, 1, not_computed
        lw      $v0, 8($a0)
        jr      $ra

not_computed:
        sub     $sp, $sp, 20 
        sw      $ra, 0($sp)
        sw      $a0, 4($sp)
        sw      $s0, 8($sp)
        sw      $s1, 12($sp)
        sw      $s2, 16($sp)

        move    $s0, $a0                        # $s0 = node
        lw      $a0, 12($s0)                    # $a0 = left
        jal     value
        move    $s1, $v0                        # $s1 = value(node -> left)
        lw      $a0, 16($s0)
        jal     value          
        move    $s2, $v0                        # $s2 = value(node -> right)

        lw      $t0, 0($s0)                     # $t0 = node -> type

        bne     $t0, 7, op_add                  # case constant
        lw      $v0, 8($s0)
        jr      $ra

op_add: 
        bne     $t0, 0, op_sub                  # case op_add
        add     $t1, $s1, $s2
        sw      $t1, 8($s0)
        j       end

op_sub:
        bne     $t0, 1, op_mul                 # case op_sub
        sub     $t1, $s1, $s2
        sw      $t1, 8($s0)
        j       end

op_mul:
        bne     $t0, 2, op_div                  # case op_mul
        mul     $t1, $s1, $s2
        sw      $t1, 8($s0)
        j       end

op_div:
        bne     $t0, 3, op_rem                  # case op_div
        div     $t1, $s1, $s2
        sw      $t1, 8($s0)
        j       end

op_rem:
        bne     $t0, 4, op_neg                  # case op_rem
        rem     $t1, $s1, $s2
        sw      $t1, 8($s0)
        j       end

op_neg:
        bne     $t0, 5, op_paren                # case op_neg
        sub     $t1, $zero, $s1
        sw      $t1, 8($s0)
        j       end

op_paren:
        bne     $t0, 6, end                     # case op_add
        sw      $s1, 8($s0)

end:
        li      $t2, 1
        sb      $t2, 4($s0)                     # node -> computed = true
        lw      $v0, 8($s0)

        lw      $ra, 0($sp)
        lw      $a0, 4($sp)
        lw      $s0, 8($sp)
        lw      $s1, 12($sp)
        lw      $s2, 16($sp)
        add     $sp, $sp, 20

        jr      $ra



