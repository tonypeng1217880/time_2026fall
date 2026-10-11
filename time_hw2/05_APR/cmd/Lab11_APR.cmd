# Complete core-only TSMC90 APR sequence for the two-phase DLL.
# Run after cmd/run_apr.cmd has initialized the design.
#
# There is deliberately no CTS step.  For this small timing circuit a clock
# tree can add unwanted delay/skew and can disturb the hand-built delay path.

source ./cmd/apr_setting.cmd
source ./cmd/floorPlan.cmd
source ./cmd/pinPlace.cmd
source ./cmd/powerRing.cmd
source ./cmd/SetDontTouch_cell.cmd
source ./cmd/place_special.cmd
source ./cmd/place.cmd
source ./cmd/nanoRoute.cmd
source ./cmd/postRouteTiming.cmd
source ./cmd/addFiller.cmd
source ./cmd/postRouteVerify.cmd
source ./cmd/signOff.cmd
source ./cmd/streamOut.cmd
