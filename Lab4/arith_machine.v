// arith_machine: execute a series of arithmetic instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock  (input)  - the clock signal
// reset  (input)  - set to 1 to set all registers to zero, set to 0 for normal execution.

module arith_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;
    wire [31:0] nextPC;
    wire rd_src, writeenable;
    wire [1:0]  alu_src2;
    wire [2:0]  alu_op;
    wire [31:0] a_data;
    wire [31:0] b_data;
    wire [31:0] w_data;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    wire [5:0] opcode = inst[31:26]; 
    wire [5:0] funct = inst[5:0];

    mips_decode decoder(rd_src, writeenable, alu_src2, alu_op, except, opcode, funct);

    wire [4:0] rs = inst[25:21];
    wire [4:0] rt = inst[20:16];
    wire [4:0] rd = inst[15:11];

    wire [31:0] zero_extend = {16'h0, inst[15:0]};
    wire [31:0] sign_extend = {{16{inst[15]}}, inst[15:0]};

    wire [4:0] w_addr;
    mux2v #(5) mx2(w_addr, rd, rt, rd_src);
    wire [31:0] alu_b;
    mux3v mx3(alu_b, b_data, sign_extend, zero_extend, alu_src2);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (a_data, b_data, rs, rt, w_addr, w_data, writeenable, clock, reset);

    alu32 alu_out(w_data, , , , a_data, alu_b, alu_op);

    /* add other modules */
    alu32 pcplus4(nextPC, , , , PC, 32'h4,`ALU_ADD);
   
endmodule // arith_machine
