if {![info exists ProcessRoot]} {
    set ProcessRoot "/usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/SOCE"
}

setAnalysisMode -analysisType bcwc

write_sdf -max_view func_mode_max \
          -typ_view func_mode_max \
          -min_view func_mode_min \
          -remashold \
          -splitrecrem \
          -recompute_delay_calc \
          ./StreamOut/gcd_APR.sdf

saveNetlist ./StreamOut/gcd_APR.v

streamOut ./StreamOut/gcd.gds \
          -mapFile $ProcessRoot/streamOut.map \
          -libName DesignLib \
          -structureName gcd \
          -units 2000 \
          -mode ALL

write_lef_abstract ./StreamOut/gcd.lef
saveDesign ./DBS/gcd_final.inn
summaryReport -noHtml -outfile ./StreamOut/gcd_summary.rpt
