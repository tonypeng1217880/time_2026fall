###################################################################

# Created by write_sdc on Tue Sep 22 13:50:40 2026

###################################################################
set sdc_version 2.2

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -max slow -max_library slow\
                         -min fast -min_library fast
set_max_area 0
set_max_fanout 20 [current_design]
set_load -pin_load 0.005194 [get_ports {sqr_out[9]}]
set_load -pin_load 0.005194 [get_ports {sqr_out[8]}]
set_load -pin_load 0.005194 [get_ports {sqr_out[7]}]
set_load -pin_load 0.005194 [get_ports {sqr_out[6]}]
set_load -pin_load 0.005194 [get_ports {sqr_out[5]}]
set_load -pin_load 0.005194 [get_ports {sqr_out[4]}]
set_load -pin_load 0.005194 [get_ports {sqr_out[3]}]
set_load -pin_load 0.005194 [get_ports {sqr_out[2]}]
set_load -pin_load 0.005194 [get_ports {sqr_out[1]}]
set_load -pin_load 0.005194 [get_ports {sqr_out[0]}]
set_load -pin_load 0.005194 [get_ports out_valid]
create_clock [get_ports clk]  -period 2  -waveform {0 1}
set_drive 1  [get_ports clk]
set_drive 1  [get_ports rst_n]
set_drive 1  [get_ports {data_in[9]}]
set_drive 1  [get_ports {data_in[8]}]
set_drive 1  [get_ports {data_in[7]}]
set_drive 1  [get_ports {data_in[6]}]
set_drive 1  [get_ports {data_in[5]}]
set_drive 1  [get_ports {data_in[4]}]
set_drive 1  [get_ports {data_in[3]}]
set_drive 1  [get_ports {data_in[2]}]
set_drive 1  [get_ports {data_in[1]}]
set_drive 1  [get_ports {data_in[0]}]
set_drive 1  [get_ports in_valid]
