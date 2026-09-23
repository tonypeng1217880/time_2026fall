setAnalysisMode -analysisType onChipVariation \
                -cppr none \
                -clockGatingCheck true \
                -timeBorrowing true \
                -useOutputPinCap true \
                -enableMultipleDriveNet true \
                -clkSrcPath true \
                -warn true \
                -usefulSkew true \
                -log true

setExtractRCMode -engine postRoute -effortLevel high -coupled true
setDelayCalMode -SIAware true

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
