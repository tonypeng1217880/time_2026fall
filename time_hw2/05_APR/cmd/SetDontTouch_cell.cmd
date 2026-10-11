# Preserve the hand-built timing structures during Innovus optimization.
# Controllers and the synthesized TDL selector logic remain optimizable.

foreach block {u_pd1 u_pd2} {
    set pd_cells [get_cells ${block}/*]
    if {[sizeof_collection $pd_cells] == 0} {
        error "No cells found below $block; check synthesized hierarchy"
    }
    set_dont_touch $pd_cells true

    set pd_nets [get_nets ${block}/*]
    if {[sizeof_collection $pd_nets] > 0} {
        set_dont_touch $pd_nets true
    }
}

foreach block {u_tdl1 u_tdl2} {
    set delay_cells [get_cells [list ${block}/u_clkbuf* ${block}/u_tbuf*]]
    if {[sizeof_collection $delay_cells] != 64} {
        error "Expected 32 CLKBUFs and 32 TBUFs below $block"
    }
    set_dont_touch $delay_cells true

    set delay_nets [get_nets [list ${block}/coarse_node* \
                                    ${block}/coarse_mid* \
                                    ${block}/fine1_node* \
                                    ${block}/fine2_node*]]
    if {[sizeof_collection $delay_nets] > 0} {
        set_dont_touch $delay_nets true
    }
}

puts "Preserved u_pd1/u_pd2 and the 64 explicit delay cells in each TDL"
