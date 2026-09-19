set ref_cycle  2
set DESIGN_TOP gcd
#/*--------------------------------------------------------------*/
#/*----------------------- 1.Read files -------------------------*/
#/*--------------------------------------------------------------*/
#read_file -format verilog ../1.RTL_simulation/gcd.v
analyze -format verilog {../1.RTL_simulation/gcd.v}

# Top module name
#current_design [get_designs gcd]
elaborate $DESIGN_TOP
set_operating_conditions -min_library fast -min fast \
                        -max_library slow -max slow
#/*--------------------------------------------------------------*/
#/*--------------- 2. Set design constraints --------------------*/ 
#/*--------------------------------------------------------------*/
create_clock -period $ref_cycle [get_ports clk]
set_dont_touch_network [get_clocks clk]
set_fix_hold clk
#set_dont_touch_network [get_ports rst_n]

set_drive 1 [all_inputs] 
set_load [load_of slow/CLKBUFX20/A] [all_outputs]
#/*--------------------------------------------------------------*/
#/*----------------- 3.Check and Link Design --------------------*/ 
#/*--------------------------------------------------------------*/
link 
check_design
uniquify
set_fix_multiple_port_nets -all -buffer_constants  
#/*--------------------------------------------------------------*/
#/*------------------------ 4.Compile ---------------------------*/ 
#/*--------------------------------------------------------------*/

# Setting DRC Constraint
set_max_fanout 20.0 $DESIGN_TOP

# Area Constraint
set_max_area   0

# before synthesis settings
set case_analysis_with_logic_constants true
set_fix_multiple_port_nets -all -buffer_constants

set_clock_gating_style -max_fanout 10

compile  -map_effort medium 

# remove dummy ports
remove_unconnected_ports [get_cells -hierarchical *]
remove_unconnected_ports [get_cells -hierarchical *] -blast_buses

check_design 

set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true
change_names -hierarchy -rule verilog
define_name_rules name_rule -allowed {a-z A-Z 0-9 _} -max_length 255 -type cell
define_name_rules name_rule -allowed {a-z A-Z 0-9 _[]} -max_length 255 -type net
define_name_rules name_rule -map {{"\*cell\*" "cell"}}
define_name_rules name_rule -map {{"*-return", "myreturn"}}
define_name_rules name_rule -case_insensitive
change_names -hierarchy -rules name_rule

set verilogout_show_unconnected_pins true  

#/*--------------------------------------------------------------*/ 
#/*----------------------- 5.Write out files --------------------*/ 
#/*--------------------------------------------------------------*/

report_area > ./gcd_syn.report
report_timing -path full -delay max >> ./gcd_syn.report
report_power >> ./gcd_syn.report

write -format verilog -hierarchy -output ./gcd_syn.v
write -format verilog -hierarchy -output ../3.Post_layout_Simulation/APR/design_data/gcd_syn.v

write_sdf -version 2.1 -context verilog -load_delay cell ./gcd_syn.sdf 
write_sdc ../3.Post_layout_Simulation/APR/design_data/gcd_syn.sdc 

exit
