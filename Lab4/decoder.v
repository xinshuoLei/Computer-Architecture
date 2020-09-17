// mips_decode: a decoder for MIPS arithmetic instructions
//
// rd_src      (output) - should the destination register be rd (0) or rt (1)
// writeenable (output) - should a new value be captured by the register file
// alu_src2    (output) - should the 2nd ALU source be a register (0), zero extended immediate or sign extended immediate
// alu_op      (output) - control signal to be sent to the ALU
// except      (output) - set to 1 when the opcode/funct combination is unrecognized
// opcode      (input)  - the opcode field from the instruction
// funct       (input)  - the function field from the instruction
//

module mips_decode(rd_src, writeenable, alu_src2, alu_op, except, opcode, funct);
    output       rd_src, writeenable, except;
    output [1:0] alu_src2;
    output [2:0] alu_op;
    input  [5:0] opcode, funct;

    wire r = (opcode == `OP_OTHER0);

    wire w_add = r & (funct == `OP0_ADD);
    wire w_sub = r & (funct == `OP0_SUB);
    wire w_and = r & (funct == `OP0_AND);
    wire w_or  = r & (funct == `OP0_OR);
    wire w_nor = r & (funct == `OP0_NOR);
    wire w_xor = r & (funct == `OP0_XOR);

    wire addi = (opcode == `OP_ADDI);
    wire andi = (opcode == `OP_ANDI);
    wire ori  = (opcode == `OP_ORI);
    wire xori = (opcode == `OP_XORI);

    assign rd_src = ~r;
    assign except = ~(w_add | w_sub | w_and | w_or | w_nor | w_xor | addi | andi | ori | xori);
    assign writeenable = w_add | w_sub | w_and | w_or | w_nor | w_xor | addi | andi | ori | xori;
    assign alu_src2 = r ? 0 :
                      addi ? 1 :
                      2;
    assign alu_op = (addi | w_add) ?  2 :
                    w_sub ? 3 :
                    (andi | w_and) ? 4 :
                    (ori  | w_or) ? 5 :
                    w_nor ? 6 :
                    (w_xor | xori) ? 7 :
                    0;

    
endmodule // mips_decode
