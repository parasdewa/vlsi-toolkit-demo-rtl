module and_gate_tb;
    logic a, b;
    logic y;
    integer i;
    string waveform_file;

    and_gate dut (.a(a), .b(b), .y(y));

`ifdef VLSI_WAVEFORM
    initial begin
        if (!$value$plusargs("VLSI_WAVEFORM=%s", waveform_file))
            waveform_file = "waveform.vcd";
        $dumpfile(waveform_file);
        $dumpvars(0, and_gate_tb);
    end
`endif

    initial begin
        for (i = 0; i < 4; i = i + 1) begin
            {a, b} = i[1:0];
            #1;
            if (y !== (a & b))
                $fatal(1, "AND mismatch a=%0b b=%0b y=%0b", a, b, y);
        end
        $display("AND_GATE_TEST_PASSED");
        $finish;
    end
endmodule
