# Connect the TSMC90 core power and ground nets.
clearGlobalNets
globalNetConnect VDD -type pgpin -pin VDD -inst * -module {}
globalNetConnect VDD -type tiehi -pin VDD -inst * -module {}
globalNetConnect VSS -type pgpin -pin VSS -inst * -module {}
globalNetConnect VSS -type tielo -pin VSS -inst * -module {}

# TSMC90 core ring. Dimensions and layers follow the original TIME flow.
addRing -skip_via_on_wire_shape Noshape \
        -skip_via_on_pin {} \
        -center 1 \
        -stacked_via_top_layer M5 \
        -stacked_via_bottom_layer M1 \
        -type core_rings \
        -jog_distance 0.42 \
        -threshold 0.1 \
        -nets {VDD VSS} \
        -follow core \
        -layer {bottom M5 top M5 right M4 left M4} \
        -width 2 \
        -spacing 0.5 \
        -offset 0.1 \
        -extend_corner {tl lt tr bl br rb lb rt}

sroute -connect {corePin} \
       -layerChangeRange {M1 M5} \
       -blockPinTarget {nearestTarget} \
       -corePinTarget {firstAfterRowEnd} \
       -allowJogging 1 \
       -crossoverViaLayerRange {M1 M9} \
       -nets {VDD VSS} \
       -allowLayerChange 1 \
       -targetViaLayerRange {M1 M9}

saveDesign ./DBS/gcd_powerplan.inn
