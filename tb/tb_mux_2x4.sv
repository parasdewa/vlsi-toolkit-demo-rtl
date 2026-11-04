module tb_mux_2x4;

    reg [3:0]in;
    reg [1:0]s;
    wire out;
    string waveform_file;

    // DUT instantiation
    mux_2x4 MUX_2x4(.in(in), .s(s), .out(out));

    // Initialize the signals
    initial begin
        #0;
        in = 4'b0000;
        s = 2'b00;
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

    // Use the waveform path selected by the VLSI toolkit manifest.
`ifdef VLSI_WAVEFORM
    initial begin
        if (!$value$plusargs("VLSI_WAVEFORM=%s", waveform_file))
            waveform_file = "mux_2x4.vcd";
        $dumpfile(waveform_file);
        $dumpvars(0, tb_mux_2x4);
    end
`endif

endmodule
