`timescale 1ns/1ps
// Deliberately wrong DUT: periodic phase looks correct, physical delay is not.
// Used to verify that PATTERN rejects a zero-cycle or two-cycle false lock.
`include "PATTERN.v"
`ifndef FAKE_O2_DELAY
`define FAKE_O2_DELAY 0.0
`endif
`timescale 1ns/1ps
module TESTBED;
    wire clk_in, rst_n, clk_o1;
    reg clk_o2;
    reg locked;
    integer elapsed;
    assign #0.5 clk_o1 = clk_in;
    // Transport-style edge delay: do not inertially erase a 0.5 ns pulse
    // when testing a two-period propagation delay.
    always @(clk_in) clk_o2 <= #(`FAKE_O2_DELAY) clk_in;
    always @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            elapsed <= 0;
            locked <= 0;
        end
        else begin
            elapsed <= elapsed + 1;
            if (elapsed == 20) locked <= 1;
        end
    end
    PATTERN u_PATTERN(.clk_in(clk_in), .rst_n(rst_n),
        .clk_o1(clk_o1), .clk_o2(clk_o2), .locked(locked));
endmodule
