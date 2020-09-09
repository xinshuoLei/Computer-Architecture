module test;
    reg       clk = 0, enable = 0, reset = 1;  // start by reseting the register file

    /* Make a regular pulsing clock with a 10 time unit period. */
    always #5 clk = !clk;

    reg [31:0] d;

    wire [31:0] q;
    initial begin
        $dumpfile("register.vcd");
        $dumpvars(0, test);
        # 10  reset = 0;      // stop reseting the register 

        # 10
          // write 88 to the register
          enable = 1;
          d = 88;

        # 10
          // try writing to the register when its disabled
          enable = 0;
          d = 89;

        // Add your own testcases here!

        # 10
          // try writing to the register when its disabled
          enable = 0;
          d = 10;

        # 10
          // try writing 20 to the register
          enable = 1;
          d = 20;

        # 10
          // try writing to the register when its disabled
          enable = 0;
          d = 15;

        # 10
          // reset the register
          reset = 1;

        # 10
          // try writing 28 to the register
          enable = 1;
          d = 28;
          reset = 0;

        # 17
          // reset the register when not on a positive edge
          reset = 1;

        # 10 $finish;
    end
    
    initial begin
    end

    register reg1(q, d, clk, enable, reset);
   
endmodule // test
