# TSMC90 APR timing constraints for the Homework #2 two-phase DLL.
# The APR flow intentionally does not build a clock tree.  clk_in remains
# ideal during placement; postRouteTiming.cmd propagates the routed clock net
# before final timing analysis.
set sdc_version 2.1

set CYCLE 1.0

create_clock -name clk_in -period $CYCLE \
             -waveform {0.0 0.5} [get_ports clk_in]
set_clock_uncertainty 0.02 [get_clocks clk_in]
# No CTS is used.  Prevent optimization from silently creating a substitute
# buffer tree on the root clock net.
set_dont_touch_network [get_clocks clk_in]

# clk_o1 and clk_o2 are generated clock waveforms, not synchronous data
# outputs, so ordinary output-delay constraints would be misleading here.
set_input_transition 0.05 [get_ports clk_in]
set_load 0.01 [all_outputs]

set_false_path -from [get_ports rst_n]

# The first controller synchronizer stage intentionally samples the
# asynchronous phase-detector result.  Setup/hold analysis cannot prove this
# CDC path; the second stage (pd_meta -> pd_sync) remains timed normally.
set_false_path -to [get_pins {u_ctl1/pd_meta_reg/D \
                              u_ctl2/pd_meta_reg/D}]

# Each phase detector is a self-resetting asynchronous structure.  Its Q to
# RN feedback deliberately violates an ordinary recovery/removal model while
# generating the detector pulse, so exclude only the four asynchronous reset
# pins.  Gate/post-layout simulation still checks the real behavior.
set_false_path -to [get_pins {u_pd1/u_ff1/RN u_pd1/u_ff2/RN \
                              u_pd2/u_ff1/RN u_pd2/u_ff2/RN}]

# The tuning code is allowed to change while the DLL searches, after which
# the controller waits seven cycles before sampling the phase detector.
# The synthesized TDL selector may be recognized as a clock-gating structure,
# but its code input is not a same-cycle synchronous clock-gating path.
# Preserve normal controller reg-to-reg timing and cut only code -> own TDL.
set_false_path \
    -from [get_pins u_ctl1/tdl_code_reg_*/Q*] \
    -to   [get_pins u_tdl1/*]
set_false_path \
    -from [get_pins u_ctl2/tdl_code_reg_*/Q*] \
    -to   [get_pins u_tdl2/*]
