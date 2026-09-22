module ISP(
    //Input Port
    clk,
    rst_n,

    in_data_valid,
    in_data,
    cmd_valid,
    cmd,

    //Output Port
    out_valid,
    r_out,
    g_out,
    b_out
    );

//==============================
//   INPUT/OUTPUT DECLARATION
//==============================
input clk;
input rst_n;
input in_data_valid;
input [11:0] in_data;
input cmd_valid;
input [5:0] cmd;

output reg out_valid;
output reg [7:0] r_out;
output reg [7:0] g_out;
output reg [7:0] b_out;

//==============================
//  Parameters
//==============================
localparam [8:0] DPC_START = 9'd39;
localparam [8:0] DM_START  = 9'd60;

//==============================
//  Streaming front-end / RAW cache
//==============================
localparam [8:0] TOTAL_PIX = 9'd256;
localparam [8:0] PRE_TAIL  = 9'd452;

reg [13:0] in_cnt;
reg        pre_run;
reg [8:0]  pre_cnt;
reg        input_done;
reg        proc_busy;

reg        src_v;
reg [11:0] src_data;
reg [7:0]  src_pix;

reg        out_pipe_v;
reg        out_pipe_last;
reg [7:0]  out_pipe_r;
reg [7:0]  out_pipe_g;
reg [7:0]  out_pipe_b;

reg        rd_run;
reg [1:0]  rd_group;
reg [3:0]  rd_img;
reg [7:0]  rd_addr_cnt;
reg        raw_data_v;
reg [7:0]  raw_data_pix;

reg        pending_cmd;
reg [1:0]  pending_group;
reg [3:0]  pending_img;

wire        cmd_launch_now = cmd_valid && input_done && !proc_busy;
wire        cmd_launch_pend = pending_cmd && input_done && !proc_busy && !cmd_valid;
wire        cmd_launch = cmd_launch_now || cmd_launch_pend;
wire [1:0]  launch_group = cmd_launch_now ? cmd[5:4] : pending_group;
wire [3:0]  launch_img   = cmd_launch_now ? cmd[3:0] : pending_img;
wire [1:0]  raw_rd_group = cmd_launch ? launch_group : rd_group;
wire [11:0] raw_rd_addr  = cmd_launch ? {launch_img, 8'd0} : {rd_img, rd_addr_cnt};

wire        raw_wr_v = in_data_valid;
wire [1:0]  raw_wr_group = in_cnt[13:12];
wire [11:0] raw_wr_addr  = in_cnt[11:0];

wire [11:0] raw_do0, raw_do1, raw_do2, raw_do3;

wire raw_rd0 = (cmd_launch || rd_run) && (raw_rd_group == 2'd0);
wire raw_rd1 = (cmd_launch || rd_run) && (raw_rd_group == 2'd1);
wire raw_rd2 = (cmd_launch || rd_run) && (raw_rd_group == 2'd2);
wire raw_rd3 = (cmd_launch || rd_run) && (raw_rd_group == 2'd3);
wire raw_wr0 = raw_wr_v && (raw_wr_group == 2'd0);
wire raw_wr1 = raw_wr_v && (raw_wr_group == 2'd1);
wire raw_wr2 = raw_wr_v && (raw_wr_group == 2'd2);
wire raw_wr3 = raw_wr_v && (raw_wr_group == 2'd3);

wire [11:0] raw0_addr = raw_wr0 ? raw_wr_addr : (raw_rd0 ? raw_rd_addr : 12'd0);
wire [11:0] raw1_addr = raw_wr1 ? raw_wr_addr : (raw_rd1 ? raw_rd_addr : 12'd0);
wire [11:0] raw2_addr = raw_wr2 ? raw_wr_addr : (raw_rd2 ? raw_rd_addr : 12'd0);
wire [11:0] raw3_addr = raw_wr3 ? raw_wr_addr : (raw_rd3 ? raw_rd_addr : 12'd0);

SRAM4096X12 U_RAW0(.clk(clk), .addr(raw0_addr), .din(in_data), .web(!raw_wr0), .oe(1'b1), .cs(1'b1), .dout(raw_do0));
SRAM4096X12 U_RAW1(.clk(clk), .addr(raw1_addr), .din(in_data), .web(!raw_wr1), .oe(1'b1), .cs(1'b1), .dout(raw_do1));
SRAM4096X12 U_RAW2(.clk(clk), .addr(raw2_addr), .din(in_data), .web(!raw_wr2), .oe(1'b1), .cs(1'b1), .dout(raw_do2));
SRAM4096X12 U_RAW3(.clk(clk), .addr(raw3_addr), .din(in_data), .web(!raw_wr3), .oe(1'b1), .cs(1'b1), .dout(raw_do3));

wire [11:0] raw_rd_data = (rd_group == 2'd0) ? raw_do0 :
                          (rd_group == 2'd1) ? raw_do1 :
                          (rd_group == 2'd2) ? raw_do2 : raw_do3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        in_cnt <= 14'd0;
        pre_run <= 1'b0;
        pre_cnt <= 9'd0;
        input_done <= 1'b0;
        proc_busy <= 1'b0;
        src_v <= 1'b0;
        src_data <= 12'd0;
        src_pix <= 8'd0;
        rd_run <= 1'b0;
        rd_group <= 2'd0;
        rd_img <= 4'd0;
        rd_addr_cnt <= 8'd0;
        raw_data_v <= 1'b0;
        raw_data_pix <= 8'd0;
        pending_cmd <= 1'b0;
        pending_group <= 2'd0;
        pending_img <= 4'd0;
        out_valid <= 1'b0;
        r_out <= 8'd0;
        g_out <= 8'd0;
        b_out <= 8'd0;
    end
    else begin
        src_v <= raw_data_v;
        src_data <= raw_rd_data;
        src_pix <= raw_data_pix;

        if (in_data_valid) begin
            in_cnt <= in_cnt + 14'd1;
            if (in_cnt == 14'd16383) begin
                input_done <= 1'b1;
            end
        end

        if (src_v && !pre_run) begin
            pre_run <= 1'b1;
            pre_cnt <= 9'd1;
        end
        else if (pre_run && pre_cnt < PRE_TAIL) begin
            pre_cnt <= pre_cnt + 9'd1;
        end

        if (cmd_valid && !cmd_launch_now) begin
            pending_cmd <= 1'b1;
            pending_group <= cmd[5:4];
            pending_img <= cmd[3:0];
        end
        else if (cmd_launch) begin
            pending_cmd <= 1'b0;
        end

        if (cmd_launch) begin
            proc_busy <= 1'b1;
            rd_run <= 1'b1;
            rd_group <= launch_group;
            rd_img <= launch_img;
            rd_addr_cnt <= 8'd1;
            raw_data_v <= 1'b1;
            raw_data_pix <= 8'd0;
            pre_run <= 1'b0;
            pre_cnt <= 9'd0;
        end
        else if (rd_run) begin
            raw_data_v <= 1'b1;
            raw_data_pix <= rd_addr_cnt;
            if (rd_addr_cnt == 8'd255) begin
                rd_run <= 1'b0;
            end
            else begin
                rd_addr_cnt <= rd_addr_cnt + 8'd1;
            end
        end
        else begin
            raw_data_v <= 1'b0;
            raw_data_pix <= 8'd0;
        end

        if (out_pipe_v) begin
            out_valid <= 1'b1;
            r_out <= out_pipe_r;
            g_out <= out_pipe_g;
            b_out <= out_pipe_b;
            if (out_pipe_last) begin
                proc_busy <= 1'b0;
            end
        end
        else begin
            out_valid <= 1'b0;
            r_out <= 8'd0;
            g_out <= 8'd0;
            b_out <= 8'd0;
        end
    end
end

//==============================
//  Scratch buffers
//==============================
reg [11:0] lsc_buf0 [0:15];
reg [11:0] lsc_buf1 [0:15];
reg [11:0] lsc_buf2 [0:15];
reg [11:0] lsc_buf3 [0:15];
reg [11:0] lsc_buf4 [0:15];
reg [11:0] dpc_buf0 [0:15];
reg [11:0] dpc_buf1 [0:15];
reg [11:0] dpc_buf2 [0:15];

//==============================
//  BLC / LSC pipeline
//==============================
reg        in_v_d1;
reg [11:0] in_d1;
reg [7:0]  in_pix_d1;

wire is_r_d1  = !in_pix_d1[4] && !in_pix_d1[0];
wire is_gr_d1 = !in_pix_d1[4] &&  in_pix_d1[0];
wire is_gb_d1 =  in_pix_d1[4] && !in_pix_d1[0];

wire [11:0] blc_val =
    is_r_d1  ? ((in_d1 > 12'd64) ? (in_d1 - 12'd64) : 12'd0) :
    is_gr_d1 ? ((in_d1 > 12'd48) ? (in_d1 - 12'd48) : 12'd0) :
    is_gb_d1 ? ((in_d1 > 12'd52) ? (in_d1 - 12'd52) : 12'd0) :
               ((in_d1 > 12'd72) ? (in_d1 - 12'd72) : 12'd0);

wire [9:0] lsc_gain_delta;
LSC_GXY_LUT U_LSC_GXY(.pix(in_pix_d1), .gain_delta(lsc_gain_delta));

reg        lsc1_v;
reg [11:0] lsc1_p;
reg [9:0]  lsc1_gxy;
reg [7:0]  lsc1_pix;

reg        lsc3_v;
reg [11:0] lsc3_p;
reg [9:0]  lsc3_gxy;
reg [7:0]  lsc3_pix;

reg        lsc4_v;
reg [22:0] lsc4_mul;
reg [7:0]  lsc4_pix;

wire [21:0] lsc_delta_mul = {10'd0, lsc3_p} * lsc3_gxy;
wire [12:0] lsc_shifted = (lsc4_mul + 23'd512) >> 10;
wire [11:0] lsc_clip = (lsc_shifted > 13'd4095) ? 12'd4095 : lsc_shifted[11:0];
wire [3:0] lsc4_y = lsc4_pix[7:4];
wire [2:0] lsc4_y_mod5;

ROW_MOD5 U_LSC_WR_MOD(.y(lsc4_y), .m(lsc4_y_mod5));

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        in_v_d1 <= 1'b0;
        lsc1_v <= 1'b0;
        lsc3_v <= 1'b0;
        lsc4_v <= 1'b0;
    end
    else begin
        in_v_d1   <= src_v;
        lsc1_v   <= in_v_d1;
        lsc3_v   <= lsc1_v;
        lsc4_v   <= lsc3_v;
    end
end

always @(posedge clk) begin
    in_d1     <= src_data;
    in_pix_d1 <= src_pix;

    lsc1_p   <= blc_val;
    lsc1_gxy <= lsc_gain_delta;
    lsc1_pix <= in_pix_d1;

    lsc3_p   <= lsc1_p;
    lsc3_gxy <= lsc1_gxy;
    lsc3_pix <= lsc1_pix;

    lsc4_mul <= {1'b0, lsc3_p, 10'd0} + {1'b0, lsc_delta_mul};
    lsc4_pix <= lsc3_pix;
end

always @(posedge clk) begin
    if (lsc4_v) begin
        case (lsc4_y_mod5)
            3'd0: lsc_buf0[lsc4_pix[3:0]] <= lsc_clip;
            3'd1: lsc_buf1[lsc4_pix[3:0]] <= lsc_clip;
            3'd2: lsc_buf2[lsc4_pix[3:0]] <= lsc_clip;
            3'd3: lsc_buf3[lsc4_pix[3:0]] <= lsc_clip;
            default: lsc_buf4[lsc4_pix[3:0]] <= lsc_clip;
        endcase
    end
end

//==============================
//  DPC pipeline
//==============================
wire [8:0]  dpc_sched_linear = pre_cnt - DPC_START;
wire        dpc_sched_v = pre_run && (pre_cnt >= DPC_START) && (dpc_sched_linear < TOTAL_PIX);
wire [7:0]  dpc_sched_pix = dpc_sched_linear[7:0];
wire [3:0]  dpc_y = dpc_sched_pix[7:4];
wire [3:0]  dpc_x = dpc_sched_pix[3:0];

wire [3:0] dpc_y_m2 = (dpc_y < 4'd2)  ? (4'd2 - dpc_y) : (dpc_y - 4'd2);
wire [3:0] dpc_x_m2 = (dpc_x < 4'd2)  ? (4'd2 - dpc_x) : (dpc_x - 4'd2);
wire [3:0] dpc_y_m1 = (dpc_y == 4'd0) ? 4'd1 : (dpc_y - 4'd1);
wire [3:0] dpc_x_m1 = (dpc_x == 4'd0) ? 4'd1 : (dpc_x - 4'd1);
wire [3:0] dpc_y_p1 = (dpc_y == 4'd15) ? 4'd14 : (dpc_y + 4'd1);
wire [3:0] dpc_x_p1 = (dpc_x == 4'd15) ? 4'd14 : (dpc_x + 4'd1);
wire [3:0] dpc_y_p2 = (dpc_y > 4'd13) ? (5'd28 - {1'b0, dpc_y}) : (dpc_y + 4'd2);
wire [3:0] dpc_x_p2 = (dpc_x > 4'd13) ? (5'd28 - {1'b0, dpc_x}) : (dpc_x + 4'd2);

wire [2:0] dpc_y_mod5;
wire [2:0] dpc_y_m2_mod5;
wire [2:0] dpc_y_m1_mod5;
wire [2:0] dpc_y_p1_mod5;
wire [2:0] dpc_y_p2_mod5;

ROW_MOD5 U_DPC_C_MOD (.y(dpc_y),    .m(dpc_y_mod5));
ROW_MOD5 U_DPC_M2_MOD(.y(dpc_y_m2), .m(dpc_y_m2_mod5));
ROW_MOD5 U_DPC_M1_MOD(.y(dpc_y_m1), .m(dpc_y_m1_mod5));
ROW_MOD5 U_DPC_P1_MOD(.y(dpc_y_p1), .m(dpc_y_p1_mod5));
ROW_MOD5 U_DPC_P2_MOD(.y(dpc_y_p2), .m(dpc_y_p2_mod5));

reg        dpc1_v, dpc2_v, dpc4_v;
reg [7:0]  dpc1_pix, dpc2_pix, dpc4_pix;
reg [11:0] dpc1_c, dpc2_c, dpc4_c;
reg [11:0] dpc1_h0, dpc1_h1, dpc1_h2, dpc1_h3;
reg [11:0] dpc1_v0, dpc1_v1, dpc1_v2, dpc1_v3;
reg [11:0] dpc1_d10, dpc1_d11, dpc1_d12, dpc1_d13;
reg [11:0] dpc1_d20, dpc1_d21, dpc1_d22, dpc1_d23;
reg [11:0] dpc2_med_h, dpc2_med_v, dpc2_med_d1, dpc2_med_d2;
reg [12:0] dpc2_sad_h, dpc2_sad_v, dpc2_sad_d1, dpc2_sad_d2;
reg [11:0] dpc4_target;

wire [11:0] lsc_b0_xm2 = lsc_buf0[dpc_x_m2];
wire [11:0] lsc_b0_xm1 = lsc_buf0[dpc_x_m1];
wire [11:0] lsc_b0_x   = lsc_buf0[dpc_x];
wire [11:0] lsc_b0_xp1 = lsc_buf0[dpc_x_p1];
wire [11:0] lsc_b0_xp2 = lsc_buf0[dpc_x_p2];
wire [11:0] lsc_b1_xm2 = lsc_buf1[dpc_x_m2];
wire [11:0] lsc_b1_xm1 = lsc_buf1[dpc_x_m1];
wire [11:0] lsc_b1_x   = lsc_buf1[dpc_x];
wire [11:0] lsc_b1_xp1 = lsc_buf1[dpc_x_p1];
wire [11:0] lsc_b1_xp2 = lsc_buf1[dpc_x_p2];
wire [11:0] lsc_b2_xm2 = lsc_buf2[dpc_x_m2];
wire [11:0] lsc_b2_xm1 = lsc_buf2[dpc_x_m1];
wire [11:0] lsc_b2_x   = lsc_buf2[dpc_x];
wire [11:0] lsc_b2_xp1 = lsc_buf2[dpc_x_p1];
wire [11:0] lsc_b2_xp2 = lsc_buf2[dpc_x_p2];
wire [11:0] lsc_b3_xm2 = lsc_buf3[dpc_x_m2];
wire [11:0] lsc_b3_xm1 = lsc_buf3[dpc_x_m1];
wire [11:0] lsc_b3_x   = lsc_buf3[dpc_x];
wire [11:0] lsc_b3_xp1 = lsc_buf3[dpc_x_p1];
wire [11:0] lsc_b3_xp2 = lsc_buf3[dpc_x_p2];
wire [11:0] lsc_b4_xm2 = lsc_buf4[dpc_x_m2];
wire [11:0] lsc_b4_xm1 = lsc_buf4[dpc_x_m1];
wire [11:0] lsc_b4_x   = lsc_buf4[dpc_x];
wire [11:0] lsc_b4_xp1 = lsc_buf4[dpc_x_p1];
wire [11:0] lsc_b4_xp2 = lsc_buf4[dpc_x_p2];

wire [11:0] dpc_rd_c;
wire [11:0] dpc_rd_h0, dpc_rd_h1, dpc_rd_h2, dpc_rd_h3;
wire [11:0] dpc_rd_v0, dpc_rd_v1, dpc_rd_v2, dpc_rd_v3;
wire [11:0] dpc_rd_d10, dpc_rd_d11, dpc_rd_d12, dpc_rd_d13;
wire [11:0] dpc_rd_d20, dpc_rd_d21, dpc_rd_d22, dpc_rd_d23;

SEL5_12 U_LSC_C  (.sel(dpc_y_mod5),    .d0(lsc_b0_x),   .d1(lsc_b1_x),   .d2(lsc_b2_x),   .d3(lsc_b3_x),   .d4(lsc_b4_x),   .y(dpc_rd_c));
SEL5_12 U_LSC_H0 (.sel(dpc_y_mod5),    .d0(lsc_b0_xm2), .d1(lsc_b1_xm2), .d2(lsc_b2_xm2), .d3(lsc_b3_xm2), .d4(lsc_b4_xm2), .y(dpc_rd_h0));
SEL5_12 U_LSC_H1 (.sel(dpc_y_mod5),    .d0(lsc_b0_xm1), .d1(lsc_b1_xm1), .d2(lsc_b2_xm1), .d3(lsc_b3_xm1), .d4(lsc_b4_xm1), .y(dpc_rd_h1));
SEL5_12 U_LSC_H2 (.sel(dpc_y_mod5),    .d0(lsc_b0_xp1), .d1(lsc_b1_xp1), .d2(lsc_b2_xp1), .d3(lsc_b3_xp1), .d4(lsc_b4_xp1), .y(dpc_rd_h2));
SEL5_12 U_LSC_H3 (.sel(dpc_y_mod5),    .d0(lsc_b0_xp2), .d1(lsc_b1_xp2), .d2(lsc_b2_xp2), .d3(lsc_b3_xp2), .d4(lsc_b4_xp2), .y(dpc_rd_h3));
SEL5_12 U_LSC_V0 (.sel(dpc_y_m2_mod5), .d0(lsc_b0_x),   .d1(lsc_b1_x),   .d2(lsc_b2_x),   .d3(lsc_b3_x),   .d4(lsc_b4_x),   .y(dpc_rd_v0));
SEL5_12 U_LSC_V1 (.sel(dpc_y_m1_mod5), .d0(lsc_b0_x),   .d1(lsc_b1_x),   .d2(lsc_b2_x),   .d3(lsc_b3_x),   .d4(lsc_b4_x),   .y(dpc_rd_v1));
SEL5_12 U_LSC_V2 (.sel(dpc_y_p1_mod5), .d0(lsc_b0_x),   .d1(lsc_b1_x),   .d2(lsc_b2_x),   .d3(lsc_b3_x),   .d4(lsc_b4_x),   .y(dpc_rd_v2));
SEL5_12 U_LSC_V3 (.sel(dpc_y_p2_mod5), .d0(lsc_b0_x),   .d1(lsc_b1_x),   .d2(lsc_b2_x),   .d3(lsc_b3_x),   .d4(lsc_b4_x),   .y(dpc_rd_v3));
SEL5_12 U_LSC_D10(.sel(dpc_y_m2_mod5), .d0(lsc_b0_xm2), .d1(lsc_b1_xm2), .d2(lsc_b2_xm2), .d3(lsc_b3_xm2), .d4(lsc_b4_xm2), .y(dpc_rd_d10));
SEL5_12 U_LSC_D11(.sel(dpc_y_m1_mod5), .d0(lsc_b0_xm1), .d1(lsc_b1_xm1), .d2(lsc_b2_xm1), .d3(lsc_b3_xm1), .d4(lsc_b4_xm1), .y(dpc_rd_d11));
SEL5_12 U_LSC_D12(.sel(dpc_y_p1_mod5), .d0(lsc_b0_xp1), .d1(lsc_b1_xp1), .d2(lsc_b2_xp1), .d3(lsc_b3_xp1), .d4(lsc_b4_xp1), .y(dpc_rd_d12));
SEL5_12 U_LSC_D13(.sel(dpc_y_p2_mod5), .d0(lsc_b0_xp2), .d1(lsc_b1_xp2), .d2(lsc_b2_xp2), .d3(lsc_b3_xp2), .d4(lsc_b4_xp2), .y(dpc_rd_d13));
SEL5_12 U_LSC_D20(.sel(dpc_y_m2_mod5), .d0(lsc_b0_xp2), .d1(lsc_b1_xp2), .d2(lsc_b2_xp2), .d3(lsc_b3_xp2), .d4(lsc_b4_xp2), .y(dpc_rd_d20));
SEL5_12 U_LSC_D21(.sel(dpc_y_m1_mod5), .d0(lsc_b0_xp1), .d1(lsc_b1_xp1), .d2(lsc_b2_xp1), .d3(lsc_b3_xp1), .d4(lsc_b4_xp1), .y(dpc_rd_d21));
SEL5_12 U_LSC_D22(.sel(dpc_y_p1_mod5), .d0(lsc_b0_xm1), .d1(lsc_b1_xm1), .d2(lsc_b2_xm1), .d3(lsc_b3_xm1), .d4(lsc_b4_xm1), .y(dpc_rd_d22));
SEL5_12 U_LSC_D23(.sel(dpc_y_p2_mod5), .d0(lsc_b0_xm2), .d1(lsc_b1_xm2), .d2(lsc_b2_xm2), .d3(lsc_b3_xm2), .d4(lsc_b4_xm2), .y(dpc_rd_d23));

wire [11:0] med_h, med_v, med_d1, med_d2;
wire [12:0] sad_h, sad_v, sad_d1, sad_d2;
DPC_STAT4 U_STAT_H (.a(dpc1_h0),  .b(dpc1_h1),  .c(dpc1_h2),  .d(dpc1_h3),  .med(med_h),  .sad(sad_h));
DPC_STAT4 U_STAT_V (.a(dpc1_v0),  .b(dpc1_v1),  .c(dpc1_v2),  .d(dpc1_v3),  .med(med_v),  .sad(sad_v));
DPC_STAT4 U_STAT_D1(.a(dpc1_d10), .b(dpc1_d11), .c(dpc1_d12), .d(dpc1_d13), .med(med_d1), .sad(sad_d1));
DPC_STAT4 U_STAT_D2(.a(dpc1_d20), .b(dpc1_d21), .c(dpc1_d22), .d(dpc1_d23), .med(med_d2), .sad(sad_d2));

wire h_min  = (dpc2_sad_h <= dpc2_sad_v) && (dpc2_sad_h <= dpc2_sad_d1) && (dpc2_sad_h <= dpc2_sad_d2);
wire v_min  = (!h_min) && (dpc2_sad_v <= dpc2_sad_d1) && (dpc2_sad_v <= dpc2_sad_d2);
wire d1_min = (!h_min) && (!v_min) && (dpc2_sad_d1 <= dpc2_sad_d2);
wire [11:0] dpc_target = h_min ? dpc2_med_h : v_min ? dpc2_med_v : d1_min ? dpc2_med_d1 : dpc2_med_d2;
wire [11:0] dpc_diff = (dpc4_c > dpc4_target) ? (dpc4_c - dpc4_target) : (dpc4_target - dpc4_c);
wire [11:0] dpc_out = (dpc_diff > 12'd320) ? dpc4_target : dpc4_c;
wire [3:0] dpc4_y = dpc4_pix[7:4];
wire [1:0] dpc4_y_mod4;

ROW_MOD3 U_DPC_WR_MOD(.y(dpc4_y), .m(dpc4_y_mod4));

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dpc1_v <= 1'b0;
        dpc2_v <= 1'b0;
        dpc4_v <= 1'b0;
    end
    else begin
        dpc1_v <= dpc_sched_v;
        dpc2_v <= dpc1_v;
        dpc4_v <= dpc2_v;
    end
end

always @(posedge clk) begin
    dpc1_pix <= dpc_sched_pix;
    dpc1_c <= dpc_rd_c;
    dpc1_h0 <= dpc_rd_h0;   dpc1_h1 <= dpc_rd_h1;   dpc1_h2 <= dpc_rd_h2;   dpc1_h3 <= dpc_rd_h3;
    dpc1_v0 <= dpc_rd_v0;   dpc1_v1 <= dpc_rd_v1;   dpc1_v2 <= dpc_rd_v2;   dpc1_v3 <= dpc_rd_v3;
    dpc1_d10 <= dpc_rd_d10; dpc1_d11 <= dpc_rd_d11; dpc1_d12 <= dpc_rd_d12; dpc1_d13 <= dpc_rd_d13;
    dpc1_d20 <= dpc_rd_d20; dpc1_d21 <= dpc_rd_d21; dpc1_d22 <= dpc_rd_d22; dpc1_d23 <= dpc_rd_d23;

    dpc2_pix <= dpc1_pix;
    dpc2_c <= dpc1_c;
    dpc2_med_h <= med_h;
    dpc2_med_v <= med_v;
    dpc2_med_d1 <= med_d1;
    dpc2_med_d2 <= med_d2;
    dpc2_sad_h <= sad_h;
    dpc2_sad_v <= sad_v;
    dpc2_sad_d1 <= sad_d1;
    dpc2_sad_d2 <= sad_d2;

    dpc4_pix <= dpc2_pix;
    dpc4_c <= dpc2_c;
    dpc4_target <= dpc_target;
end

always @(posedge clk) begin
    if (dpc4_v) begin
        case (dpc4_y_mod4)
            2'd0: dpc_buf0[dpc4_pix[3:0]] <= dpc_out;
            2'd1: dpc_buf1[dpc4_pix[3:0]] <= dpc_out;
            default: dpc_buf2[dpc4_pix[3:0]] <= dpc_out;
        endcase
    end
end

//==============================
//  Demosaic / CCM pipeline
//==============================
wire [8:0]  dm_sched_linear = pre_cnt - DM_START;
wire        dm_sched_v = pre_run && (pre_cnt >= DM_START) && (dm_sched_linear < TOTAL_PIX);
wire [7:0]  dm_sched_pix = dm_sched_linear[7:0];
wire [3:0]  dm_y = dm_sched_pix[7:4];
wire [3:0]  dm_x = dm_sched_pix[3:0];

wire [3:0] dm_y_m1 = (dm_y == 4'd0)  ? 4'd1  : (dm_y - 4'd1);
wire [3:0] dm_x_m1 = (dm_x == 4'd0)  ? 4'd1  : (dm_x - 4'd1);
wire [3:0] dm_y_p1 = (dm_y == 4'd15) ? 4'd14 : (dm_y + 4'd1);
wire [3:0] dm_x_p1 = (dm_x == 4'd15) ? 4'd14 : (dm_x + 4'd1);

wire [1:0] dm_y_mod4;
wire [1:0] dm_y_m1_mod4;
wire [1:0] dm_y_p1_mod4;

ROW_MOD3 U_DM_C_MOD (.y(dm_y),    .m(dm_y_mod4));
ROW_MOD3 U_DM_M1_MOD(.y(dm_y_m1), .m(dm_y_m1_mod4));
ROW_MOD3 U_DM_P1_MOD(.y(dm_y_p1), .m(dm_y_p1_mod4));

wire [11:0] dm_b0_xm1 = dpc_buf0[dm_x_m1];
wire [11:0] dm_b0_x   = dpc_buf0[dm_x];
wire [11:0] dm_b0_xp1 = dpc_buf0[dm_x_p1];
wire [11:0] dm_b1_xm1 = dpc_buf1[dm_x_m1];
wire [11:0] dm_b1_x   = dpc_buf1[dm_x];
wire [11:0] dm_b1_xp1 = dpc_buf1[dm_x_p1];
wire [11:0] dm_b2_xm1 = dpc_buf2[dm_x_m1];
wire [11:0] dm_b2_x   = dpc_buf2[dm_x];
wire [11:0] dm_b2_xp1 = dpc_buf2[dm_x_p1];

wire [11:0] dm_rd_w  = (dm_y_mod4 == 2'd0) ? dm_b0_xm1 :
                       (dm_y_mod4 == 2'd1) ? dm_b1_xm1 :
                       dm_b2_xm1;
wire [11:0] dm_rd_c  = (dm_y_mod4 == 2'd0) ? dm_b0_x :
                       (dm_y_mod4 == 2'd1) ? dm_b1_x :
                       dm_b2_x;
wire [11:0] dm_rd_e  = (dm_y_mod4 == 2'd0) ? dm_b0_xp1 :
                       (dm_y_mod4 == 2'd1) ? dm_b1_xp1 :
                       dm_b2_xp1;

wire [11:0] dm_rd_nw = (dm_y_m1_mod4 == 2'd0) ? dm_b0_xm1 :
                       (dm_y_m1_mod4 == 2'd1) ? dm_b1_xm1 :
                       dm_b2_xm1;
wire [11:0] dm_rd_n  = (dm_y_m1_mod4 == 2'd0) ? dm_b0_x :
                       (dm_y_m1_mod4 == 2'd1) ? dm_b1_x :
                       dm_b2_x;
wire [11:0] dm_rd_ne = (dm_y_m1_mod4 == 2'd0) ? dm_b0_xp1 :
                       (dm_y_m1_mod4 == 2'd1) ? dm_b1_xp1 :
                       dm_b2_xp1;

wire [11:0] dm_rd_sw = (dm_y_p1_mod4 == 2'd0) ? dm_b0_xm1 :
                       (dm_y_p1_mod4 == 2'd1) ? dm_b1_xm1 :
                       dm_b2_xm1;
wire [11:0] dm_rd_s  = (dm_y_p1_mod4 == 2'd0) ? dm_b0_x :
                       (dm_y_p1_mod4 == 2'd1) ? dm_b1_x :
                       dm_b2_x;
wire [11:0] dm_rd_se = (dm_y_p1_mod4 == 2'd0) ? dm_b0_xp1 :
                       (dm_y_p1_mod4 == 2'd1) ? dm_b1_xp1 :
                       dm_b2_xp1;

reg        dm1_v, dm2_v, dm3_v, dm4_v;
reg [7:0]  dm1_pix, dm2_pix;
reg        dm3_last, dm4_last;
reg [11:0] dm1_c, dm1_n, dm1_s, dm1_w, dm1_e, dm1_nw, dm1_ne, dm1_sw, dm1_se;
reg [11:0] dm2_r, dm2_g, dm2_b;
reg [11:0] dm3_r, dm3_g, dm3_b;
reg signed [19:0] dm3_corr_r, dm3_corr_g, dm3_corr_b;
reg signed [13:0] dm4_r_calc, dm4_g_calc, dm4_b_calc;

wire [18:0] dm2_r76 = ({7'd0, dm2_r} << 6) + ({7'd0, dm2_r} << 3) + ({7'd0, dm2_r} << 2);
wire [18:0] dm2_g76 = ({7'd0, dm2_g} << 6) + ({7'd0, dm2_g} << 3) + ({7'd0, dm2_g} << 2);
wire [18:0] dm2_b76 = ({7'd0, dm2_b} << 6) + ({7'd0, dm2_b} << 3) + ({7'd0, dm2_b} << 2);
wire [17:0] dm2_r50 = ({6'd0, dm2_r} << 5) + ({6'd0, dm2_r} << 4) + ({6'd0, dm2_r} << 1);
wire [17:0] dm2_g50 = ({6'd0, dm2_g} << 5) + ({6'd0, dm2_g} << 4) + ({6'd0, dm2_g} << 1);
wire [17:0] dm2_b50 = ({6'd0, dm2_b} << 5) + ({6'd0, dm2_b} << 4) + ({6'd0, dm2_b} << 1);

wire dm_is_r  = !dm1_pix[4] && !dm1_pix[0];
wire dm_is_gr = !dm1_pix[4] &&  dm1_pix[0];
wire dm_is_gb =  dm1_pix[4] && !dm1_pix[0];

wire [12:0] dm_ns_sum = {1'b0, dm1_n} + {1'b0, dm1_s};
wire [12:0] dm_we_sum = {1'b0, dm1_w} + {1'b0, dm1_e};
wire [12:0] dm_nw_ne_sum = {1'b0, dm1_nw} + {1'b0, dm1_ne};
wire [12:0] dm_sw_se_sum = {1'b0, dm1_sw} + {1'b0, dm1_se};
wire [13:0] dm_cross_sum = {1'b0, dm_ns_sum} + {1'b0, dm_we_sum};
wire [13:0] dm_diag_sum = {1'b0, dm_nw_ne_sum} + {1'b0, dm_sw_se_sum};

reg [11:0] dm_r_comb, dm_g_comb, dm_b_comb;
always @(*) begin
    if (dm_is_r) begin
        dm_r_comb = dm1_c;
        dm_g_comb = dm_cross_sum[13:2];
        dm_b_comb = dm_diag_sum[13:2];
    end
    else if (!dm_is_gr && !dm_is_gb) begin
        dm_r_comb = dm_diag_sum[13:2];
        dm_g_comb = dm_cross_sum[13:2];
        dm_b_comb = dm1_c;
    end
    else if (dm_is_gr) begin
        dm_r_comb = dm_we_sum[12:1];
        dm_g_comb = dm1_c;
        dm_b_comb = dm_ns_sum[12:1];
    end
    else begin
        dm_r_comb = dm_ns_sum[12:1];
        dm_g_comb = dm1_c;
        dm_b_comb = dm_we_sum[12:1];
    end
end

wire signed [13:0] dm3_corr_r_q = dm3_corr_r >>> 10;
wire signed [13:0] dm3_corr_g_q = dm3_corr_g >>> 10;
wire signed [13:0] dm3_corr_b_q = dm3_corr_b >>> 10;
wire [7:0] dm_out_r = (dm4_r_calc < 14'sd0) ? 8'd0 : (dm4_r_calc >= 14'sd4080) ? 8'd255 : dm4_r_calc[11:4];
wire [7:0] dm_out_g = (dm4_g_calc < 14'sd0) ? 8'd0 : (dm4_g_calc >= 14'sd4080) ? 8'd255 : dm4_g_calc[11:4];
wire [7:0] dm_out_b = (dm4_b_calc < 14'sd0) ? 8'd0 : (dm4_b_calc >= 14'sd4080) ? 8'd255 : dm4_b_calc[11:4];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        dm1_v <= 1'b0;
        dm2_v <= 1'b0;
        dm3_v <= 1'b0;
        dm4_v <= 1'b0;
        out_pipe_v <= 1'b0;
    end
    else begin
        dm1_v <= dm_sched_v;
        dm2_v <= dm1_v;
        dm3_v <= dm2_v;
        dm4_v <= dm3_v;
        out_pipe_v <= dm4_v;
    end
end

always @(posedge clk) begin
    dm1_pix <= dm_sched_pix;
    dm1_c <= dm_rd_c;   dm1_n <= dm_rd_n;   dm1_s <= dm_rd_s;   dm1_w <= dm_rd_w;   dm1_e <= dm_rd_e;
    dm1_nw <= dm_rd_nw; dm1_ne <= dm_rd_ne; dm1_sw <= dm_rd_sw; dm1_se <= dm_rd_se;

    dm2_pix <= dm1_pix;
    dm2_r <= dm_r_comb;
    dm2_g <= dm_g_comb;
    dm2_b <= dm_b_comb;

    dm3_last <= (dm2_pix == 8'd255);
    dm3_r <= dm2_r;
    dm3_g <= dm2_g;
    dm3_b <= dm2_b;
    dm3_corr_r <= $signed({1'b0, dm2_r76}) - $signed({2'b0, dm2_g50}) - $signed({2'b0, dm2_b50}) + 20'sd512;
    dm3_corr_g <= -$signed({2'b0, dm2_r50}) + $signed({1'b0, dm2_g76}) - $signed({2'b0, dm2_b50}) + 20'sd512;
    dm3_corr_b <= -$signed({2'b0, dm2_r50}) - $signed({2'b0, dm2_g50}) + $signed({1'b0, dm2_b76}) + 20'sd512;

    dm4_last <= dm3_last;
    dm4_r_calc <= $signed({2'b0, dm3_r}) + dm3_corr_r_q;
    dm4_g_calc <= $signed({2'b0, dm3_g}) + dm3_corr_g_q;
    dm4_b_calc <= $signed({2'b0, dm3_b}) + dm3_corr_b_q;

    out_pipe_last <= dm4_last;
    out_pipe_r <= dm_out_r;
    out_pipe_g <= dm_out_g;
    out_pipe_b <= dm_out_b;
end

endmodule

module SRAM4096X12(clk, addr, din, web, oe, cs, dout);
input clk;
input [11:0] addr;
input [11:0] din;
input web;
input oe;
input cs;
output [11:0] dout;

SUMA180_4096X12 U_MEM(
    .A0(addr[0]), .A1(addr[1]), .A2(addr[2]), .A3(addr[3]),
    .A4(addr[4]), .A5(addr[5]), .A6(addr[6]), .A7(addr[7]),
    .A8(addr[8]), .A9(addr[9]), .A10(addr[10]), .A11(addr[11]),
    .DO0(dout[0]), .DO1(dout[1]), .DO2(dout[2]), .DO3(dout[3]),
    .DO4(dout[4]), .DO5(dout[5]), .DO6(dout[6]), .DO7(dout[7]),
    .DO8(dout[8]), .DO9(dout[9]), .DO10(dout[10]), .DO11(dout[11]),
    .DI0(din[0]), .DI1(din[1]), .DI2(din[2]), .DI3(din[3]),
    .DI4(din[4]), .DI5(din[5]), .DI6(din[6]), .DI7(din[7]),
    .DI8(din[8]), .DI9(din[9]), .DI10(din[10]), .DI11(din[11]),
    .CK(clk), .WEB(web), .OE(oe), .CS(cs)
);
endmodule

module LSC_GXY_LUT(pix, gain_delta);
input [7:0] pix;
output reg [9:0] gain_delta;

wire [3:0] pix_y = pix[7:4];
wire [3:0] pix_x = pix[3:0];
wire [7:0] lut_pix = (pix_y > pix_x) ? {pix_x, pix_y} : pix;

always @(*) begin
    case (lut_pix)
        8'h00: gain_delta = 10'd576;
        8'h01: gain_delta = 10'd449;
        8'h02: gain_delta = 10'd509;
        8'h03: gain_delta = 10'd396;
        8'h04: gain_delta = 10'd459;
        8'h05: gain_delta = 10'd356;
        8'h06: gain_delta = 10'd426;
        8'h07: gain_delta = 10'd336;
        8'h08: gain_delta = 10'd426;
        8'h09: gain_delta = 10'd336;
        8'h0A: gain_delta = 10'd443;
        8'h0B: gain_delta = 10'd376;
        8'h0C: gain_delta = 10'd476;
        8'h0D: gain_delta = 10'd423;
        8'h0E: gain_delta = 10'd543;
        8'h0F: gain_delta = 10'd449;
        8'h11: gain_delta = 10'd592;
        8'h12: gain_delta = 10'd383;
        8'h13: gain_delta = 10'd503;
        8'h14: gain_delta = 10'd327;
        8'h15: gain_delta = 10'd445;
        8'h16: gain_delta = 10'd283;
        8'h17: gain_delta = 10'd416;
        8'h18: gain_delta = 10'd283;
        8'h19: gain_delta = 10'd416;
        8'h1A: gain_delta = 10'd305;
        8'h1B: gain_delta = 10'd474;
        8'h1C: gain_delta = 10'd350;
        8'h1D: gain_delta = 10'd547;
        8'h1E: gain_delta = 10'd416;
        8'h1F: gain_delta = 10'd592;
        8'h22: gain_delta = 10'd420;
        8'h23: gain_delta = 10'd302;
        8'h24: gain_delta = 10'd348;
        8'h25: gain_delta = 10'd253;
        8'h26: gain_delta = 10'd292;
        8'h27: gain_delta = 10'd229;
        8'h28: gain_delta = 10'd292;
        8'h29: gain_delta = 10'd229;
        8'h2A: gain_delta = 10'd320;
        8'h2B: gain_delta = 10'd278;
        8'h2C: gain_delta = 10'd376;
        8'h2D: gain_delta = 10'd342;
        8'h2E: gain_delta = 10'd465;
        8'h2F: gain_delta = 10'd383;
        8'h33: gain_delta = 10'd396;
        8'h34: gain_delta = 10'd229;
        8'h35: gain_delta = 10'd329;
        8'h36: gain_delta = 10'd176;
        8'h37: gain_delta = 10'd296;
        8'h38: gain_delta = 10'd176;
        8'h39: gain_delta = 10'd296;
        8'h3A: gain_delta = 10'd203;
        8'h3B: gain_delta = 10'd363;
        8'h3C: gain_delta = 10'd256;
        8'h3D: gain_delta = 10'd449;
        8'h3E: gain_delta = 10'd350;
        8'h3F: gain_delta = 10'd503;
        8'h44: gain_delta = 10'd254;
        8'h45: gain_delta = 10'd167;
        8'h46: gain_delta = 10'd176;
        8'h47: gain_delta = 10'd136;
        8'h48: gain_delta = 10'd176;
        8'h49: gain_delta = 10'd136;
        8'h4A: gain_delta = 10'd215;
        8'h4B: gain_delta = 10'd198;
        8'h4C: gain_delta = 10'd293;
        8'h4D: gain_delta = 10'd278;
        8'h4E: gain_delta = 10'd404;
        8'h4F: gain_delta = 10'd327;
        8'h55: gain_delta = 10'd231;
        8'h56: gain_delta = 10'd96;
        8'h57: gain_delta = 10'd182;
        8'h58: gain_delta = 10'd96;
        8'h59: gain_delta = 10'd182;
        8'h5A: gain_delta = 10'd131;
        8'h5B: gain_delta = 10'd280;
        8'h5C: gain_delta = 10'd203;
        8'h5D: gain_delta = 10'd387;
        8'h5E: gain_delta = 10'd305;
        8'h5F: gain_delta = 10'd445;
        8'h66: gain_delta = 10'd76;
        8'h67: gain_delta = 10'd56;
        8'h68: gain_delta = 10'd76;
        8'h69: gain_delta = 10'd56;
        8'h6A: gain_delta = 10'd126;
        8'h6B: gain_delta = 10'd136;
        8'h6C: gain_delta = 10'd226;
        8'h6D: gain_delta = 10'd229;
        8'h6E: gain_delta = 10'd360;
        8'h6F: gain_delta = 10'd283;
        8'h77: gain_delta = 10'd126;
        8'h78: gain_delta = 10'd56;
        8'h79: gain_delta = 10'd126;
        8'h7A: gain_delta = 10'd96;
        8'h7B: gain_delta = 10'd240;
        8'h7C: gain_delta = 10'd176;
        8'h7D: gain_delta = 10'd356;
        8'h7E: gain_delta = 10'd283;
        8'h7F: gain_delta = 10'd416;
        8'h88: gain_delta = 10'd76;
        8'h89: gain_delta = 10'd56;
        8'h8A: gain_delta = 10'd126;
        8'h8B: gain_delta = 10'd136;
        8'h8C: gain_delta = 10'd226;
        8'h8D: gain_delta = 10'd229;
        8'h8E: gain_delta = 10'd360;
        8'h8F: gain_delta = 10'd283;
        8'h99: gain_delta = 10'd126;
        8'h9A: gain_delta = 10'd96;
        8'h9B: gain_delta = 10'd240;
        8'h9C: gain_delta = 10'd176;
        8'h9D: gain_delta = 10'd356;
        8'h9E: gain_delta = 10'd283;
        8'h9F: gain_delta = 10'd416;
        8'hAA: gain_delta = 10'd170;
        8'hAB: gain_delta = 10'd167;
        8'hAC: gain_delta = 10'd259;
        8'hAD: gain_delta = 10'd253;
        8'hAE: gain_delta = 10'd382;
        8'hAF: gain_delta = 10'd305;
        8'hBB: gain_delta = 10'd322;
        8'hBC: gain_delta = 10'd229;
        8'hBD: gain_delta = 10'd418;
        8'hBE: gain_delta = 10'd327;
        8'hBF: gain_delta = 10'd474;
        8'hCC: gain_delta = 10'd326;
        8'hCD: gain_delta = 10'd302;
        8'hCE: gain_delta = 10'd426;
        8'hCF: gain_delta = 10'd350;
        8'hDD: gain_delta = 10'd498;
        8'hDE: gain_delta = 10'd383;
        8'hDF: gain_delta = 10'd547;
        8'hEE: gain_delta = 10'd504;
        8'hEF: gain_delta = 10'd416;
        default: gain_delta = 10'd592;
    endcase
end
endmodule

module SEL5_12(sel, d0, d1, d2, d3, d4, y);
input [2:0] sel;
input [11:0] d0, d1, d2, d3, d4;
output reg [11:0] y;

always @(*) begin
    case (sel)
        3'd0: y = d0;
        3'd1: y = d1;
        3'd2: y = d2;
        3'd3: y = d3;
        default: y = d4;
    endcase
end
endmodule

module ROW_MOD5(y, m);
input [3:0] y;
output reg [2:0] m;

always @(*) begin
    case (y)
        4'd0,  4'd5,  4'd10, 4'd15: m = 3'd0;
        4'd1,  4'd6,  4'd11:        m = 3'd1;
        4'd2,  4'd7,  4'd12:        m = 3'd2;
        4'd3,  4'd8,  4'd13:        m = 3'd3;
        default:                     m = 3'd4;
    endcase
end
endmodule

module ROW_MOD3(y, m);
input [3:0] y;
output reg [1:0] m;

always @(*) begin
    case (y)
        4'd0, 4'd3, 4'd6, 4'd9, 4'd12, 4'd15: m = 2'd0;
        4'd1, 4'd4, 4'd7, 4'd10, 4'd13:       m = 2'd1;
        default:                                m = 2'd2;
    endcase
end
endmodule

module DPC_STAT4(a, b, c, d, med, sad);
input [11:0] a, b, c, d;
output [11:0] med;
output [12:0] sad;

wire [11:0] ab_min = (a < b) ? a : b;
wire [11:0] ab_max = (a < b) ? b : a;
wire [11:0] cd_min = (c < d) ? c : d;
wire [11:0] cd_max = (c < d) ? d : c;
wire [11:0] min_val = (ab_min < cd_min) ? ab_min : cd_min;
wire [11:0] max_val = (ab_max < cd_max) ? cd_max : ab_max;
wire [11:0] mid1 = (ab_min < cd_min) ? cd_min : ab_min;
wire [11:0] mid2 = (ab_max < cd_max) ? ab_max : cd_max;
wire [12:0] mid_sum = {1'b0, mid1} + {1'b0, mid2};
wire [11:0] edge_diff = max_val - min_val;
wire [11:0] mid_diff = (mid2 > mid1) ? (mid2 - mid1) : (mid1 - mid2);

assign med = mid_sum[12:1];
assign sad = {1'b0, edge_diff} + {1'b0, mid_diff};
endmodule
