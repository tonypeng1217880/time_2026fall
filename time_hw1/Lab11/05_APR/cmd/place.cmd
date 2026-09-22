setPlaceMode -prerouteAsObs {2 3}
setPlaceMode -fp false
place_design -noPrePlaceOpt

addTieHiLo -cell {TIELO TIEHI} -prefix LTIE
fit

timeDesign -preCTS \
           -pathReports -drvReports -slackReports \
           -numPaths 50 \
           -prefix gcd_preCTS \
           -outDir timingReports

setOptMode -fixCap true -fixTran true -fixFanoutLoad true
optDesign -preCTS

saveDesign ./DBS/gcd_placement.inn
