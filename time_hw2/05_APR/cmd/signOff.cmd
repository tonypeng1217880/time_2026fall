# A true Quantus signoff run is unavailable without a TSMC90 QRC technology
# file.  Re-extract and report the final filled design with the supported
# native post-route engine instead of labeling it as signoff extraction.
setExtractRCMode -engine postRoute -effortLevel low -coupled false
# A previous timeDesign -signOff command can leave this session in signoff
# SI mode even after that command fails for lack of a QRC tech file.
# Native low-effort post-route timing requires that sticky mode to be cleared.
setDelayCalMode -reset -siMode
setDelayCalMode -SIAware false

# addFiller/addMetalFill changed the final physical database after the earlier
# timing run.  Explicitly rebuild the supported native RC data here.  Do not
# use timeDesign -signOff/signoffTimeDesign: both require the missing Quantus
# QRC technology file in this course kit.
extractRC

timeDesign -postRoute \
           -pathReports -drvReports -slackReports \
           -numPaths 50 \
           -prefix gcd_final_postRoute \
           -outDir timingReports

timeDesign -postRoute -hold \
           -pathReports -slackReports \
           -numPaths 50 \
           -prefix gcd_final_postRoute_hold \
           -outDir timingReports
