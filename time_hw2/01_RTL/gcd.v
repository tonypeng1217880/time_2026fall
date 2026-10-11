`timescale 1ns/1ps

// Two independent, continuously clocked delay lines. All RTL stays in gcd.v.
// The reference assumes a 50% duty-cycle clk_in. Inverter delay is part of
// the real half-cycle reference and must be checked in library/SDF simulation.
module gcd (
    input  clk_in,
    input  rst_n,
    output clk_o1,
    output clk_o2,
    output locked
);
    wire ref_half;
    wire [5:0] code1, code2;
    wire lead_lag1, lead_lag2;
    wire locked1, locked2;
    wire measure1, measure2;

    assign ref_half = ~clk_in;
    assign locked = locked1 & locked2;

    tdl u_tdl1 (.tdl_in(clk_in), .tdl_code(code1), .tdl_out(clk_o1));
    tdl u_tdl2 (.tdl_in(clk_in), .tdl_code(code2), .tdl_out(clk_o2));

    // Each phase detector is initialized once by the global reset and then
    // continuously self-clears through its internal u5/u7 reset loop.  Do not
    // gate an asynchronous DFF reset with the controller measurement window:
    // its periodic deassertion can violate recovery/removal at gate level.
    pd u_pd1 (.ref_clk(ref_half), .fb_clk(clk_o1),
              .rst_n(rst_n), .lead_lag(lead_lag1));
    pd u_pd2 (.ref_clk(clk_in), .fb_clk(clk_o2),
              .rst_n(rst_n), .lead_lag(lead_lag2));

    controller u_ctl1 (
        .clk_in(clk_in), .rst_n(rst_n), .enable(1'b1),
        .lead_lag(lead_lag1), .tdl_code(code1),
        .locked(locked1), .measure_active(measure1)
    );
    controller #(.ACQUIRE_FORWARD(1)) u_ctl2 (
        .clk_in(clk_in), .rst_n(rst_n), .enable(locked1),
        .lead_lag(lead_lag2), .tdl_code(code2),
        .locked(locked2), .measure_active(measure2)
    );
endmodule

module pd (
    input ref_clk,
    input rst_n,
    input fb_clk,
    output lead_lag
);
    wire up;
    wire down;

    wire clk_up;
    wire clk_down;
    wire u5_out;
    wire u6_out;
    wire ff_reset_n;
    wire u8_out;
    wire u9_out;
    wire u10_out;
    wire u11_out;
    wire dummy_out;
    // The TA physical-design flow uses the high-speed, Q-only reset DFF for
    // the two detector arms.  QN is not used by this PD.
    DFFRHQX1 u_ff1 (.D(1'b1), .CK(fb_clk),  .RN(ff_reset_n), .Q(up));
    CLKBUFX4 u3 (.A(up), .Y(clk_up));
    NAND2X4 u5 (.A(clk_up), .B(clk_down), .Y(u5_out));

    DFFRHQX1 u_ff2 (.D(1'b1), .CK(ref_clk), .RN(ff_reset_n), .Q(down));
    CLKBUFX4 u4 (.A(down), .Y(clk_down));
    NAND2X4 u6 (.A(clk_up), .B(clk_down), .Y(u6_out));

    AND2X8 u7 (.A(u5_out), .B(rst_n), .Y(ff_reset_n));

    NAND2X4 u8 (.A(clk_up), .B(u9_out), .Y(u8_out));
    NAND2X4 u9 (.A(clk_down), .B(u8_out), .Y(u9_out));
    NAND2X4 u10 (.A(u8_out), .B(u11_out), .Y(u10_out));
    NAND2X4 u11 (.A(u9_out), .B(u10_out), .Y(u11_out));
    CLKBUFX4 u12 (.A(u10_out), .Y(lead_lag));
    CLKBUFX4 u13 (.A(u11_out), .Y(dummy_out));
endmodule

module tdl (
    input  [5:0] tdl_code,
    input        tdl_in,
    output       tdl_out
);
  
    wire [16:0]   coarse_node;
    wire [15:0] coarse_mid;
    wire [15:0] fine1_node;
    wire [15:0] fine2_node;

    assign coarse_node[0] = tdl_in;

    // Stage 0
    CLKBUFX4 u_clkbuf0_0 (.A(coarse_node[0]), .Y(coarse_mid[0]));
    CLKBUFX4 u_clkbuf0_1 (.A(coarse_mid[0]),  .Y(coarse_node[1]));
    TBUFX16  u_tbuf0_0   (.A(coarse_node[1]), .OE(1'b1), .Y(fine1_node[0]));
    TBUFX16  u_tbuf0_1   (.A(fine1_node[0]),  .OE(1'b1), .Y(fine2_node[0]));

    // Stage 1
    CLKBUFX4 u_clkbuf1_0 (.A(coarse_node[1]), .Y(coarse_mid[1]));
    CLKBUFX4 u_clkbuf1_1 (.A(coarse_mid[1]),  .Y(coarse_node[2]));
    TBUFX16  u_tbuf1_0   (.A(coarse_node[2]), .OE(1'b1), .Y(fine1_node[1]));
    TBUFX16  u_tbuf1_1   (.A(fine1_node[1]),  .OE(1'b1), .Y(fine2_node[1]));

    // Stage 2
    CLKBUFX4 u_clkbuf2_0 (.A(coarse_node[2]), .Y(coarse_mid[2]));
    CLKBUFX4 u_clkbuf2_1 (.A(coarse_mid[2]),  .Y(coarse_node[3]));
    TBUFX16  u_tbuf2_0   (.A(coarse_node[3]), .OE(1'b1), .Y(fine1_node[2]));
    TBUFX16  u_tbuf2_1   (.A(fine1_node[2]),  .OE(1'b1), .Y(fine2_node[2]));

    // Stage 3
    CLKBUFX4 u_clkbuf3_0 (.A(coarse_node[3]), .Y(coarse_mid[3]));
    CLKBUFX4 u_clkbuf3_1 (.A(coarse_mid[3]),  .Y(coarse_node[4]));
    TBUFX16  u_tbuf3_0   (.A(coarse_node[4]), .OE(1'b1), .Y(fine1_node[3]));
    TBUFX16  u_tbuf3_1   (.A(fine1_node[3]),  .OE(1'b1), .Y(fine2_node[3]));

    // Stage 4
    CLKBUFX4 u_clkbuf4_0 (.A(coarse_node[4]), .Y(coarse_mid[4]));
    CLKBUFX4 u_clkbuf4_1 (.A(coarse_mid[4]),  .Y(coarse_node[5]));
    TBUFX16  u_tbuf4_0   (.A(coarse_node[5]), .OE(1'b1), .Y(fine1_node[4]));
    TBUFX16  u_tbuf4_1   (.A(fine1_node[4]),  .OE(1'b1), .Y(fine2_node[4]));

    // Stage 5
    CLKBUFX4 u_clkbuf5_0 (.A(coarse_node[5]), .Y(coarse_mid[5]));
    CLKBUFX4 u_clkbuf5_1 (.A(coarse_mid[5]),  .Y(coarse_node[6]));
    TBUFX16  u_tbuf5_0   (.A(coarse_node[6]), .OE(1'b1), .Y(fine1_node[5]));
    TBUFX16  u_tbuf5_1   (.A(fine1_node[5]),  .OE(1'b1), .Y(fine2_node[5]));

    // Stage 6
    CLKBUFX4 u_clkbuf6_0 (.A(coarse_node[6]), .Y(coarse_mid[6]));
    CLKBUFX4 u_clkbuf6_1 (.A(coarse_mid[6]),  .Y(coarse_node[7]));
    TBUFX16  u_tbuf6_0   (.A(coarse_node[7]), .OE(1'b1), .Y(fine1_node[6]));
    TBUFX16  u_tbuf6_1   (.A(fine1_node[6]),  .OE(1'b1), .Y(fine2_node[6]));

    // Stage 7
    CLKBUFX4 u_clkbuf7_0 (.A(coarse_node[7]), .Y(coarse_mid[7]));
    CLKBUFX4 u_clkbuf7_1 (.A(coarse_mid[7]),  .Y(coarse_node[8]));
    TBUFX16  u_tbuf7_0   (.A(coarse_node[8]), .OE(1'b1), .Y(fine1_node[7]));
    TBUFX16  u_tbuf7_1   (.A(fine1_node[7]),  .OE(1'b1), .Y(fine2_node[7]));

    // Stage 8
    CLKBUFX4 u_clkbuf8_0 (.A(coarse_node[8]), .Y(coarse_mid[8]));
    CLKBUFX4 u_clkbuf8_1 (.A(coarse_mid[8]),  .Y(coarse_node[9]));
    TBUFX16  u_tbuf8_0   (.A(coarse_node[9]), .OE(1'b1), .Y(fine1_node[8]));
    TBUFX16  u_tbuf8_1   (.A(fine1_node[8]),  .OE(1'b1), .Y(fine2_node[8]));

    // Stage 9
    CLKBUFX4 u_clkbuf9_0 (.A(coarse_node[9]),  .Y(coarse_mid[9]));
    CLKBUFX4 u_clkbuf9_1 (.A(coarse_mid[9]),   .Y(coarse_node[10]));
    TBUFX16  u_tbuf9_0   (.A(coarse_node[10]), .OE(1'b1), .Y(fine1_node[9]));
    TBUFX16  u_tbuf9_1   (.A(fine1_node[9]),   .OE(1'b1), .Y(fine2_node[9]));

    // Stage 10
    CLKBUFX4 u_clkbuf10_0 (.A(coarse_node[10]), .Y(coarse_mid[10]));
    CLKBUFX4 u_clkbuf10_1 (.A(coarse_mid[10]),  .Y(coarse_node[11]));
    TBUFX16  u_tbuf10_0   (.A(coarse_node[11]), .OE(1'b1), .Y(fine1_node[10]));
    TBUFX16  u_tbuf10_1   (.A(fine1_node[10]),  .OE(1'b1), .Y(fine2_node[10]));

    // Stage 11
    CLKBUFX4 u_clkbuf11_0 (.A(coarse_node[11]), .Y(coarse_mid[11]));
    CLKBUFX4 u_clkbuf11_1 (.A(coarse_mid[11]),  .Y(coarse_node[12]));
    TBUFX16  u_tbuf11_0   (.A(coarse_node[12]), .OE(1'b1), .Y(fine1_node[11]));
    TBUFX16  u_tbuf11_1   (.A(fine1_node[11]),  .OE(1'b1), .Y(fine2_node[11]));

    // Stage 12
    CLKBUFX4 u_clkbuf12_0 (.A(coarse_node[12]), .Y(coarse_mid[12]));
    CLKBUFX4 u_clkbuf12_1 (.A(coarse_mid[12]),  .Y(coarse_node[13]));
    TBUFX16  u_tbuf12_0   (.A(coarse_node[13]), .OE(1'b1), .Y(fine1_node[12]));
    TBUFX16  u_tbuf12_1   (.A(fine1_node[12]),  .OE(1'b1), .Y(fine2_node[12]));

    // Stage 13
    CLKBUFX4 u_clkbuf13_0 (.A(coarse_node[13]), .Y(coarse_mid[13]));
    CLKBUFX4 u_clkbuf13_1 (.A(coarse_mid[13]),  .Y(coarse_node[14]));
    TBUFX16  u_tbuf13_0   (.A(coarse_node[14]), .OE(1'b1), .Y(fine1_node[13]));
    TBUFX16  u_tbuf13_1   (.A(fine1_node[13]),  .OE(1'b1), .Y(fine2_node[13]));

    // Stage 14
    CLKBUFX4 u_clkbuf14_0 (.A(coarse_node[14]), .Y(coarse_mid[14]));
    CLKBUFX4 u_clkbuf14_1 (.A(coarse_mid[14]),  .Y(coarse_node[15]));
    TBUFX16  u_tbuf14_0   (.A(coarse_node[15]), .OE(1'b1), .Y(fine1_node[14]));
    TBUFX16  u_tbuf14_1   (.A(fine1_node[14]),  .OE(1'b1), .Y(fine2_node[14]));

    // Stage 15
    CLKBUFX4 u_clkbuf15_0 (.A(coarse_node[15]), .Y(coarse_mid[15]));
    CLKBUFX4 u_clkbuf15_1 (.A(coarse_mid[15]),  .Y(coarse_node[16]));
    TBUFX16  u_tbuf15_0   (.A(coarse_node[16]), .OE(1'b1), .Y(fine1_node[15]));
    TBUFX16  u_tbuf15_1   (.A(fine1_node[15]),  .OE(1'b1), .Y(fine2_node[15]));

    // One-hot output selection.  Every candidate tap passes through one
    // identical TBUF selector, avoiding the large and path-dependent 48:1
    // mux that a variable array index would synthesize.
    reg selected_tap;
    always @(*) begin
        case (tdl_code)
            // The synthesized mux is itself the common output delay.  Start
            // with the undelayed input so the slow-corner minimum remains
            // below 0.5 ns, then retain the sorted coarse/fine progression.
            6'd0 : selected_tap = coarse_node[0];
            6'd1 : selected_tap = coarse_mid[0];
            6'd2 : selected_tap = coarse_node[1];
            6'd3 : selected_tap = fine1_node[0];
            6'd4 : selected_tap = coarse_node[2];
            6'd5 : selected_tap = fine2_node[0];
            6'd6 : selected_tap = fine1_node[1];
            6'd7 : selected_tap = coarse_node[3];
            6'd8 : selected_tap = fine2_node[1];
            6'd9 : selected_tap = fine1_node[2];
            6'd10: selected_tap = coarse_node[4];
            6'd11: selected_tap = fine2_node[2];
            6'd12: selected_tap = fine1_node[3];
            6'd13: selected_tap = coarse_node[5];
            6'd14: selected_tap = fine2_node[3];
            6'd15: selected_tap = fine1_node[4];
            6'd16: selected_tap = coarse_node[6];
            6'd17: selected_tap = fine2_node[4];
            6'd18: selected_tap = fine1_node[5];
            6'd19: selected_tap = coarse_node[7];
            6'd20: selected_tap = fine2_node[5];
            6'd21: selected_tap = fine1_node[6];
            6'd22: selected_tap = coarse_node[8];
            6'd23: selected_tap = fine2_node[6];
            6'd24: selected_tap = fine1_node[7];
            6'd25: selected_tap = coarse_node[9];
            6'd26: selected_tap = fine2_node[7];
            6'd27: selected_tap = fine1_node[8];
            6'd28: selected_tap = coarse_node[10];
            6'd29: selected_tap = fine2_node[8];
            6'd30: selected_tap = fine1_node[9];
            6'd31: selected_tap = coarse_node[11];
            6'd32: selected_tap = fine2_node[9];
            6'd33: selected_tap = fine1_node[10];
            6'd34: selected_tap = coarse_node[12];
            6'd35: selected_tap = fine2_node[10];
            6'd36: selected_tap = fine1_node[11];
            6'd37: selected_tap = coarse_node[13];
            6'd38: selected_tap = fine2_node[11];
            6'd39: selected_tap = fine1_node[12];
            6'd40: selected_tap = coarse_node[14];
            6'd41: selected_tap = fine2_node[12];
            6'd42: selected_tap = fine1_node[13];
            6'd43: selected_tap = coarse_node[15];
            6'd44: selected_tap = fine2_node[13];
            6'd45: selected_tap = fine1_node[14];
            6'd46: selected_tap = coarse_node[16];
            6'd47: selected_tap = fine1_node[15];
            default: selected_tap = coarse_node[0];
        endcase
    end

    // The synthesized mux already contributes a common delay.  Drive the
    // output directly so code 0 remains below the 0.5 ns target.  Unlike the
    // former 48-TBUF bus, this has exactly one logic driver and cannot resolve
    // to X because two tri-state cells overlap during a code transition.
`ifdef RTL
    // The synthesized mux has a real nonzero delay.  Add 1 ps only to the
    // functional RTL model so code 0 is not an exact-time tie at PD2.
    assign #0.001 tdl_out = selected_tap;
`else
    assign tdl_out = selected_tap;
`endif
endmodule

// ACQUIRE_FORWARD skips PD2's initial lag region below half a period.
// The scan assumes increasing physical delay with increasing code and a
// code step small enough not to skip the half-period-wide lead region.
module controller #(
    parameter ACQUIRE_FORWARD = 0
) (
    input            clk_in,
    input            rst_n,
    input            enable,
    input            lead_lag,
    output reg [5:0] tdl_code,
    output reg       locked,
    output           measure_active
);

    reg [2:0] wait_count;
    reg       prev_lead_lag;
    reg       prev_valid;
    reg       forward_armed;
    reg       forward_high_seen;

    reg       pd_meta;
    reg       pd_sync;
    wire      update_en;

    // 將 PD 的輸出送進 controller 的時脈域。
    // 這不會自動判斷結果是否屬於新的控制碼，
    // 所以下面仍然需要等待。
    // Capture the asynchronous PD result on the falling edge.  The second
    // stage then receives about half a cycle of setup margin before the
    // controller's rising-edge clock domain samples it.
    always @(negedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            pd_meta <= 1'b0;
        end
        else
            pd_meta <= lead_lag;
    end

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n)
            pd_sync <= 1'b0;
        else
            pd_sync <= pd_meta;
    end

    // 範例：每隔 8 個 clk_in 週期判斷一次
    assign update_en = (wait_count == 3'd7) && enable && !locked;
    // One cycle in reset after every code change, then seven cycles in
    // which the detector and its two-stage synchronizer can settle.
    assign measure_active = (wait_count != 3'd0) && enable && !locked;

    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            tdl_code      <= 6'd0;
            locked        <= 1'b0;
            wait_count    <= 3'd0;
            prev_lead_lag <= 1'b0;
            prev_valid    <= 1'b0;
            forward_armed <= 1'b0;
            forward_high_seen <= 1'b0;
        end
        else if (!enable) begin
            wait_count <= 3'd0;
            prev_valid <= 1'b0;
            forward_armed <= 1'b0;
            forward_high_seen <= 1'b0;
        end
        else if (!locked) begin
            if (!update_en) begin
                wait_count <= wait_count + 3'd1;
            end
            else begin
                wait_count <= 3'd0;

                if (ACQUIRE_FORWARD) begin
                    // A full-period search can see a short, false transition
                    // near the half-period point.  Arm locking only after two
                    // consecutive high measurements; then the first low is
                    // the far (one-period) crossing that we want.
                    if (!forward_armed) begin
                        if (pd_sync == 1'b1) begin
                            if (forward_high_seen)
                                forward_armed <= 1'b1;
                            else
                                forward_high_seen <= 1'b1;
                        end
                        else begin
                            forward_high_seen <= 1'b0;
                        end

                        if (tdl_code < 6'd47)
                            tdl_code <= tdl_code + 6'd1;
                    end
                    else if (pd_sync == 1'b0) begin
                        locked <= 1'b1;
                    end
                    else if (tdl_code < 6'd47) begin
                        tdl_code <= tdl_code + 6'd1;
                    end
                end
                else begin
                    // Half-period search: lock at the first direction
                    // reversal after a real one-code movement.
                    if (prev_valid && (pd_sync != prev_lead_lag)) begin
                        locked <= 1'b1;
                    end
                    else if ((pd_sync == 1'b1) &&
                             (tdl_code < 6'd47)) begin
                        tdl_code      <= tdl_code + 6'd1;
                        prev_lead_lag <= 1'b1;
                        prev_valid    <= 1'b1;
                    end
                    else if ((pd_sync == 1'b0) &&
                             (tdl_code > 6'd0)) begin
                        tdl_code      <= tdl_code - 6'd1;
                        prev_lead_lag <= 1'b0;
                        prev_valid    <= 1'b1;
                    end
                    else begin
                        // Reaching a boundary is not itself proof of lock.
                        prev_valid <= 1'b0;
                    end
                end
            end
        end
    end

endmodule
