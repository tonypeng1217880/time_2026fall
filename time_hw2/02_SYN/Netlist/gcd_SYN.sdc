###################################################################

# Created by write_sdc on Sun Oct 11 03:38:47 2026

###################################################################
set sdc_version 2.2

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -analysis_type bc_wc -max slow -max_library slow\
                         -min fast -min_library fast
set_wire_load_mode top
set_max_area 0
set_max_fanout 20 [current_design]
set_load -pin_load 0.005194 [get_ports clk_o1]
set_load -pin_load 0.005194 [get_ports clk_o2]
set_load -pin_load 0.005194 [get_ports locked]
set_ideal_network -no_propagate  [get_ports clk_in]
set_ideal_network -no_propagate  [get_ports rst_n]
create_clock [get_ports clk_in]  -period 1  -waveform {0 0.5}
set_false_path   -from [get_ports rst_n]
