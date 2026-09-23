# TSMC 90 nm global APR settings.
set init_design_uniquify 1
setDesignMode -process 90

# CCOpt prefers M3-M4 for clock nets.  Configure the complete TSMC90 routing
# stack before CTS so those preferred layers are inside NanoRoute's range.
setNanoRouteMode -quiet -routeBottomRoutingLayer 1
setNanoRouteMode -quiet -routeTopRoutingLayer 9

suppressMessage TECHLIB 1318
suppressMessage ENCEXT-2799
