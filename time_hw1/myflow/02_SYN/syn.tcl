#======================================================
# TSMC 90 nm synthesis flow for the square-root design
#======================================================

set DESIGN "gcd"
set CYCLE 5.0
set INPUT_DLY  [expr 0.5 * $CYCLE]
set OUTPUT_DLY [expr 0.5 * $CYCLE]

file mkdir Report
file mkdir Netlist

# Read and elaborate RTL.
analyze -format verilog ../01_RTL/$DESIGN.v
elaborate $DESIGN
current_design $DESIGN
link
uniquify

# TSMC90 timing corners. Library names come from .synopsys_dc.setup.
set_wire_load_mode top
set_operating_conditions -min_library fast -min fast \
                         -max_library slow -max slow

# Clock constraints.
create_clock -name clk -period $CYCLE [get_ports clk]
set_dont_touch_network [get_clocks clk]
set_fix_hold [get_clocks clk]
set_clock_uncertainty 0.1 [get_clocks clk]

# I/O timing constraints. Clock and asynchronous reset are not data inputs.
set DATA_INPUTS [remove_from_collection [all_inputs] [get_ports {clk rst_n}]]
set_input_transition 0.1 $DATA_INPUTS
set_input_delay  -max $INPUT_DLY  -clock clk $DATA_INPUTS
set_input_delay  -min 0           -clock clk $DATA_INPUTS
set_output_delay -max $OUTPUT_DLY -clock clk [all_outputs]
set_output_delay -min 0           -clock clk [all_outputs]
set_false_path -from [get_ports rst_n]

# The TSMC90 kit supplied for TIME contains only the core library.
set_drive 1 $DATA_INPUTS
set_drive 0 [get_ports {clk rst_n}]
set_load [load_of slow/CLKBUFX20/A] [all_outputs]

# Design-rule and optimization constraints.
set_max_fanout 20 [current_design]
set_max_area 0
set case_analysis_with_logic_constants true
set_fix_multiple_port_nets -all -buffer_constants [get_designs *]

check_design > Report/$DESIGN.check
check_timing > Report/$DESIGN.check_timing
compile -map_effort medium

# Reports.
report_design                         > Report/$DESIGN.design
report_resource                       > Report/$DESIGN.resource
report_timing -delay max -max_paths 10 -path full > Report/$DESIGN.timing
report_timing -delay min -max_paths 10 -path full > Report/$DESIGN.hold
report_constraint -all_violators      > Report/$DESIGN.constraint
report_area                           > Report/$DESIGN.area
report_power                          > Report/$DESIGN.power
report_clock                          > Report/$DESIGN.clock
report_port                           > Report/$DESIGN.port

# Verilog-safe names for gate and APR handoff.
set bus_inference_style "%s\[%d\]"
set bus_naming_style "%s\[%d\]"
set hdlout_internal_busses true
change_names -hierarchy -rule verilog
define_name_rules name_rule -allowed "a-z A-Z 0-9 _" -max_length 255 -type cell
define_name_rules name_rule -allowed "a-z A-Z 0-9 _[]" -max_length 255 -type net
define_name_rules name_rule -map {{"\\*cell\\*" "cell"}}
define_name_rules name_rule -case_insensitive
change_names -hierarchy -rules name_rule

set verilogout_higher_designs_first true
set verilogout_show_unconnected_pins true

write -format verilog -hierarchy -output Netlist/${DESIGN}_SYN.v
write -format ddc -hierarchy -output ${DESIGN}_SYN.ddc
write_sdf -version 3.0 -context verilog -load_delay cell \
          -significant_digits 6 Netlist/${DESIGN}_SYN.sdf
write_sdc Netlist/${DESIGN}_SYN.sdc

report_area
report_timing
exit
