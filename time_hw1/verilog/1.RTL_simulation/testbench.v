`timescale 1ns / 100ps

// Testbench for the square-root RTL module.
// Expected DUT interface:
//   module SQR (
//       output reg [9:0] sqrt_out,
//       output reg done,
//       input clk, rst_n,
//       input [9:0] number,
//       input start
//   );
//
// number is unsigned Q7.3 (real_value * 8).
// sqrt_out is unsigned with 6 fractional bits (real_value * 64).
module testbench;

    parameter period = 2;
    parameter delay = 1;

    reg [9:0] number;
    reg clk, rst_n, start;
    wire [9:0] sqrt_out;
    wire done;

    gcd u1 (
        .sqrt_out(sqrt_out),
        .done(done),
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
            if (sqrt_out !== expected_sqrt) begin
                $display("FAIL: number=%0d (0x%03h), expected sqrt=%0d (0x%03h), got=%0d (0x%03h) at %0t",
                         test_number, test_number, expected_sqrt, expected_sqrt,
                         sqrt_out, sqrt_out, $time);
                $finish;
            end else begin
                $display("PASS: number=%0d (0x%03h), sqrt=%0d (0x%03h) at %0t",
                         test_number, test_number, sqrt_out, sqrt_out, $time);
            end

            // Let the one-cycle done indication return low before next input.
            @(negedge clk);
        end
    endtask

    initial begin
        rst_n = 1'b0;
        start = 1'b0;
        number = 10'd0;

        repeat (2) @(negedge clk);
        rst_n = 1'b1;

        // x=4.000: input raw 4*8=32; sqrt output raw floor(sqrt(32<<9))=128.
        run_case(10'd32, 10'd128);

        // x=16.125: input raw 16.125*8=129; expected raw sqrt=256.
        run_case(10'd129, 10'd256);

        // x=49.500: input raw 49.5*8=396; expected raw sqrt=450.
        run_case(10'd396, 10'd450);

        $display("All square-root test patterns passed.");
        $finish;
    end

    initial begin
        #500;
        $display("ERROR: testbench timeout waiting for DUT completion.");
        $finish;
    end

endmodule
