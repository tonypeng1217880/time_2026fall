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

# The loaded TSMC90 LEF names its usable signal metals M1 through M8.
# Check this explicitly so a bad layer name stops the sourced flow instead
# of being printed by sroute and then silently continuing to saveDesign.
if {[llength [dbGet head.layers.name M8 -p]] == 0} {
    error "Required routing layer M8 is not present in the loaded TSMC90 LEF"
}

sroute -connect {corePin} \
       -layerChangeRange {M1 M5} \
       -blockPinTarget {nearestTarget} \
       -corePinTarget {firstAfterRowEnd} \
       -allowJogging 1 \
       -crossoverViaLayerRange {M1 M8} \
       -nets {VDD VSS} \
       -allowLayerChange 1 \
       -targetViaLayerRange {M1 M8}

saveDesign ./DBS/gcd_powerplan.inn
