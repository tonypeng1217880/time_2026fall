`timescale 1ns/1ps

`include "PATTERN.v"

`ifdef RTL
    `include "gcd.v"
`elsif GATE
    `include "gcd_SYN.v"
`elsif POST
    `include "gcd_APR.v"
`endif

module TESTBED;

wire        clk;
wire        rst_n;
wire  [9:0] data_in;
wire        in_valid;
wire [10:0] pow_out;
wire        out_valid;

initial begin
`ifdef RTL
    $fsdbDumpfile("pow_rtl.fsdb");
    $fsdbDumpvars(0, TESTBED);
`elsif GATE
    $fsdbDumpfile("pow_gate.fsdb");
    $fsdbDumpvars(0, TESTBED);
    $sdf_annotate("gcd_SYN.sdf", u_gcd);
`elsif POST
    $fsdbDumpfile("pow_post.fsdb");
    $fsdbDumpvars(0, TESTBED);
    $sdf_annotate("gcd_APR.sdf", u_gcd);
`endif
end

gcd u_gcd (
    .pow_out  (pow_out),
    .out_valid(out_valid),
    .clk      (clk),
    .rst_n    (rst_n),
    .data_in  (data_in),
    .in_valid (in_valid)
);

PATTERN u_PATTERN (
    .clk      (clk),
    .rst_n    (rst_n),
    .data_in  (data_in),
    .in_valid (in_valid),
    .pow_out  (pow_out),
    .out_valid(out_valid)
);

endmodule
