timeDesign -postCTS \
           -pathReports -drvReports -slackReports \
           -numPaths 50 \
           -prefix gcd_postCTS \
           -outDir timingReports

setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postCTS

timeDesign -postCTS -hold \
           -pathReports -slackReports \
           -numPaths 50 \
           -prefix gcd_postCTS_hold \
           -outDir timingReports

setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -postCTS -hold

saveDesign ./DBS/gcd_postCTS.inn
