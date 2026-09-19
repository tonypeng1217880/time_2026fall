`timescale 1ns / 100ps

// Square-root patterns. The file remains gcd.v and the top module remains
// gcd so the TA synthesis scripts can keep their existing file/top names.
// The arithmetic ports are renamed for the square-root design:
//   output reg [9:0] sqr_out;
//   output reg done, error;
//   output reg [2:0] state;
//   input clk, rst_n;
//   input [9:0] number;
//   input start;
//
// number is Q7.3 (real input * 8).
// sqr_out contains the real square-root result multiplied by 64.
module testbench;

    parameter period = 2;
    parameter delay = 1;

    reg [9:0] number;
    reg clk, rst_n, start;
    wire [9:0] sqr_out;
    wire done, error;
    wire [2:0] state;

    gcd u1 (
        .sqr_out(sqr_out),
        .done(done),
        .error(error),
        .state(state),
        .clk(clk),
        .rst_n(rst_n),
        .number(number),
        .start(start)
    );

    initial begin
        $fsdbDumpfile("sqrt_rtl.fsdb");
        $fsdbDumpvars(0, testbench);
    end

    initial clk = 1'b0;
    always #(period / 2) clk = ~clk;

    task run_case;
        input [9:0] test_number;
        input [9:0] expected_sqrt;
        begin
            @(negedge clk);
            number = test_number;
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            wait (done === 1'b1);
            #(delay);
            if ((sqr_out !== expected_sqrt) || (error !== 1'b0)) begin
                $display("FAIL: x_raw=%0d (0x%03h), expected sqrt=%0d (0x%03h), got=%0d (0x%03h)",
                         test_number, test_number, expected_sqrt, expected_sqrt,
                         sqr_out, sqr_out);
                $display("      error=%b, state=%0d at %0t",
                         error, state, $time);
                $finish;
            end else begin
                $display("PASS: x_raw=%0d (0x%03h), sqrt_raw=%0d (0x%03h) at %0t",
                         test_number, test_number, sqr_out, sqr_out, $time);
            end

            // Wait for done to return low before launching the next case.
            @(negedge clk);
        end
    endtask

    initial begin
        rst_n = 1'b0;
        start = 1'b0;
        number = 10'd0;

        repeat (2) @(negedge clk);
        rst_n = 1'b1;

        // x=4.000: raw input 4*8=32; raw sqrt=floor(sqrt(32<<9))=128.
        run_case(10'd32, 10'd128);

        // x=16.125: raw input 16.125*8=129; raw sqrt=256.
        run_case(10'd129, 10'd256);

        // x=49.500: raw input 49.5*8=396; raw sqrt=450.
        run_case(10'd396, 10'd450);

        $display("All square-root patterns passed.");
        $finish;
    end

    initial begin
        #500;
        $display("ERROR: timeout waiting for DUT completion.");
        $finish;
    end

endmodule
