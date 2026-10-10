`timescale 1ns/1ps

`include "PATTERN.v"

`ifdef RTL
    `include "gcd.v"
`elsif GATE
    `include "gcd_SYN.v"
`elsif POST
    `include "gcd_APR.v"
`endif

`timescale 1ns/1ps
module TESTBED;

`ifdef PD_TEST
wire ref_clk;
wire fb_clk;
wire rst_n;
wire lead_lag;

pd u_dut (
    .ref_clk  (ref_clk),
    .fb_clk   (fb_clk),
    .rst_n    (rst_n),
    .lead_lag (lead_lag)
);

PATTERN u_PATTERN (
    .ref_clk  (ref_clk),
    .fb_clk   (fb_clk),
    .rst_n    (rst_n),
    .lead_lag (lead_lag)
);

initial begin
    `ifndef NO_FSDB
    `ifdef RTL
        $fsdbDumpfile("pd_rtl.fsdb");
    `elsif GATE
        $fsdbDumpfile("pd_gate.fsdb");
    `else
        $fsdbDumpfile("pd_post.fsdb");
    `endif
    $fsdbDumpvars(0, TESTBED);
    `endif
end

`elsif TDL_TEST
wire                         tdl_in;
wire [`TDL_CODE_WIDTH-1:0]   tdl_code;
wire                         tdl_out;

tdl u_dut (
    .tdl_in   (tdl_in),
    .tdl_code (tdl_code),
    .tdl_out  (tdl_out)
);

PATTERN u_PATTERN (
    .tdl_in   (tdl_in),
    .tdl_code (tdl_code),
    .tdl_out  (tdl_out)
);

initial begin
    `ifndef NO_FSDB
    `ifdef RTL
        $fsdbDumpfile("tdl_rtl.fsdb");
    `elsif GATE
        $fsdbDumpfile("tdl_gate.fsdb");
    `else
        $fsdbDumpfile("tdl_post.fsdb");
    `endif
    $fsdbDumpvars(0, TESTBED);
    `endif
end

`else
wire clk_in;
wire rst_n;
wire clk_o1;
wire clk_o2;
wire locked;

gcd u_gcd (
    .clk_in (clk_in),
    .rst_n  (rst_n),
    .clk_o1 (clk_o1),
    .clk_o2 (clk_o2),
    .locked (locked)
);

PATTERN u_PATTERN (
    .clk_in (clk_in),
    .rst_n  (rst_n),
    .clk_o1 (clk_o1),
    .clk_o2 (clk_o2),
    .locked (locked)
);

initial begin
    `ifdef RTL
        `ifndef NO_FSDB
        $fsdbDumpfile("dll_rtl.fsdb");
        $fsdbDumpvars(0, TESTBED);
        `endif
    `elsif GATE
        `ifndef NO_FSDB
        $fsdbDumpfile("dll_gate.fsdb");
        $fsdbDumpvars(0, TESTBED);
        `endif
        $sdf_annotate("gcd_SYN.sdf", u_gcd);
    `elsif POST
        `ifndef NO_FSDB
        $fsdbDumpfile("dll_post.fsdb");
        $fsdbDumpvars(0, TESTBED);
        `endif
        $sdf_annotate("gcd_APR.sdf", u_gcd);
    `endif
end
`endif

endmodule
