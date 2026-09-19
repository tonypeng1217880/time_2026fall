`timescale 1ns / 100ps

// Bonus testbench for y = x^(2/3).
// Expected RTL file: gcd_bonus.v
// Expected top module and interface:
//   module gcd_bonus (
//       output reg [9:0] pow_out,
//       output reg       done,
//       output reg       error,
//       output reg [2:0] state,
//       input            clk,
//       input            rst_n,
//       input      [9:0] number,
//       input            start
//   );
//
// number is unsigned Q7.3 (real input * 8).
// pow_out contains x^(2/3) multiplied by 64 and rounded downward.
module testbench_bonus;

    parameter period = 2;
    parameter delay = 1;

    reg [9:0] number;
    reg clk, rst_n, start;
    wire [9:0] pow_out;
    wire done, error;
    wire [2:0] state;

    gcd_bonus u1 (
        .pow_out(pow_out),
        .done(done),
        .error(error),
        .state(state),
        .clk(clk),
        .rst_n(rst_n),
        .number(number),
        .start(start)
    );

    initial begin
        $fsdbDumpfile("pow_rtl.fsdb");
        $fsdbDumpvars(0, testbench_bonus);
    end

    initial clk = 1'b0;
    always #(period / 2) clk = ~clk;

    task run_case;
        input [9:0] test_number;
        input [9:0] expected_pow;
        begin
            @(negedge clk);
            number = test_number;
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            wait (done === 1'b1);
            #(delay);
            if ((pow_out !== expected_pow) || (error !== 1'b0)) begin
                $display("FAIL: x_raw=%0d (0x%03h), expected pow=%0d (0x%03h), got=%0d (0x%03h)",
                         test_number, test_number, expected_pow, expected_pow,
                         pow_out, pow_out);
                $display("      error=%b, state=%0d at %0t",
                         error, state, $time);
                $finish;
            end else begin
                $display("PASS: x_raw=%0d (0x%03h), pow_raw=%0d (0x%03h) at %0t",
                         test_number, test_number, pow_out, pow_out, $time);
            end

            @(negedge clk);
        end
    endtask

    initial begin
        rst_n = 1'b0;
        start = 1'b0;
        number = 10'd0;

        repeat (2) @(negedge clk);
        rst_n = 1'b1;

        // x=4.000: raw input=32; floor(4^(2/3)*64)=161 (0x0a1).
        run_case(10'd32, 10'd161);

        // x=16.125: raw input=129; floor(16.125^(2/3)*64)=408 (0x198).
        run_case(10'd129, 10'd408);

        // x=49.500: raw input=396; floor(49.5^(2/3)*64)=862 (0x35e).
        run_case(10'd396, 10'd862);

        $display("All x^(2/3) bonus patterns passed.");
        $finish;
    end

    initial begin
        #500;
        $display("ERROR: timeout waiting for bonus DUT completion.");
        $finish;
    end

endmodule
