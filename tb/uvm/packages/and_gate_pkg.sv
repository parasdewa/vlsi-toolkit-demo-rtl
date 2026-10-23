package and_gate_pkg;
    import uvm_pkg::*;

    `include "agents/and_gate_item.sv"
    `include "agents/and_gate_sequencer.sv"
    `include "sequences/and_gate_sequence.sv"
    `include "agents/and_gate_driver.sv"
    `include "agents/and_gate_monitor.sv"
    `include "agents/and_gate_agent.sv"
    `include "agents/and_gate_scoreboard.sv"
    `include "env/and_gate_env.sv"
    `include "tests/and_gate_test.sv"
endpackage
