// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;

    wire [31:0] a_data;
    wire [31:0] b_data;

    wire [31:0] mem_data;
    wire [31:0] mem;
    wire [31:0] mem_result;

    wire zero;
    wire negative;
      
    wire [5:0] opcode = inst[31:26]; 
    wire [5:0] funct = inst[5:0];
    wire [2:0] alu_op;
    wire writeenable, rd_src;
    wire [1:0] alu_src2;
    wire [1:0] control_type;
    wire mem_read, word_we, byte_we, byte_load;
    wire slt, lui, addm;
    mips_decode decoder(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero); 


    wire [31:0] nextPC;
    
    wire [31:0] j_address = {plus4[31:28], inst[25:0], 2'b0}; 
    
    wire [31:0] plus4;
    alu32 pcplus4(plus4, , , , PC, 32'h4,`ALU_ADD);

    wire [31:0] branch_offset = {{14{inst[15]}}, inst, 2'b0};
    wire [31:0] plus_offset;
    alu32 offset(plus_offset, , , , plus4, branch_offset, `ALU_ADD);

    mux4v #(32) pcmux(nextPC, plus4, plus_offset, j_address, a_data, control_type);

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    instruction_memory im(inst, PC[31:2]);

    wire [4:0] rs = inst[25:21];
    wire [4:0] rt = inst[20:16];
    wire [4:0] rd = inst[15:11];
    wire [4:0] w_addr;
    mux2v #(5) wmux(w_addr, rd, rt, rd_src);

    wire [31:0] alu_b;
    wire [31:0] zero_extend = {16'h0, inst[15:0]};
    wire [31:0] sign_extend = {{16{inst[15]}}, inst[15:0]};
    mux3v mx3(alu_b, b_data, sign_extend, zero_extend, alu_src2);

    wire [31:0] alu_a;
    mux2v #(32) addm_mux(alu_a, a_data, mem_data, addm);

    wire [31:0] w_data;
    wire [31:0] lui_input = {inst[15:0], 16'b0};
    mux2v #(32) lui_mux(w_data, mem, lui_input, lui);


    // DO NOT comment out or rename this module
    // or the test bench will break
    regfile rf (a_data, b_data, rs, rt, w_addr, w_data, writeenable, clock, reset);

    wire [31:0] alu_out;
    alu32 main_alu(alu_out, , zero, negative, alu_a, alu_b, alu_op);


    wire [31:0] mem_address;
    mux2v #(32) mem_address_mux(mem_address, alu_out, a_data, addm);
    data_mem dm(mem_data, mem_address, b_data, word_we, byte_we, clock, reset);

    wire [7:0] byte_;
    mux4v #(8) byte_mux(byte_, mem_data[7:0], mem_data[15:8], mem_data[23:16], 
                        mem_data[31:24], alu_out[1:0]);
    wire [31:0] byte_data = {24'b0, byte_};
    mux2v #(32) load_byte(mem_result, mem_data, byte_data, byte_load);

    wire [31:0] slt_input = {31'b0, negative};
    wire [31:0] slt_output;
    mux2v #(32) slt_mux(slt_output, alu_out, slt_input, slt); 

    mux2v #(32) mem_mux(mem, slt_output, mem_result, mem_read);

    /* add other modules */

endmodule // full_machine