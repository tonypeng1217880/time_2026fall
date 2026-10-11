# TSMC 90 nm global APR settings.
set init_design_uniquify 1
setDesignMode -process 90

# Configure the complete TSMC90 routing stack.  This DLL flow intentionally
# skips CTS; clk_in is routed as an ordinary high-priority signal.
setNanoRouteMode -quiet -routeBottomRoutingLayer 1
setNanoRouteMode -quiet -routeTopRoutingLayer 8

suppressMessage TECHLIB 1318
suppressMessage ENCEXT-2799
