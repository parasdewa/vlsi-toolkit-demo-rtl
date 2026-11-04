module and_gate_tb_top;
    import uvm_pkg::*;
    import and_gate_pkg::*;

    and_gate_if vif();

    and_gate dut (
        .a(vif.a),
        .b(vif.b),
        .y(vif.y)
    );
    string waveform_file;

    initial begin
        vif.a = 0;
        vif.b = 0;
        vif.txn_valid = 0;

        uvm_config_db#(virtual and_gate_if)::set(
            null, "uvm_test_top", "vif", vif);

        run_test("and_gate_test");
    end

`ifdef VLSI_WAVEFORM
    initial begin
        if (!$value$plusargs("VLSI_WAVEFORM=%s", waveform_file))
            waveform_file = "and_gate_uvm.vcd";
        $dumpfile(waveform_file);
        $dumpvars(0, and_gate_tb_top);
    end
`endif
endmodule
