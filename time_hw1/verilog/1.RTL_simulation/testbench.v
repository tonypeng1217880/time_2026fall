`timescale 1ns / 100ps

module testbench;

    parameter period = 2;
    parameter delay = 1;

    integer cycle_count;
    integer total_latency;

    reg [9:0] data_in;
    reg clk, rst_n, in_valid;
    wire [9:0] sqr_out;
    wire out_valid;

    gcd u1 (
        .sqr_out(sqr_out),
        .out_valid(out_valid),
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .in_valid(in_valid)
    );

    initial begin
        $fsdbDumpfile("sqrt_rtl.fsdb");
        $fsdbDumpvars(0, testbench);
    end

    initial clk = 1'b0;
    always #(period / 2) clk = ~clk;

    // Count active clock cycles after reset is released.
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cycle_count = 0;
        else
            cycle_count = cycle_count + 1;
    end

    task run_case;
        input [9:0] test_number;
        input [9:0] expected_sqrt;
        integer start_cycle;
        integer case_latency;
        begin
            @(negedge clk);
            start_cycle = cycle_count;
            data_in = test_number;
            in_valid = 1'b1;

            @(negedge clk);
            in_valid = 1'b0;

            wait (out_valid === 1'b1);
            case_latency = cycle_count - start_cycle;
            total_latency = total_latency + case_latency;
            #(delay);
            if (sqr_out !== expected_sqrt) begin
                $display("FAIL: x_raw=%0d (0x%03h), expected sqrt=%0d (0x%03h), got=%0d (0x%03h)",
                         test_number, test_number, expected_sqrt, expected_sqrt,
                         sqr_out, sqr_out);
                $display("      state=%0d at %0t", u1.state, $time);
                $finish;
            end else begin
                $display("PASS: x_raw=%0d (0x%03h), sqrt_raw=%0d (0x%03h), latency=%0d cycles at %0t",
                         test_number, test_number, sqr_out, sqr_out,
                         case_latency, $time);
            end

            // This iterative DUT accepts the next input after its output pulse.
            wait (out_valid === 1'b0);
        end
    endtask

    task YOU_SUCCESS_task;
        begin
            // ANSI bright green. Most Linux terminals, including MobaXterm,
            // display this frame in green.
            $write("%c[1;32m", 8'h1b);
            $display("----------------------------------------------------------------------------------------------------------------------");
            $display("                                              Congratulations!                                                        ");
            $display("                                       You have passed all patterns!                                                  ");
            $display("                                       Passed patterns         = %5d                                                  ", 3);
            $display("                                       Total execution latency = %5d cycles                                           ", total_latency);
            $display("                                       Clock period            = %5.1f ns                                             ", $itor(period));
            $display("----------------------------------------------------------------------------------------------------------------------");
            $write("%c[0m", 8'h1b);
            $display("");
            repeat (2) @(negedge clk);
            $finish;
        end
    endtask

    initial begin
        rst_n = 1'b1;
        in_valid = 1'b0;
        data_in = 10'd0;
        total_latency = 0;

        // Assert reset asynchronously, hold it through two clock cycles,
        // then release it on a falling edge before normal operation.
        #0.5 rst_n = 1'b0;
        repeat (2) @(negedge clk);
        rst_n = 1'b1;

        // x=4.000: raw input 4*8=32; raw sqrt=floor(sqrt(32<<9))=128.
        run_case(10'd32, 10'd128);

        // x=16.125: raw input 16.125*8=129; raw sqrt=256.
        run_case(10'd129, 10'd256);

        // x=49.500: raw input 49.5*8=396; raw sqrt=450.
        run_case(10'd396, 10'd450);

        YOU_SUCCESS_task;
    end

    initial begin
        #500;
        $display("ERROR: timeout waiting for DUT completion.");
        $finish;
    end

endmodule
