`define STATUS_REGISTER 5'd12
`define CAUSE_REGISTER  5'd13
`define EPC_REGISTER    5'd14

module cp0(rd_data, EPC, TakenInterrupt,
           wr_data, regnum, next_pc,
           MTC0, ERET, TimerInterrupt, clock, reset);
    output [31:0] rd_data;
    output [29:0] EPC;
    output        TakenInterrupt;
    input  [31:0] wr_data;
    input   [4:0] regnum;
    input  [29:0] next_pc;
    input         MTC0, ERET, TimerInterrupt, clock, reset;

    // your Verilog for coprocessor 0 goes here

    wire[31:0] decoder_out;
    decoder32 reg_decoder(decoder_out, regnum, MTC0);
    
    wire[31:0] w_user_status;
    register user_status(w_user_status, wr_data, clock, decoder_out[`STATUS_REGISTER], reset);

    wire w_exception_level;
    wire exception_reset = reset || ERET;
    dffe exception_level(w_exception_level, 1'b1, clock, TakenInterrupt, exception_reset);


    wire [29:0] EPC_input;
    wire EPC_enable = decoder_out[`EPC_REGISTER] || TakenInterrupt;
    mux2v #(30) EPC_mux(EPC_input, wr_data[31:2], next_pc, TakenInterrupt);
    register #(30) EPC_register(EPC, EPC_input, clock, EPC_enable, reset);

    assign TakenInterrupt = (TimerInterrupt && w_user_status[15]) && ((~w_exception_level) && w_user_status[0]);

    wire[31:0] status_register = {16'b0, w_user_status[15:8], 6'b0, w_exception_level, w_user_status[0]};
    wire[31:0] cause_register = {16'b0, TimerInterrupt, 15'b0};

    wire[31:0] zero = 32'b0;
    mux32v rd_data_mux(rd_data, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, 
                        zero, status_register, cause_register, {EPC, 2'b0}, zero, zero, zero, zero, 
                        zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, zero, regnum);




endmodule
