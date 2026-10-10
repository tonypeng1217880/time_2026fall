`timescale 1ns/1ps
// SIMULATION ONLY. Approximate educational models for integration smoke tests.
// NOT TSMC models; no load/slew, setup/hold, recovery/removal or PVT accuracy.
// Never include this file in synthesis or the course library/SDF simulation.
`ifndef SMOKE_SCALE
`define SMOKE_SCALE 1.0
`endif
module CLKBUFX4(input A, output Y);
    assign #(0.0300 * `SMOKE_SCALE, 0.0399 * `SMOKE_SCALE) Y = A;
endmodule
module TBUFX16(input A, input OE, output Y);
    assign #(0.0428 * `SMOKE_SCALE, 0.0614 * `SMOKE_SCALE) Y = OE ? A : 1'bz;
endmodule
module NAND2X4(input A, input B, output Y);
    assign #(0.0129, 0.0115) Y = ~(A & B);
endmodule
module AND2X8(input A, input B, output Y);
    assign #(0.015) Y = A & B;
endmodule
module DFFRX2(input D, input CK, input RN, output Q, output QN);
    reg q;
    always @(posedge CK or negedge RN)
        if (!RN) q <= #0.020 1'b0;
        else     q <= #0.098 D;
    assign Q = q;
    assign QN = ~q;
endmodule
