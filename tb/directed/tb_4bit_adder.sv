`timescale 1ns / 1ps

module tb_ripple_carry_adder_4bit;

    // Inputs are declared as registers
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;

    // Outputs are declared as wires
    wire [3:0] Sum;
    wire Cout;
    string waveform_file;

    // Instantiate the Unit Under Test (UUT)
    ripple_carry_adder_4bit uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

`ifdef VLSI_WAVEFORM
    initial begin
        if (!$value$plusargs("VLSI_WAVEFORM=%s", waveform_file))
            waveform_file = "adder_4bit.vcd";
        $dumpfile(waveform_file);
        $dumpvars(0, tb_ripple_carry_adder_4bit);
    end
`endif

    initial begin
        // Monitor the changes in variables
        $monitor("Time=%0t | A=%b (%d) + B=%b (%d), Cin=%b | Sum=%b (%d), Cout=%b",
                 $time, A, A, B, B, Cin, Sum, Sum, Cout);

        // Test Case 1: Simple binary addition without carry-in
        A = 4'b0010; B = 4'b0100; Cin = 1'b0; #10; // Expected Sum=0110, Cout=0

        // Test Case 2: Addition with a carry-in
        A = 4'b0101; B = 4'b0011; Cin = 1'b1; #10; // Expected Sum=1001, Cout=0

        // Test Case 3: Generating a final carry-out bit
        A = 4'b1111; B = 4'b0001; Cin = 1'b0; #10; // Expected Sum=0000, Cout=1

        // Test Case 4: Max values addition
        A = 4'b1111; B = 4'b1111; Cin = 1'b1; #10; // Expected Sum=1111, Cout=1

        $finish;
    end

endmodule
