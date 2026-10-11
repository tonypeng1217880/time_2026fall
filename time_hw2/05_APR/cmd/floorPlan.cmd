# Small core-only design: no pads or SRAM macros.  One compact TDL row is
# 16 * 6.72 = 107.52 um wide, so use a wide, low-utilization core with room
# for the two hand-placed TDLs plus routing.
# Innovus defines aspect ratio as H/W.  0.45 therefore creates the wide core
# needed by the 107.52 um horizontal TDL chain.
floorPlan -r 0.45 0.45 5 5 5 5
saveDesign ./DBS/gcd_floorplan.inn
