timeDesign -signoff \
           -pathReports -drvReports -slackReports \
           -numPaths 50 \
           -prefix gcd_signoff \
           -outDir timingReports

timeDesign -signoff -hold \
           -pathReports -drvReports -slackReports \
           -numPaths 50 \
           -prefix gcd_signoff_hold \
           -outDir timingReports
