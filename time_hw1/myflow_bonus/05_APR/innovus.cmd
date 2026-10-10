#######################################################
#                                                     
#  Innovus Command Logging File                     
#  Created on Wed Sep 23 12:47:55 2026                
#                                                     
#######################################################

#@(#)CDS: Innovus v20.10-p004_1 (64bit) 05/07/2020 20:02 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: NanoRoute 20.10-p004_1 NR200413-0234/20_10-UB (database version 18.20.505) {superthreading v1.69}
#@(#)CDS: AAE 20.10-p005 (64bit) 05/07/2020 (Linux 2.6.32-431.11.2.el6.x86_64)
#@(#)CDS: CTE 20.10-p005_1 () Apr 14 2020 09:14:28 ( )
#@(#)CDS: SYNTECH 20.10-b004_1 () Mar 12 2020 22:18:21 ( )
#@(#)CDS: CPE v20.10-p006
#@(#)CDS: IQuantus/TQuantus 19.1.3-s155 (64bit) Sun Nov 3 18:26:52 PST 2019 (Linux 2.6.32-431.11.2.el6.x86_64)

set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
win
set init_design_uniquify 1
setDesignMode -process 90
suppressMessage TECHLIB 1318
suppressMessage ENCEXT-2799
floorPlan -r 1 0.70 5 5 5 5
set init_design_uniquify 1
setDesignMode -process 90
set init_mmmc_file ./mmmc.view
set init_lef_file {
    /usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/SOCE/lef/tsmc090lk_9lm_2thick_tech_cic.lef
    /usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/SOCE/lef/tsmc090nvt_macros.lef
    /usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/SOCE/lef/antenna_9lm.lef
}
set init_verilog ./gcd_SYN.v
set init_top_cell gcd
set init_io_file ./gcd.io
set init_pwr_net VDD
set init_gnd_net VSS
init_design -setup func_mode_max -hold func_mode_min
save_global gcd.globals
win
set init_design_uniquify 1
setDesignMode -process 90
suppressMessage TECHLIB 1318
suppressMessage ENCEXT-2799
floorPlan -r 1 0.70 5 5 5 5
saveDesign ./DBS/gcd_floorplan.inn
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -module {}
globalNetConnect VDD -type tiehi -pin VDD -inst * -module {}
globalNetConnect VSS -type pgpin -pin VSS -inst * -module {}
globalNetConnect VSS -type tielo -pin VSS -inst * -module {}
addRing -skip_via_on_wire_shape Noshape -skip_via_on_pin {} -center 1 -stacked_via_top_layer M5 -stacked_via_bottom_layer M1 -type core_rings -jog_distance 0.42 -threshold 0.1 -nets {VDD VSS} -follow core -layer {bottom M5 top M5 right M4 left M4} -width 2 -spacing 0.5 -offset 0.1 -extend_corner {tl lt tr bl br rb lb rt}
sroute -connect corePin -layerChangeRange {M1 M5} -blockPinTarget nearestTarget -corePinTarget firstAfterRowEnd -allowJogging 1 -crossoverViaLayerRange {M1 M9} -nets {VDD VSS} -allowLayerChange 1 -targetViaLayerRange {M1 M9}
saveDesign ./DBS/gcd_powerplan.inn
setPlaceMode -prerouteAsObs {2 3}
setPlaceMode -fp false
place_design -noPrePlaceOpt
addTieHiLo -cell {TIELO TIEHI} -prefix LTIE
fit
timeDesign -preCTS -pathReports -drvReports -slackReports -numPaths 50 -prefix gcd_preCTS -outDir timingReports
setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -preCTS
saveDesign ./DBS/gcd_placement.inn
update_constraint_mode -name func_mode -sdc_files ./gcd_SYN.sdc
set_ccopt_property buffer_cells CLKBUF*
set_ccopt_property use_inverters true
set_ccopt_property update_io_latency false
create_ccopt_clock_tree_spec -file gcd.CCOPT.spec -keep_all_sdc_clocks
get_ccopt_clock_trees
ccopt_check_and_flatten_ilms_no_restore
set_ccopt_property cts_is_sdc_clock_root -pin clk true
create_ccopt_clock_tree -name clk -source clk -no_skew_group
set_ccopt_property target_max_trans_sdc -delay_corner delay_corner_max -early -clock_tree clk 0.100
set_ccopt_property target_max_trans_sdc -delay_corner delay_corner_max -late -clock_tree clk 0.100
set_ccopt_property clock_period -pin clk 5
create_ccopt_skew_group -name clk/func_mode -sources clk -auto_sinks
set_ccopt_property include_source_latency -skew_group clk/func_mode true
set_ccopt_property extracted_from_clock_name -skew_group clk/func_mode clk
set_ccopt_property extracted_from_constraint_mode_name -skew_group clk/func_mode func_mode
set_ccopt_property extracted_from_delay_corners -skew_group clk/func_mode {delay_corner_max delay_corner_min}
check_ccopt_clock_tree_convergence
get_ccopt_property auto_design_state_for_ilms
ccopt_design
