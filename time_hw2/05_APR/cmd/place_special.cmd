# Manual placement for the matched PD arms and the two path-selection TDLs.
# Cell dimensions are from the TSMC90 cell-size tables.  All dimensions are
# integer multiples of the 0.28 um placement site.

set H_CELL      2.52
set W_CLKBUFX4  1.40
set W_TBUFX16   6.72
set W_DFFRHQX1  7.56
set W_NAND2X4   1.96
set W_AND2X8    3.92

set left_bound 5.0
set down_bound 5.0

proc place_required {inst x y} {
    set cell [get_cells $inst]
    if {[sizeof_collection $cell] != 1} {
        error "Expected exactly one cell named $inst"
    }
    placeInstance $inst $x $y
}

# One stage occupies a 6.72 um-wide tile:
#
#   row 2:  TBUFX16 u_tbuf*_1
#   row 1:  TBUFX16 u_tbuf*_0
#   row 0:       CLKBUFX4 | CLKBUFX4
#
# The CLKBUF pair is centered over the TBUF.  Consecutive stage tiles touch,
# and every connection inside a stage stays local.  This follows the TA's
# recommendation to keep delay cells physically adjacent.
proc place_tdl_chain {block x0 y0} {
    global H_CELL W_CLKBUFX4 W_TBUFX16
    set clk_pair_width [expr {2.0 * $W_CLKBUFX4}]
    set clk_offset [expr {($W_TBUFX16 - $clk_pair_width) / 2.0}]

    for {set idx 0} {$idx < 16} {incr idx} {
        set tile_x [expr {$x0 + $idx * $W_TBUFX16}]
        set clk_x [expr {$tile_x + $clk_offset}]

        place_required ${block}/u_clkbuf${idx}_0 $clk_x $y0
        place_required ${block}/u_clkbuf${idx}_1 \
                       [expr {$clk_x + $W_CLKBUFX4}] $y0
        place_required ${block}/u_tbuf${idx}_0 $tile_x \
                       [expr {$y0 + $H_CELL}]
        place_required ${block}/u_tbuf${idx}_1 $tile_x \
                       [expr {$y0 + 2.0 * $H_CELL}]
    }
}

set tdl_x [expr {$left_bound + 5.04}]
set tdl1_y [expr {$down_bound + 1.0 * $H_CELL}]
set tdl2_y [expr {$down_bound + 5.0 * $H_CELL}]
place_tdl_chain u_tdl1 $tdl_x $tdl1_y
place_tdl_chain u_tdl2 $tdl_x $tdl2_y

# Place the two matched PD arms in touching columns.  Corresponding upper and
# lower cells share the same x coordinate, minimizing systematic mismatch.
proc place_pd_pair {block x0 y0} {
    global H_CELL W_CLKBUFX4 W_DFFRHQX1 W_NAND2X4 W_AND2X8

    set y_dn $y0
    set y_up [expr {$y0 + $H_CELL}]
    set y_rst [expr {$y0 + 2.0 * $H_CELL}]

    set x_ff $x0
    set x_buf [expr {$x_ff + $W_DFFRHQX1}]
    set x_pd_nand [expr {$x_buf + $W_CLKBUFX4}]
    set x_sr0 [expr {$x_pd_nand + $W_NAND2X4}]
    set x_sr1 [expr {$x_sr0 + $W_NAND2X4}]
    set x_out [expr {$x_sr1 + $W_NAND2X4}]

    place_required ${block}/u_ff1 $x_ff $y_up
    place_required ${block}/u_ff2 $x_ff $y_dn
    place_required ${block}/u3 $x_buf $y_up
    place_required ${block}/u4 $x_buf $y_dn
    place_required ${block}/u5 $x_pd_nand $y_up
    place_required ${block}/u6 $x_pd_nand $y_dn

    # u7 generates the common active-low reset and sits immediately above the
    # detector NAND/latch columns, close to both DFF reset pins.
    place_required ${block}/u7 $x_pd_nand $y_rst

    place_required ${block}/u8  $x_sr0 $y_up
    place_required ${block}/u9  $x_sr0 $y_dn
    place_required ${block}/u10 $x_sr1 $y_up
    place_required ${block}/u11 $x_sr1 $y_dn
    place_required ${block}/u12 $x_out $y_up
    place_required ${block}/u13 $x_out $y_dn

    return [expr {$x_out + $W_CLKBUFX4 - $x0}]
}

set pd_y [expr {$down_bound + 10.0 * $H_CELL}]
set pd1_x [expr {$left_bound + 5.04}]
set pd_width [place_pd_pair u_pd1 $pd1_x $pd_y]
set pd2_x [expr {$pd1_x + $pd_width + 2.80}]
place_pd_pair u_pd2 $pd2_x $pd_y

puts "Placed two adjacent-cell TDL chains and two width-matched PD structures"
