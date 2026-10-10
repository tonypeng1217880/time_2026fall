#======================================================
# TSMC 90 nm Innovus initialization for TIME HW1
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
set verilogFile "./gcd_SYN.v"
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
save_global gcd.globals
win

# Run the complete flow from the Innovus console with:
#   source ./cmd/Lab11_APR.cmd
