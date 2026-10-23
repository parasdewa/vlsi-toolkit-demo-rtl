# Demonstration assumptions for a combinational block, not platform timing.
# A virtual 10 ns reference period leaves a 1 ns input and output budget.
create_clock -name and_gate_ref -period 10.0
set_input_delay -clock and_gate_ref -max 1.0 [get_ports {a b}]
set_input_delay -clock and_gate_ref -min 0.0 [get_ports {a b}]
set_output_delay -clock and_gate_ref -max 1.0 [get_ports y]
set_output_delay -clock and_gate_ref -min 0.0 [get_ports y]
