module tb_mux_2x4;

    reg [3:0]in;
    reg [1:0]s;
    wire out;

    // DUT instantiation
    mux_2x4 MUX_2x4(.in(in), .s(s), .out(s));

    // Initialize the signals
    inital begin
        #0; in = 4'b0000, s = 2'b00;
    end

    // Stimulus
    initial begin
        #5; in = 4'b0110;
        #5;  s = 2'b00;
        #5;  s = 2'b01;
        #5;  s = 2'b10;
        #5;  s = 2'b11;
        #10; $finish;
    end

    // Waveform Dumps
    initial begin
        $dumpfile("tb_mux_2x4.vcd");
        $dumpvars(0, tb_mux_2x4);
    end

endmodule