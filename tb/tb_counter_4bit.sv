`timescale 1ns / 1ps

module tb_counter_4bit();
    // Testbench signals
    reg clk;
    reg reset;
    wire [3:0] count;

    // Instantiate the Unit Under Test (UUT)
    counter_4bit uut (
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    // Clock generation: 10ns period (5ns high, 5ns low)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus block
    initial begin
        // Initialize inputs
        reset = 1;
        #15;

        // Release reset
        reset = 0;
        #100;

        // Assert reset again
        reset = 1;
        #15;
        reset = 0;
        #50;

        // Finish simulation
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time = %0t ns | Reset = %b | Count = %d (4'b%b)",
                 $time, reset, count, count);
    end

        // Waveform Dumps
    initial begin
        $dumpfile("tb_counter_4bit.vcd");
        $dumpvars(0, tb_counter_4bit);
    end

endmodule
