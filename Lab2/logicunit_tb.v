module logicunit_test;
    // exhaustively test your logic unit implementation by adapting mux4_tb.v

    // inputs
    reg A = 0;
    reg B = 0;
    reg [1:0] control = 0;

    initial begin
        $dumpfile("logicunit.vcd");
        $dumpvars(0, logicunit_test);

        // control is initially 0
        # 5 A = 0; B = 1; control = 0;
        # 5 A = 1; B = 0; control = 0;
        # 5 A = 1; B = 1; control = 0;
        # 5 A = 0; B = 0; control = 1;
        # 5 A = 0; B = 1; control = 1;
        # 5 A = 1; B = 0; control = 1;
        # 5 A = 1; B = 1; control = 1;
        # 5 A = 0; B = 0; control = 2;
        # 5 A = 0; B = 1; control = 2;
        # 5 A = 1; B = 0; control = 2;
        # 5 A = 1; B = 1; control = 2;
        # 5 A = 0; B = 0; control = 3;
        # 5 A = 0; B = 1; control = 3;
        # 5 A = 1; B = 0; control = 3;
        # 5 A = 1; B = 1; control = 3;
        # 5 $finish;
    end

    wire out;
    logicunit l1(out, A, B, control);

    
endmodule // logicunit_test
