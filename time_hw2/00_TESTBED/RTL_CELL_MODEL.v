`timescale 1ns/1ps

// RTL FUNCTIONAL MODEL ONLY.
// These small delays keep the delay-based DLL observable during RTL
// integration tests.  They do not model load, slew, PVT, timing checks or
// extracted interconnect.  GATE/POST simulations must use tsmc090.v + SDF.

module CLKBUFX4 (Y, A);
    output Y;
    input  A;
    assign #(0.0300, 0.0399) Y = A;
endmodule

module CLKINVX4 (Y, A);
    output Y;
    input  A;
    assign #(0.0200, 0.0200) Y = ~A;
endmodule

module TBUFX16 (Y, A, OE);
    output Y;
    input  A, OE;
    assign #(0.0428, 0.0614) Y = OE ? A : 1'bz;
endmodule

module NAND2X4 (Y, A, B);
    output Y;
    input  A, B;
    assign #(0.0129, 0.0115) Y = ~(A & B);
endmodule

module AND2X8 (Y, A, B);
    output Y;
    input  A, B;
    assign #0.0150 Y = A & B;
endmodule

module DFFRX2 (Q, QN, D, CK, RN);
    output Q, QN;
    input  D, CK, RN;
    reg q;

    always @(posedge CK or negedge RN) begin
        if (!RN)
            q <= #0.0200 1'b0;
        else
            q <= #0.0980 D;
    end

    assign Q  = q;
    assign QN = ~q;
endmodule

module DFFRHQX1 (Q, D, CK, RN);
    output Q;
    input  D, CK, RN;
    reg q;

    always @(posedge CK or negedge RN) begin
        if (!RN)
            q <= #0.0847 1'b0;
        else
            q <= #0.0807 D;
    end

    assign Q = q;
endmodule

