// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
// 
// included instructions:
// add,sub, and, or, nor, xor, addi, andi, ori, xori
// bne, beq, j, jr, lui, slt, lw, lbu, sw, sb, addm

module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output [1:0] alu_src2;
    output       writeenable, rd_src, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire r = (opcode == `OP_OTHER0);

    wire add_ = r & (funct == `OP0_ADD);
    wire sub_ = r & (funct == `OP0_SUB);
    wire and_ = r & (funct == `OP0_AND);
    wire or_  = r & (funct == `OP0_OR);
    wire nor_ = r & (funct == `OP0_NOR);
    wire xor_ = r & (funct == `OP0_XOR);

    wire addi = (opcode == `OP_ADDI);
    wire andi = (opcode == `OP_ANDI);
    wire ori  = (opcode == `OP_ORI);
    wire xori = (opcode == `OP_XORI);

    wire bne  = (opcode == `OP_BNE);
    wire beq  = (opcode == `OP_BEQ);
    wire j    = (opcode == `OP_J);
    wire lui_ = (opcode == `OP_LUI);
    wire lw   = (opcode == `OP_LW); 
    wire lbu  = (opcode == `OP_LBU);
    wire sw   = (opcode == `OP_SW);
    wire sb   = (opcode == `OP_SB);
    
    wire jr    = r & (funct == `OP0_JR);
    wire slt_  = r & (funct == `OP0_SLT);
    wire addm_ = r & (funct == `OP0_ADDM);


    assign alu_op = (addi | add_ | lw | lbu | sw | sb | addm_) ? 2 :
                    (sub_ | beq | bne | slt_)                  ? 3 :
                    (andi | and_)                              ? 4 :
                    (ori  | or_)                               ? 5 :
                     nor_                                      ? 6:
                    (xor_ | xori)                              ? 7 :
                    0;

    assign writeenable = add_ | sub_ | and_ | or_ | nor_ | xor_ | addi 
                        | andi | ori | xori | lui_ | lw | lbu | slt_ | addm_;

    assign rd_src      = ~r;

    assign alu_src2 = (r | bne | beq | slt_ | addm_) ? 0 :
                      (addi | lw | lbu | sw | sb)    ? 1 :
                      2;
    
    assign except = ~(add_ | sub_ | and_ | or_ | nor_ | xor_ | addi | andi 
                      | ori | xori | bne | beq | j | lui_ | lw | lbu | sw 
                      | sb | jr | slt_ | addm_);

    assign control_type  = ( (bne & ~zero) | (beq & zero) ) ? 1 :
                            j          ? 2 :
                            jr         ? 3 :
                            0; 


    assign mem_read    = lw | lbu;
    assign word_we     = sw;
    assign byte_we     = sb;
    assign byte_load   = lbu;
    
    assign slt         = slt_;
    assign lui         = lui_;
    assign addm        = addm_;






endmodule // mips_decode
