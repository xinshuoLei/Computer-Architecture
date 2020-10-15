module timer(TimerInterrupt, cycle, TimerAddress,
             data, address, MemRead, MemWrite, clock, reset);
    output        TimerInterrupt;
    output [31:0] cycle;
    output        TimerAddress;
    input  [31:0] data, address;
    input         MemRead, MemWrite, clock, reset;

    // complete the timer circuit here

    // HINT: make your interrupt cycle register reset to 32'hffffffff
    //       (using the reset_value parameter)
    //       to prevent an interrupt being raised the very first cycle

    wire TimerWrite = MemWrite && (address == 32'hffff001c);
    wire acknowledge = MemWrite && (address == 32'hffff006c);
    wire TimerRead = MemRead && (address == 32'hffff001c);

    wire [31:0] cycle_input, cycle_output;
    alu32 cycle_alu(cycle_input, , , `ALU_ADD, cycle_output, 32'b1);
    register cycle_counter(cycle_output, cycle_input, clock, 1'b1, reset);

    wire [31:0] interrupt_cycle_output;
    register #(32, 32'hffffffff) interrupt_cycle(interrupt_cycle_output, data, clock, TimerWrite, reset);
    
    wire line_reset = acknowledge || reset;
    wire line_enable = (interrupt_cycle_output == cycle_output);
    register #(1) interrupt_line(TimerInterrupt, 1'b1, clock, line_enable, line_reset);

    tristate read_cycle(cycle, cycle_output, TimerRead);

    assign TimerAddress = (address == 32'hffff001c) || (address == 32'hffff006c);



endmodule
