# Demonstration assumptions for the mux, not platform timing requirements.
create_clock -name mux_ref -period 10.0
set_input_delay -clock mux_ref -max 1.0 [get_ports {in s}]
set_input_delay -clock mux_ref -min 0.0 [get_ports {in s}]
set_output_delay -clock mux_ref -max 1.0 [get_ports out]
set_output_delay -clock mux_ref -min 0.0 [get_ports out]
