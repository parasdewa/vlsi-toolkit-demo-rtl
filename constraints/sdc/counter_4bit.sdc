# Demonstration assumptions for the counter, not platform timing requirements.
create_clock -name counter_clk -period 10.0 [get_ports clk]
set_input_delay -clock counter_clk -max 1.0 [get_ports reset]
set_input_delay -clock counter_clk -min 0.0 [get_ports reset]
set_output_delay -clock counter_clk -max 1.0 [get_ports count]
set_output_delay -clock counter_clk -min 0.0 [get_ports count]
