module alu1_test;
    // exhaustively test your 1-bit ALU implementation by adapting mux4_tb.v

    // inputs
    reg A = 0;
    always #4 A = !A;
    reg B = 0;
    always #2 B = !B;
    reg carryin = 0;
    always #1 carryin = !carryin;

    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu1.vcd");
        $dumpvars(0, alu1_test);

        // control is initially 0
        // change control evey 8 time units
        # 8 control = 1;
        # 8 control = 2;
        # 8 control = 3;
        # 8 control = 4;
        # 8 control = 5;
        # 8 control = 6;
        # 8 control = 7;
        # 8 $finish;
    end

    wire out, carryout;
    alu1 a1(out, carryout, A, B, carryin, control);

endmodule
