# The APR-specific SDC is loaded once by mmmc.view during init_design.
# Expand the TSMC90 clock-buffer wildcard now so an invalid library setup
# fails here with a clear message instead of producing an empty sizing table.
set CTS_BUFFER_CELLS [dbGet head.libCells.name CLKBUF*]
if {$CTS_BUFFER_CELLS eq "0x0" || [llength $CTS_BUFFER_CELLS] == 0} {
    error "No TSMC90 CLKBUF* cells are available for CTS"
}
puts "CTS buffer cells: $CTS_BUFFER_CELLS"

set_ccopt_property buffer_cells $CTS_BUFFER_CELLS
set_ccopt_property use_inverters true
set_ccopt_property update_io_latency false

create_ccopt_clock_tree_spec -file gcd.CCOPT.spec -keep_all_sdc_clocks
source gcd.CCOPT.spec

# Use a 10%-of-period CTS slew target instead of the 0.1 ns value that was
# below the TSMC90 clock-cell limit.  Set it after loading the generated spec.
set_ccopt_property target_max_trans 0.5

ccopt_design -cts

saveDesign ./DBS/gcd_CTS.inn
