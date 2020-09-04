//implement a test bench for your 32-bit ALU
module alu32_test;
    reg [31:0] A = 0, B = 0;
    reg [2:0] control = 0;

    initial begin
        $dumpfile("alu32.vcd");
        $dumpvars(0, alu32_test);


        // normal tests

        // arithmetic
             A = 8;  B = 4;  control = `ALU_ADD;      // try adding 8 and 4
        # 10 A = 3;  B = 5;  control = `ALU_ADD;      // try adding 3 and 5
        # 10 A = 15; B = 16; control = `ALU_ADD;      // try adding 15 and 16
        # 10 A = 8;  B = 4;  control = `ALU_SUB;      // try subtracting 4 from 8
        # 10 A = 2;  B = 5;  control = `ALU_SUB;      // try subtracting 5 from 2
        # 10 A = 15; B = 16; control = `ALU_SUB;      // try subtracting 16 from 15

        // logical
        # 10 A = 0;        B = 1;         control = `ALU_AND;   // try and 0 with 1
        # 10 A = 1;        B = 1;         control = `ALU_AND;   // try and 1 with 1  
        # 10 A = 4'b0001;  B = 4'b1111;   control = `ALU_AND;   // try and 0001 with 1111
        # 10 A = 0;        B = 1;         control = `ALU_OR;    // try or 0 with 1
        # 10 A = 0;        B = 0;         control = `ALU_OR;    // try or 0 with 0
        # 10 A = 4'b0100;  B = 4'b1010;   control = `ALU_OR;    // try or 0100 with 1010
        # 10 A = 0;        B = 1;         control = `ALU_NOR;   // try nor 0 with 1
        # 10 A = 0;        B = 0;         control = `ALU_NOR;   // try nor 0 with 0
        # 10 A = 4'b0100;  B = 4'b1010;   control = `ALU_NOR;   // try nor 0100 with 1010 
        # 10 A = 0;        B = 1;         control = `ALU_XOR;   // try xor 0 with 1
        # 10 A = 1;        B = 1;         control = `ALU_XOR;   // try xor 1 with 1
        # 10 A = 4'b0101;  B = 4'b0110;   control = `ALU_XOR;   // try xor 0101 with 0110

        // corner cases

        // arithmetic
        # 10 A = 32'h40000000;   B = 32'h40000000;   control = `ALU_ADD;     // adding two large positive number. overflow
        # 10 A = 32'h40000000;   B = 32'h3fffffff;   control = `ALU_ADD;     // adding two large positive number. no overflow
        # 10 A = 32'h80000000;   B = 32'h80000000;   control = `ALU_ADD;     // adding two negative number of larger magnitude. overflow
        # 10 A = 32'hc0000000;   B = 32'hc0000000;   control = `ALU_ADD;     // adding two negative number of larger magnitude. no overflow
        # 10 A = 16;             B = 16;             control = `ALU_SUB;     // try subtracting 16 from 16
        # 10 A = 32'hc0000000;   B = 32'hc0000000;   control = `ALU_SUB;     // try subtracting 0xc0000000 from itself
        # 10 A = 36;             B = 32'h7ffffff0;   control = `ALU_SUB;     // subtracting a large positive number from a small positive number. no overflow
        # 10 A = 10;             B = 32'h7fffffff;   control = `ALU_SUB;     // same with last line
        # 10 A = 32'h40000000;   B = 32'hc0000000;   control = `ALU_SUB;     // subtracting a negative number of large magnitude from a large positive number. overflow
        # 10 A = 32'h4fffffff;   B = 32'hc0000000;   control = `ALU_SUB;     // same with last line
        # 10 A = 32'h3fffffff;   B = 32'hc0000000;   control = `ALU_SUB;     // same with last line, but no overflow
   
        # 10 $finish;
    end

    wire [31:0] out;
    wire overflow, zero, negative;
    alu32 a(out, overflow, zero, negative, A, B, control);  

    initial begin
        $display("out, overflow, zero, negative, A, B, control");
        $monitor("%x %d %d %d %x %x %d (at time %t)", out, overflow, zero, negative, A, B, control, $time);
    end
endmodule // alu32_test
