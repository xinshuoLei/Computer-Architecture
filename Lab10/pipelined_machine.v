module pipelined_machine(clk, reset);
    input        clk, reset;

    wire [31:0]  PC;
    wire [31:2]  next_PC, PC_plus4_IF, PC_plus4_DE, PC_target;
    wire [31:0]  inst_IF, inst_DE;

    wire [31:0]  imm = {{ 16{inst_DE[15]} }, inst_DE[15:0] };  // sign-extended immediate
    wire [4:0]   rs = inst_DE[25:21];
    wire [4:0]   rt = inst_DE[20:16];
    wire [4:0]   rd = inst_DE[15:11];
    wire [5:0]   opcode = inst_DE[31:26];
    wire [5:0]   funct = inst_DE[5:0];

    wire [4:0]   wr_regnum_MW, wr_regnum_DE;
    wire [2:0]   ALUOp;

    wire         RegWrite_DE, BEQ, ALUSrc, MemRead_DE, MemWrite_DE, MemToReg_DE;
    wire         RegWrite_MW, MemRead_MW, MemWrite_MW, MemToReg_MW;
    wire         PCSrc, zero;
    wire [31:0]  rd1_data, rd2_data_DE, rd2_data_MW, B_data, alu_out_data_DE, alu_out_data_MW, load_data, wr_data;


    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(30, 30'h100000) PC_reg(PC[31:2], next_PC[31:2], clk, /* enable */1'b1, reset);

    assign PC[1:0] = 2'b0;  // bottom bits hard coded to 00
    adder30 next_PC_adder(PC_plus4_IF, PC[31:2], 30'h1);

    register #(30) pc_plus4(PC_plus4_DE, PC_plus4_IF, clk, 1'b1, reset);

    adder30 target_PC_adder(PC_target, PC_plus4_DE, imm[29:0]);
    mux2v #(30) branch_mux(next_PC, PC_plus4_IF, PC_target, PCSrc);
    assign PCSrc = BEQ & zero;

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory imem(inst_IF, PC[31:2]);
    register inst(inst_DE, inst_IF, clk, 1'b1, reset);

    mips_decode decode(ALUOp, RegWrite_DE, BEQ, ALUSrc, MemRead_DE, MemWrite_DE, MemToReg_DE, RegDst,
                      opcode, funct);

    register #(1) regwrite(RegWrite_MW, RegWrite_DE, clk, 1'b1, reset);
    register #(1) memRead(MemRead_MW, MemRead_DE, clk, 1'b1, reset);
    register #(1) memWrite(MemWrite_MW, MemWrite_DE, clk, 1'b1, reset);
    register #(1) memToReg(MemToReg_MW, MemToReg_DE, clk, 1'b1, reset);
    // register #(1) regDst(RegDst_MW, RegDst_DE, clk, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (rd1_data, rd2_data_DE,
               rs, rt, wr_regnum_MW, wr_data,
               RegWrite_MW, clk, reset);

    mux2v #(32) imm_mux(B_data, rd2_data_DE, imm, ALUSrc);

    register rd2_data(rd2_data_MW, rd2_data_DE, clk, 1'b1, reset);

    alu32 alu(alu_out_data_DE, zero, ALUOp, rd1_data, B_data);

    // DO NOT comment out or rename this module
    // or the test bench will break
    data_mem data_memory(load_data, alu_out_data_MW, rd2_data_MW, MemRead_MW, MemWrite_MW, clk, reset);

    register alu_data(alu_out_data_MW, alu_out_data_DE, clk, 1'b1, reset);

    mux2v #(32) wb_mux(wr_data, alu_out_data_MW, load_data, MemToReg_MW);
    mux2v #(5) rd_mux(wr_regnum_DE, rt, rd, RegDst);

    register #(5) wr_rehnum(wr_regnum_MW, wr_regnum_DE, clk, 1'b1, reset);

endmodule // pipelined_machine
