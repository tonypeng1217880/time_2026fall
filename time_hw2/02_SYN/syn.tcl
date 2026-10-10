#======================================================
# TSMC 90 nm synthesis flow for the Homework #2 two-phase DLL
#======================================================

# Keep the copied flow's top/file/netlist name unchanged for now.
# The module inside ../01_RTL/gcd.v can implement the DLL while the
# filename and downstream gcd_SYN.* handoff names remain unchanged.
set DESIGN "gcd"
set CYCLE 1.0

# Keep the RTL input as a list so additional RTL submodules can be added
# later without changing the synthesis flow structure.
set RTL_FILES [list \
    ../01_RTL/$DESIGN.v \
]

file mkdir Report
file mkdir Netlist

# Read and elaborate RTL.
# If PD/TDL/controller are split into separate files later, append them to
# RTL_FILES. They may also remain in the same gcd.v file.
analyze -format verilog $RTL_FILES
elaborate $DESIGN
current_design $DESIGN
link
uniquify

# TSMC90 timing corners. Library names come from .synopsys_dc.setup.
set_wire_load_mode top
set_operating_conditions -min_library fast -min fast \
                         -max_library slow -max slow

# Clock constraints.
# Homework #2 uses a 1 GHz input clock: T = 1 ns.
create_clock -name clk_in -period $CYCLE [get_ports clk_in]
set_ideal_network [get_ports clk_in]
set_dont_touch_network [get_clocks clk_in]
set_fix_hold [get_clocks clk_in]
set_ideal_network [get_ports rst_n]
set_dont_touch_network [get_ports rst_n]

# The reset is asynchronous. The DLL outputs are generated clocks, not
# ordinary data outputs, so no input/output data-delay constraints are
# imposed on them at this stage.
set_false_path -from [get_ports rst_n]

# Keep this collection for any future non-clock/non-reset control inputs.
set DATA_INPUTS [remove_from_collection [all_inputs] [get_ports {clk_in rst_n}]]
if {[sizeof_collection $DATA_INPUTS] > 0} {
    set_input_transition 0.1 $DATA_INPUTS
    set_input_delay -max 0.5 -clock clk_in $DATA_INPUTS
    set_input_delay -min 0.0 -clock clk_in $DATA_INPUTS
}

# The TSMC90 kit supplied for TIME contains only the core library.
set_drive 1 $DATA_INPUTS
set_drive 0 [get_ports {clk_in rst_n}]
set_load [load_of slow/CLKBUFX20/A] [all_outputs]

# Do not let DC rewrite explicitly instantiated standard-cell structures.
# Fill these patterns only after the RTL hierarchy and instance names are
# fixed. The intended hierarchy is typically u_pd/u_tdl/u_ctl.
#
# Example skeleton:
# set_dont_touch [get_cells {u_pd/*}] true
# set_dont_touch [get_nets  {u_pd/*}] true
# set_dont_touch [get_cells {u_tdl/*}] true
# set_dont_touch [get_nets  {u_tdl/*}] true
# set_dont_touch [get_cells {u_ctl}] false
#
# The TA-provided scripts use a global version when the cell list is known:
# set_dont_touch [get_cells {*}] true
# set_dont_touch [get_nets  {*}] true
# followed by explicit exceptions for logic that DC may still optimize.

# The hierarchy is now fixed by gcd.v. Preserve the hand-built PD feedback
# structures, dummy loads and delay lines; leave controllers synthesizable.
foreach block {u_pd1 u_pd2} {
    set block_cells [get_cells $block]
    if {[sizeof_collection $block_cells] != 1} {
        error "Expected one preserved DLL block: $block"
    }
    set_dont_touch $block_cells true
    set_dont_touch [get_cells ${block}/*] true
    set_dont_touch [get_nets ${block}/*] true
}
# TDL also contains a behavioral decoder/mux. Do NOT mark the whole TDL
# hierarchy dont_touch before mapping: that would also freeze unmapped logic.
# Preserve only the explicitly instantiated delay cells and their outputs.
foreach block {u_tdl1 u_tdl2} {
    set delay_cells [get_cells [list ${block}/u_clkbuf* ${block}/u_tbuf*]]
    if {[sizeof_collection $delay_cells] != 64} {
        error "Expected 32 CLKBUFs and 32 TBUFs in $block"
    }
    set_dont_touch $delay_cells true
    set_dont_touch [get_nets [list ${block}/coarse_node* \
                                  ${block}/coarse_mid* \
                                  ${block}/fine1_node* \
                                  ${block}/fine2_node*]] true
}

# Design-rule and optimization constraints.
set_max_fanout 20 [current_design]
set_max_area 0
set_structure false
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
