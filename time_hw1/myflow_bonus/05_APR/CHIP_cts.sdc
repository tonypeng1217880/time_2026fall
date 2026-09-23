# TSMC90 APR timing constraints for the TIME bonus design.
# Process corners are defined in mmmc.view; keep this file SDC-only.
set sdc_version 2.1

set CYCLE 5.0
set HALF_CYCLE 2.5

create_clock -name clk -period $CYCLE \
             -waveform {0.0 2.5} [get_ports clk]
set_clock_uncertainty 0.1 [get_clocks clk]

# Only synchronous data ports receive I/O delays.  clk is the clock root and
# rst_n is asynchronous, so neither belongs in the data-input collection.
set DATA_INPUTS [remove_from_collection [all_inputs] [get_ports {clk rst_n}]]
set_input_transition 0.1 $DATA_INPUTS
set_input_delay  -max $HALF_CYCLE -clock clk $DATA_INPUTS
set_input_delay  -min 0.0         -clock clk $DATA_INPUTS
set_output_delay -max $HALF_CYCLE -clock clk [all_outputs]
set_output_delay -min 0.0         -clock clk [all_outputs]

set_false_path -from [get_ports rst_n]
