# Sets the values of the array to the corresponding values in the request
# void fill_array(unsigned request, int* array) {
#   for (int i = 0; i < 6; ++i) {
#     request >>= 3;
#
#     if (i % 3 == 0) {
#       array[i] = request & 0x0000001f;
#     } else {
#       array[i] = request & 0x000000ff;
#     }
#   }
# }
.globl fill_array
fill_array:

    li      $t0, 0                  # $t0 = i

for_loop:
    bge     $t0, 6, end_loop;
    srl     $a0, $a0, 3             # request >>= 3;
    remu    $t1, $t0, 3             # $t1 = i % 3
    mul     $t2, $t0, 4
    add     $t2, $t2, $a1           # $t2 is address for array[i]
    bne     $t1, $zero, else_       # i % 3 == 0
    and     $t5, $a0, 0x0000001f    # $t5 = request & 0x0000001f
    j       store

else_:
    and     $t5, $a0, 0x000000ff    # $t5 = request & 0x000000ff

store:
    sw		$t5, 0($t2)		        # array[i] = $t5
    add     $t0, $t0, 1
    j		for_loop
        

end_loop:
    jr      $ra

