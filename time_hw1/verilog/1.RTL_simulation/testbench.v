`timescale 1ns / 100ps
module testbench;

    parameter period = 2;
    parameter delay = 1;

    reg [7:0] number1, number2;
    reg clk, rst_n, start;
    wire [7:0] gcd_out;
    wire done, error;
    wire [2:0] state;

    gcd u1 (
        .gcd_out(gcd_out),
        .done(done),
        .error(error),
        .state(state),
        .clk(clk),
        .rst_n(rst_n),
        .number1(number1),
        .number2(number2),
        .start(start)
    );

    initial begin
        $fsdbDumpfile("../4.Simulation_Result/gcd_rtl.fsdb");
        $fsdbDumpvars;
    end

    always #(period / 2) clk = ~clk;

    initial begin
        clk = 1;
        rst_n = 1;
        start = 0;
        number1 = 0;
        number2 = 0;
        #(period + delay) rst_n = 0;
        #(period * 2) rst_n = 1;
        #(period) start = 1;
        number1 = 50;
        number2 = 0;
        #(period) start = 0;

        @(negedge done);
        @(posedge clk);
        #(delay) start = 1;
        number1 = 0;
        number2 = 50;
        #(period) start = 0;

        @(negedge done);
        @(posedge clk);
        #(delay) start = 1;
        number1 = 255;
        number2 = 51;
        #(period) start = 0;

        @(negedge done);
        @(posedge clk);
        #(delay) start = 1;
        number1 = 72;
        number2 = 180;
        #(period) start = 0;

        @(negedge done);
        @(posedge clk);
        #(delay * 3) rst_n = 0;
        #(period * 8) $finish;
    end

    // Automatically finish
    initial begin
        #200;
        $finish;
    end

endmodule
