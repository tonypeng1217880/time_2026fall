# Timing- and SI-driven routing on the TSMC90 9-metal stack.
setNanoRouteMode -quiet -drouteStartIteration default
setNanoRouteMode -quiet -routeTopRoutingLayer 9
setNanoRouteMode -quiet -routeBottomRoutingLayer 1
setNanoRouteMode -quiet -drouteEndIteration default
setNanoRouteMode -quiet -routeWithTimingDriven true
setNanoRouteMode -quiet -routeWithSiDriven true

# Do not copy the U18 ANTENNA cell name. Antenna insertion can be enabled
# after confirming the valid diode cell in the TSMC90 library.
routeDesign -globalDetail

saveDesign ./DBS/gcd_route.inn
