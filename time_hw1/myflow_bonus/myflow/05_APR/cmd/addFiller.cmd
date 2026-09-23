getFillerMode -quiet
addFiller -cell FILL64 FILL32 FILL16 FILL8 FILL4 FILL2 FILL1 -prefix FILLER

addMetalFill -layer {M1 M2 M3 M4 M5 M6 M7 M8 M9} -nets {VSS VDD}
saveDesign ./DBS/gcd_filler.inn
