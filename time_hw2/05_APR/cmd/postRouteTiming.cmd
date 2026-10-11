# No clock tree is built.  Propagate the actually routed clk_in network for
# post-route STA instead of continuing to treat it as an ideal pre-CTS clock.
# In MMMC mode an SDC command entered from a sourced Tcl file must first be
# associated with one or more interactive constraint modes.
set_interactive_constraint_modes [all_constraint_modes -active]
set_propagated_clock [get_clocks clk_in]
set_interactive_constraint_modes {}

setAnalysisMode -analysisType onChipVariation \
                -cppr none \
                -clockGatingCheck false \
                -timeBorrowing true \
                -useOutputPinCap true \
                -enableMultipleDriveNet true \
                -clkSrcPath true \
                -warn true \
                -usefulSkew false \
                -log true

# This course kit does not provide a TSMC90 Quantus QRC technology file in
# the MMMC RC corners.  High/signoff extraction therefore cannot run.  Use
# Innovus' native low-effort post-route extractor and non-SI delay analysis.
setExtractRCMode -engine postRoute -effortLevel low -coupled false
setDelayCalMode -SIAware false

timeDesign -postRoute \
           -pathReports -drvReports -slackReports \
           -numPaths 50 \
           -prefix gcd_postRoute \
           -outDir timingReports

setOptMode -fixCap true -fixTran true -fixFanoutLoad true
setOptMode -setupTargetSlack 0.02
optDesign -postRoute -setup

timeDesign -postRoute -hold \
           -pathReports -slackReports \
           -numPaths 50 \
           -prefix gcd_postRoute_hold \
           -outDir timingReports

setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postRoute -hold

timeDesign -postRoute \
           -pathReports -drvReports -slackReports \
           -numPaths 50 \
           -prefix gcd_postRoute_final \
           -outDir timingReports
timeDesign -postRoute -hold \
           -pathReports -slackReports \
           -numPaths 50 \
           -prefix gcd_postRoute_final_hold \
           -outDir timingReports

saveDesign ./DBS/gcd_postRoute.inn
