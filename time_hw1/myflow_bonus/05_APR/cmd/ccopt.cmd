update_constraint_mode -name func_mode -sdc_files ./gcd_SYN.sdc

set_ccopt_property buffer_cells {CLKBUF*}
set_ccopt_property use_inverters true
set_ccopt_property update_io_latency false

create_ccopt_clock_tree_spec -file gcd.CCOPT.spec -keep_all_sdc_clocks
source gcd.CCOPT.spec
ccopt_design

saveDesign ./DBS/gcd_CTS.inn
