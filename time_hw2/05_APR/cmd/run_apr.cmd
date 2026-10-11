#======================================================
# TSMC 90 nm Innovus initialization for Homework #2 two-phase DLL
#======================================================

set ProcessRoot "/usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/SOCE"
set NUM_OF_CPU 8
set mmmcFile "./mmmc.view"
set lefFile "
    $ProcessRoot/lef/tsmc090lk_9lm_2thick_tech_cic.lef
    $ProcessRoot/lef/tsmc090nvt_macros.lef
    $ProcessRoot/lef/antenna_9lm.lef
"

set topDesign "gcd"
# Resolve the synthesis netlist from this script's own location.  This does
# not depend on a manually created gcd_SYN.v symlink or on Innovus' cwd.
set scriptDir [file dirname [file normalize [info script]]]
set verilogFile [file normalize \
    [file join $scriptDir .. .. 02_SYN Netlist gcd_SYN.v]]
if {![file readable $verilogFile]} {
    error "Synthesis netlist not found: $verilogFile. Run 02_SYN first."
}
set ioFile "./gcd.io"
set pwrNet "VDD"
set gndNet "VSS"

file mkdir DBS
file mkdir StreamOut
file mkdir timingReports
file mkdir log

set init_design_uniquify 1
setDesignMode -process 90

set init_mmmc_file $mmmcFile
set init_lef_file $lefFile
set init_verilog $verilogFile
set init_top_cell $topDesign
set init_io_file $ioFile
set init_pwr_net $pwrNet
set init_gnd_net $gndNet

init_design -setup {func_mode_max} -hold {func_mode_min}

# Fail immediately if an old I/O file or wrong synthesis netlist was linked.
foreach port_name {clk_in rst_n clk_o1 clk_o2 locked} {
    set port_obj [get_ports $port_name]
    if {[sizeof_collection $port_obj] != 1} {
        error "Expected top-level port $port_name in gcd_SYN.v"
    }
}
puts "APR preflight passed: gcd ports and 1 GHz MMMC setup are loaded"

save_global gcd.globals
win

# Run the complete flow from the Innovus console with:
#   source ./cmd/Lab11_APR.cmd
