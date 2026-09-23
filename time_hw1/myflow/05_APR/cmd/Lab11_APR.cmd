# Complete core-only TSMC90 APR sequence.
# Run after cmd/run_apr.cmd has initialized the design.

source ./cmd/apr_setting.cmd
source ./cmd/floorPlan.cmd
source ./cmd/powerRing.cmd
source ./cmd/powerStripe.cmd
source ./cmd/place.cmd
source ./cmd/ccopt.cmd
source ./cmd/postCTSTiming.cmd
source ./cmd/nanoRoute.cmd
source ./cmd/postRouteTiming.cmd
source ./cmd/addFiller.cmd
source ./cmd/postRouteVerify.cmd
source ./cmd/signOff.cmd
source ./cmd/streamOut.cmd
