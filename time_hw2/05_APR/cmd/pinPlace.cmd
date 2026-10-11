# Fixed block-pin placement for the core-only DLL.
# M3 is horizontal in this TSMC90 stack, so it is suitable for pins entering
# from the west/east boundaries.  Give every pin an explicit coordinate;
# this old Innovus version left -spreadType CENTER groups at the corners.
setPinAssignMode -pinEditInBatch true

set die_box [lindex [dbGet top.fPlan.box] 0]
set die_llx [lindex $die_box 0]
set die_lly [lindex $die_box 1]
set die_urx [lindex $die_box 2]
set die_ury [lindex $die_box 3]
set die_mid_y [expr {($die_lly + $die_ury) / 2.0}]

# Keep clk_in near the two TDL inputs at the lower-left of the core.
editPin -pin clk_in -assign $die_llx [expr {$die_mid_y - 18.9}] \
        -layer M3 -fixedPin 1 -fixOverlap 1 -snap TRACK

# clk_o1/clk_o2 are also the PD feedback nets.  Put their external pins beside
# the west-side PDs so the delay measured at the output pin closely matches
# the delay seen internally by each phase detector.  Sending these nets to the
# east edge added about 0.37 ns after route and made the PD lock point differ
# from the externally observed phase.
editPin -pin clk_o1 -assign $die_llx [expr {$die_mid_y - 1.26}] \
        -layer M3 -fixedPin 1 -fixOverlap 1 -snap TRACK
editPin -pin clk_o2 -assign $die_llx [expr {$die_mid_y + 1.26}] \
        -layer M3 -fixedPin 1 -fixOverlap 1 -snap TRACK

editPin -pin rst_n  -assign $die_llx [expr {$die_mid_y + 3.78}] \
        -layer M3 -fixedPin 1 -fixOverlap 1 -snap TRACK
editPin -pin locked -assign $die_llx [expr {$die_mid_y + 6.30}] \
        -layer M3 -fixedPin 1 -fixOverlap 1 -snap TRACK

setPinAssignMode -pinEditInBatch false
puts "Placed DLL clock pins beside the west-side TDL/PD structures"
