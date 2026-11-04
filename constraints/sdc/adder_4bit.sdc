# Example input/output budgets for the combinational adder, not signoff limits.
create_clock -name adder_ref -period 10.0
set_input_delay -clock adder_ref -max 1.0 [get_ports {A B Cin}]
set_input_delay -clock adder_ref -min 0.0 [get_ports {A B Cin}]
set_output_delay -clock adder_ref -max 1.0 [get_ports {Sum Cout}]
set_output_delay -clock adder_ref -min 0.0 [get_ports {Sum Cout}]
