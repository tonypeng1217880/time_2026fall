`ifdef RTL
    `define CYCLE_TIME 5.0
`elsif GATE
    `define CYCLE_TIME 5.0
`elsif POST
    `define CYCLE_TIME 5.0
`else
    `define CYCLE_TIME 5.0
`endif

`define MAX_LATENCY 100

module PATTERN (
    clk,
    rst_n,
    data_in,
    in_valid,
    pow_out,
    out_valid
);

output reg        clk;
output reg        rst_n;
output reg  [9:0] data_in;
output reg        in_valid;
input      [10:0] pow_out;
input             out_valid;

real CYCLE = `CYCLE_TIME;
integer cycle_count;
integer total_latency;
integer passed_patterns;

always #(CYCLE/2.0) clk = ~clk;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cycle_count = 0;
    else
        cycle_count = cycle_count + 1;
end

task reset_task;
begin
    rst_n = 1'b1;
    in_valid = 1'b0;
    data_in = 10'd0;

    #0.5;
    rst_n = 1'b0;
    repeat (2) @(negedge clk);
    rst_n = 1'b1;

    if ((out_valid !== 1'b0) || (pow_out !== 11'd0)) begin
        $display("FAIL: reset specification is violated at %0t", $time);
        $finish;
    end
end
endtask

task run_case;
    input  [9:0] test_number;
    input [10:0] expected_pow;
    integer start_cycle;
    integer case_latency;
begin
    @(negedge clk);
    start_cycle = cycle_count;
    data_in = test_number;
    in_valid = 1'b1;

    @(negedge clk);
    in_valid = 1'b0;
    data_in = 10'd0;

    case_latency = 0;
    while (out_valid !== 1'b1) begin
        @(negedge clk);
        case_latency = cycle_count - start_cycle;
        if (case_latency > `MAX_LATENCY) begin
            $display("FAIL: latency exceeds %0d cycles for input %0d", `MAX_LATENCY, test_number);
            $finish;
        end
    end

    case_latency = cycle_count - start_cycle;
    total_latency = total_latency + case_latency;

    if (pow_out !== expected_pow) begin
        $display("FAIL: x_raw=%0d (0x%03h), expected=%0d (0x%03h), got=%0d (0x%03h) at %0t",
                 test_number, test_number, expected_pow, expected_pow,
                 pow_out, pow_out, $time);
        $finish;
    end

    $display("PASS: x_raw=%0d, pow_raw=%0d, latency=%0d cycles",
             test_number, pow_out, case_latency);
    passed_patterns = passed_patterns + 1;

    @(negedge clk);
    if (out_valid !== 1'b0) begin
        $display("FAIL: out_valid must be a one-cycle pulse at %0t", $time);
        $finish;
    end
end
endtask

task YOU_SUCCESS_task;
begin
    $write("%c[1;32m", 8'h1b);
    $display("------------------------------------------------------------");
    $display("Congratulations! You have passed all bonus patterns!");
    $display("passed patterns = %0d", passed_patterns);
    $display("execution cycles = %0d", total_latency);
    $display("clock period = %0.1f ns", CYCLE);
    $display("------------------------------------------------------------");
    $write("%c[0m", 8'h1b);
    repeat (2) @(negedge clk);
    $finish;
end
endtask

initial begin
    clk = 1'b0;
    rst_n = 1'b1;
    data_in = 10'd0;
    in_valid = 1'b0;
    total_latency = 0;
    passed_patterns = 0;

    reset_task;

    // Q7.3 input and Q5.6 output:
    // expected_pow = floor((data_in / 8)^(2/3) * 64).
    run_case(10'd32,  11'd161); // 4.000
    run_case(10'd129, 11'd408); // 16.125
    run_case(10'd396, 11'd862); // 49.500

    YOU_SUCCESS_task;
end

endmodule
