`timescale 1ns/1ps

// One pattern file, selected at compile time:
//   +define+PD_TEST  : phase-detector verification
//   +define+TDL_TEST : TDL range/resolution verification
//   no test-mode define: complete DLL verification
//
// Expected module interfaces:
//   pd  (ref_clk, fb_clk, rst_n, lead_lag)
//   tdl (tdl_in, tdl_code, tdl_out)
//   gcd (clk_in, rst_n, clk_o1, clk_o2, locked)

// Terminal summary: green PASS, red FAIL. Add runtime +NO_COLOR for plain logs.
// Keep text labels even when a terminal does not support ANSI colors.
`define HW2_RESULT_BANNER(OK, LABEL, DETAIL) \
    begin \
        if (!$test$plusargs("NO_COLOR")) begin \
            if (OK) $write("\033[1;32m"); \
            else    $write("\033[1;31m"); \
        end \
        $display(""); \
        $display("================================================================"); \
        if (OK) $display("    PASS  |  %0s", LABEL); \
        else    $display("    FAIL  |  %0s", LABEL); \
        $display("----------------------------------------------------------------"); \
        $display("    %0s", DETAIL); \
        $display("================================================================"); \
        if (!$test$plusargs("NO_COLOR")) $write("\033[0m"); \
        $display(""); \
    end

`ifndef TDL_CODE_WIDTH
    `define TDL_CODE_WIDTH 6
`endif

`ifndef TDL_NUM_CODES
    `define TDL_NUM_CODES 48
`endif

// Convention: 1 means fb_clk leads ref_clk, 0 means fb_clk lags.
// The exactly coincident case is reported without a required tie polarity.

`ifdef PD_TEST

module PATTERN (
    ref_clk,
    fb_clk,
    rst_n,
    lead_lag
);

output reg ref_clk;
output reg fb_clk;
output reg rst_n;
input      lead_lag;

localparam real PD_CYCLE = 1.0;
localparam integer PD_RUN_CYCLES = 8;
integer pd_passes;
integer pd_failures;

// Positive offset means fb_clk rises later than ref_clk and therefore lags.
task automatic drive_pd_clock;
    input integer clock_id;
    input real start_delay;
    integer i;
begin
    #(start_delay);
    for (i = 0; i < 2*PD_RUN_CYCLES; i = i + 1) begin
        #(PD_CYCLE/2.0);
        if (clock_id == 0)
            ref_clk = ~ref_clk;
        else
            fb_clk = ~fb_clk;
    end
end
endtask

task automatic run_pd_case;
    input real offset_ps;
    input       expected_lead_lag;
    real offset_ns;
    real ref_start;
    real fb_start;
begin
    ref_clk = 1'b0;
    fb_clk  = 1'b0;
    rst_n   = 1'b0;
    #0.2;
    rst_n   = 1'b1;

    offset_ns = offset_ps / 1000.0;
    if (offset_ns >= 0.0) begin
        ref_start = 0.0;
        fb_start  = offset_ns;
    end
    else begin
        ref_start = -offset_ns;
        fb_start  = 0.0;
    end

    fork
        drive_pd_clock(0, ref_start);
        drive_pd_clock(1, fb_start);
    join

    #0.1;
    if (offset_ps == 0.0) begin
        // A racing PD has no specified winner at exactly coincident edges.
        // Report the observation required by the homework, without inventing
        // a required tie polarity (or treating X as a usable direction).
        $display("INFO: PD offset=0 ps, observed lead_lag=%b (tie, no direction specified)",
                 lead_lag);
    end
    else if (lead_lag !== expected_lead_lag) begin
        $display("FAIL: PD offset=%0.1f ps, expected=%b, got=%b",
                 offset_ps, expected_lead_lag, lead_lag);
        pd_failures = pd_failures + 1;
    end
    else begin
        $display("PASS: PD offset=%0.1f ps, lead_lag=%b",
                 offset_ps, lead_lag);
        pd_passes = pd_passes + 1;
    end
end
endtask

initial begin
    ref_clk = 1'b0;
    fb_clk = 1'b0;
    rst_n = 1'b1;
    pd_passes = 0;
    pd_failures = 0;

    run_pd_case(-40.0, 1'b1);
    run_pd_case(-30.0, 1'b1);
    run_pd_case(-20.0, 1'b1);
    run_pd_case(-10.0, 1'b1);
    run_pd_case(  0.0, 1'bx);
    run_pd_case( 10.0, 1'b0);
    run_pd_case( 20.0, 1'b0);
    run_pd_case( 30.0, 1'b0);
    run_pd_case( 40.0, 1'b0);

    if (pd_failures != 0) begin
        `HW2_RESULT_BANNER(1'b0, "PD TEST", "One or more directional comparisons failed.")
        $fatal(1, "PD TEST FAILED: %0d passed, %0d failed", pd_passes, pd_failures);
    end
    else begin
        $display("PD TEST PASSED: %0d directional cases plus 1 reported tie", pd_passes);
        `HW2_RESULT_BANNER(1'b1, "PD TEST", "Directional checks passed with loaded model; tie reported.")
    end

    #1.0;
    $finish;
end

endmodule

`elsif TDL_TEST

module PATTERN (
    tdl_in,
    tdl_code,
    tdl_out
);

output reg                       tdl_in;
output reg [`TDL_CODE_WIDTH-1:0] tdl_code;
input                            tdl_out;

localparam real TDL_CYCLE = 10.0;
localparam real TDL_TIMEOUT = 5.0;
localparam real STEP_EPS = 0.001;
localparam integer TDL_NUM_CODES = `TDL_NUM_CODES;

real delay_ns [0:TDL_NUM_CODES-1];
real min_delay;
real max_delay;
real min_step;
real diff;
integer code;
integer i;
integer direction;
integer tdl_failures;

always #(TDL_CYCLE/2.0) tdl_in = ~tdl_in;

task measure_tdl_code;
    input integer code_value;
    output real measured_delay;
    real input_edge;
    integer timed_out;
begin
    tdl_code = code_value;
    @(negedge tdl_in);
    @(posedge tdl_in);
    input_edge = $realtime;
    timed_out = 0;

    fork : TDL_WAIT
        begin
            @(posedge tdl_out);
            measured_delay = $realtime - input_edge;
        end
        begin
            #TDL_TIMEOUT;
            measured_delay = -1.0;
            timed_out = 1;
        end
    join_any
    disable TDL_WAIT;

    if (timed_out) begin
        $display("FAIL: TDL code=%0d has no output edge within %0.1f ns",
                 code_value, TDL_TIMEOUT);
        tdl_failures = tdl_failures + 1;
    end
    else begin
        $display("TDL code=%0d, delay=%0.3f ns", code_value, measured_delay);
    end
end
endtask

initial begin
    tdl_in = 1'b0;
    tdl_code = {`TDL_CODE_WIDTH{1'b0}};
    tdl_failures = 0;

    repeat (2) @(posedge tdl_in);

    for (code = 0; code < TDL_NUM_CODES; code = code + 1)
        measure_tdl_code(code, delay_ns[code]);

    if (tdl_failures == 0) begin
        min_delay = delay_ns[0];
        max_delay = delay_ns[0];
        min_step = 1.0e9;
        direction = 0;

        for (i = 1; i < TDL_NUM_CODES; i = i + 1) begin
            if (delay_ns[i] < min_delay) min_delay = delay_ns[i];
            if (delay_ns[i] > max_delay) max_delay = delay_ns[i];

            diff = delay_ns[i] - delay_ns[i-1];
            if ((diff < -STEP_EPS) || (diff > STEP_EPS)) begin
                if (min_step > ((diff < 0.0) ? -diff : diff))
                    min_step = (diff < 0.0) ? -diff : diff;
                if (direction == 0)
                    direction = (diff > 0.0) ? 1 : -1;
                else if (((direction > 0) && (diff < -STEP_EPS)) ||
                         ((direction < 0) && (diff > STEP_EPS))) begin
                    $display("FAIL: TDL is not monotonic at code %0d", i);
                    tdl_failures = tdl_failures + 1;
                end
            end
        end

        if (direction == 0) begin
            $display("FAIL: TDL has no measurable code-dependent delay");
            tdl_failures = tdl_failures + 1;
        end
        else begin
            $display("TDL range=%0.3f ns, resolution=%0.3f ps",
                     max_delay - min_delay, min_step*1000.0);
        end
    end

    if (tdl_failures != 0) begin
        `HW2_RESULT_BANNER(1'b0, "TDL TEST", "Code sweep, output edge or monotonicity check failed.")
        $fatal(1, "TDL TEST FAILED: %0d failure(s)", tdl_failures);
    end
    else begin
        $display("TDL TEST PASSED");
        `HW2_RESULT_BANNER(1'b1, "TDL TEST", "Code sweep passed; measured delays depend on library/SDF.")
    end

    #1.0;
    $finish;
end

endmodule

`else

module PATTERN (
    clk_in,
    rst_n,
    clk_o1,
    clk_o2,
    locked
);

output reg clk_in;
output reg rst_n;
input      clk_o1;
input      clk_o2;
input      locked;

// Explicitly opt in for diagnosis with the unannotated 1 ns-per-cell library.
// This mode is NOT the homework's 1 GHz timing verification.
`ifdef DLL_UNIT_DIAG
localparam real DLL_CYCLE = 20.0;
localparam real PHASE_TOL = 1.1; // one 1 ns model step, plus margin
`else
localparam real DLL_CYCLE = 1.0;
// Engineering acceptance threshold, NOT a tolerance specified by the TA.
`ifndef DLL_PHASE_TOL_NS
    `define DLL_PHASE_TOL_NS 0.03
`endif
localparam real PHASE_TOL = `DLL_PHASE_TOL_NS;
`endif
localparam real O1_DELAY = DLL_CYCLE / 2.0;
localparam real O2_DELAY = DLL_CYCLE;
localparam integer MAX_LOCK_CYCLES = 2000;
localparam integer VERIFY_CYCLES = 32;

real ref_edge_0;
real ref_edge_1;
real ref_edge_2;
integer ref_edge_count;
integer check_enable;
integer fail_flag;
integer o1_checks;
integer o2_checks;
integer lock_wait_cycles;
integer clock_run;
real last_o1_edge;
real last_o2_edge;
real observed_o1_edge;
real observed_o2_edge;

// Search trace. RTL may inspect controller internals; GATE uses only the
// top-level inter-block nets whose names are preserved in the synthesized
// hierarchical netlist.
`ifdef RTL
reg [5:0] dbg_code1;
reg [5:0] dbg_code2;
reg       dbg_locked1;
reg       dbg_locked2;
integer   dbg_initialized;
`elsif GATE
reg [5:0] dbg_code1;
reg [5:0] dbg_code2;
reg       dbg_locked1;
reg       dbg_locked2;
integer   dbg_initialized;
`elsif POST
reg [5:0] dbg_code1;
reg [5:0] dbg_code2;
reg       dbg_locked1;
reg       dbg_locked2;
integer   dbg_initialized;
`endif

always #(DLL_CYCLE/2.0)
    if (clock_run) clk_in = ~clk_in;

always @(posedge clk_in) begin
    ref_edge_2 = ref_edge_1;
    ref_edge_1 = ref_edge_0;
    ref_edge_0 = $realtime;
    ref_edge_count = ref_edge_count + 1;
end

function real abs_real;
    input real value;
begin
    abs_real = (value < 0.0) ? -value : value;
end
endfunction

function real observed_phase;
    input real output_edge;
    real value;
begin
    if ((output_edge < 0.0) || (ref_edge_count < 1)) begin
        observed_phase = -1.0;
    end
    else begin
        value = output_edge - ref_edge_0;
        while (value < 0.0)
            value = value + DLL_CYCLE;
        while (value >= DLL_CYCLE)
            value = value - DLL_CYCLE;
        observed_phase = value;
    end
end
endfunction

always @(posedge clk_o1)
    observed_o1_edge = $realtime;

always @(posedge clk_o2)
    observed_o2_edge = $realtime;

// Compare the latest three input edges. This handles clk_o2, whose 360-degree
// edge can occur at the same timestamp as the next clk_in edge.
function real phase_error;
    input real expected_delay;
    real err0;
    real err1;
    real err2;
begin
    if (ref_edge_count < 3) begin
        phase_error = 1.0e9;
    end
    else begin
        err0 = abs_real(($realtime - ref_edge_0) - expected_delay);
        err1 = abs_real(($realtime - ref_edge_1) - expected_delay);
        err2 = abs_real(($realtime - ref_edge_2) - expected_delay);
        phase_error = err0;
        if (err1 < phase_error) phase_error = err1;
        if (err2 < phase_error) phase_error = err2;
    end
end
endfunction

task automatic check_output_edge;
    input integer output_id;
    input real expected_delay;
    real error;
    real period;
begin
    error = phase_error(expected_delay);

    if (check_enable) begin
        if (output_id == 1) begin
            o1_checks = o1_checks + 1;
            if (last_o1_edge >= 0.0) begin
                period = $realtime - last_o1_edge;
                if (abs_real(period - DLL_CYCLE) > PHASE_TOL) begin
                    $display("FAIL: clk_o1 period=%0.3f ns", period);
                    fail_flag = 1;
                end
            end
            last_o1_edge = $realtime;
            if (error > PHASE_TOL) begin
                $display("FAIL: clk_o1 phase error=%0.3f ns", error);
                fail_flag = 1;
            end
        end
        else begin
            o2_checks = o2_checks + 1;
            if (last_o2_edge >= 0.0) begin
                period = $realtime - last_o2_edge;
                if (abs_real(period - DLL_CYCLE) > PHASE_TOL) begin
                    $display("FAIL: clk_o2 period=%0.3f ns", period);
                    fail_flag = 1;
                end
            end
            last_o2_edge = $realtime;
            if (error > PHASE_TOL) begin
                $display("FAIL: clk_o2 phase error=%0.3f ns", error);
                fail_flag = 1;
            end
        end
    end
end
endtask

always @(posedge clk_o1)
    if (check_enable && ref_edge_count >= 3)
        check_output_edge(1, O1_DELAY);

always @(posedge clk_o2)
    if (check_enable && ref_edge_count >= 3)
        check_output_edge(2, O2_DELAY);

task automatic reset_task;
begin
    // Complete reset while the source clock is stopped.  APR adds different
    // insertion delays to RN and CK, so releasing reset while a 1 GHz clock
    // is already running can violate recovery even when the RTL timestamp
    // appears clear of an edge.  Search operation remains fully continuous
    // after startup.
    clock_run = 0;
    clk_in = 1'b0;
    rst_n = 1'b1;
    #0.1;
    rst_n = 1'b0;
    #(10.0 * DLL_CYCLE);
    rst_n = 1'b1;
    // The unannotated library recovery placeholder is 1 ns.  Leave more than
    // one full 1 GHz cycle before the first source-clock edge.
    #(1.25 * DLL_CYCLE);
    clock_run = 1;
    repeat (6) @(negedge clk_in);
end
endtask

// After locking only: pause/drain the input and launch an isolated edge.
// This verifies physical T/2 and T delays, which periodic phase alone cannot
// distinguish from a zero-cycle or extra-cycle lock. No reset is asserted;
// both frozen tuning codes must be retained while the input clock is paused.
task verify_absolute_delay;
    real launch_time;
    real measured1;
    real measured2;
    integer edges1;
    integer edges2;
begin
    @(negedge clk_in);
    #0.001;
    clock_run = 0;
    #(5.0 * DLL_CYCLE);
    if ((clk_o1 !== 1'b0) || (clk_o2 !== 1'b0)) begin
        `HW2_RESULT_BANNER(1'b0, "DLL TEST", "Output did not settle low during absolute-delay check.")
        $fatal(1, "DLL outputs did not drain to zero after clock pause");
    end

    edges1 = 0;
    edges2 = 0;
    measured1 = -1.0;
    measured2 = -1.0;
    fork : ABSOLUTE_DELAY_CHECK
        begin
            forever begin
                @(posedge clk_o1);
                edges1 = edges1 + 1;
                if (edges1 == 1) measured1 = $realtime - launch_time;
            end
        end
        begin
            forever begin
                @(posedge clk_o2);
                edges2 = edges2 + 1;
                if (edges2 == 1) measured2 = $realtime - launch_time;
            end
        end
        begin
            #0.010;
            launch_time = $realtime;
            clk_in = 1'b1;
            #(DLL_CYCLE/2.0);
            clk_in = 1'b0;
            #(4.0 * DLL_CYCLE);
        end
    join_any
    disable ABSOLUTE_DELAY_CHECK;

    $display("DLL absolute delay: o1=%0.3f ns, o2=%0.3f ns", measured1, measured2);
    if ((edges1 != 1) || (edges2 != 1) ||
        (abs_real(measured1 - O1_DELAY) > PHASE_TOL) ||
        (abs_real(measured2 - O2_DELAY) > PHASE_TOL)) begin
        `HW2_RESULT_BANNER(1'b0, "DLL TEST", "Wrong physical delay or unexpected output edge count.")
        $fatal(1, "DLL absolute delay check failed (edges1=%0d, edges2=%0d)",
               edges1, edges2);
    end
    if (locked !== 1'b1) begin
        `HW2_RESULT_BANNER(1'b0, "DLL TEST", "Lock was not retained while the input clock was paused.")
        $fatal(1, "DLL lost its frozen lock while the clock was paused");
    end

    clock_run = 1;
    repeat (4) @(negedge clk_in);
end
endtask

initial begin
    clk_in = 1'b0;
    `ifdef DLL_UNIT_DIAG
    $display("DIAGNOSTIC ONLY: T=20 ns, targets=10/20 ns, tolerance=1.1 ns; NOT a 1 GHz result");
    `endif
    clock_run = 1;
    rst_n = 1'b1;
    ref_edge_0 = 0.0;
    ref_edge_1 = 0.0;
    ref_edge_2 = 0.0;
    ref_edge_count = 0;
    check_enable = 0;
    fail_flag = 0;
    o1_checks = 0;
    o2_checks = 0;
    last_o1_edge = -1.0;
    last_o2_edge = -1.0;
    observed_o1_edge = -1.0;
    observed_o2_edge = -1.0;
    `ifdef RTL
    dbg_code1 = 6'bxxxxxx;
    dbg_code2 = 6'bxxxxxx;
    dbg_locked1 = 1'bx;
    dbg_locked2 = 1'bx;
    dbg_initialized = 0;
    `elsif GATE
    dbg_code1 = 6'bxxxxxx;
    dbg_code2 = 6'bxxxxxx;
    dbg_locked1 = 1'bx;
    dbg_locked2 = 1'bx;
    dbg_initialized = 0;
    `elsif POST
    dbg_code1 = 6'bxxxxxx;
    dbg_code2 = 6'bxxxxxx;
    dbg_locked1 = 1'bx;
    dbg_locked2 = 1'bx;
    dbg_initialized = 0;
    `endif

    reset_task;

    lock_wait_cycles = 0;
    while ((lock_wait_cycles < MAX_LOCK_CYCLES) && (locked !== 1'b1)) begin
        @(negedge clk_in);
        lock_wait_cycles = lock_wait_cycles + 1;
        `ifdef RTL
        if (!dbg_initialized ||
            (TESTBED.u_gcd.code1 !== dbg_code1) ||
            (TESTBED.u_gcd.code2 !== dbg_code2) ||
            (TESTBED.u_gcd.locked1 !== dbg_locked1) ||
            (TESTBED.u_gcd.locked2 !== dbg_locked2) ||
            ((lock_wait_cycles % 128) == 0)) begin
            $display("DLL_SEARCH t=%0.3f ns cycle=%0d | L1=%b code1=%0d lead1=%b measure1=%b wait1=%0d sync1=%b | L2=%b code2=%0d lead2=%b measure2=%b wait2=%0d sync2=%b",
                     $realtime, lock_wait_cycles,
                     TESTBED.u_gcd.locked1, TESTBED.u_gcd.code1,
                     TESTBED.u_gcd.lead_lag1, TESTBED.u_gcd.measure1,
                     TESTBED.u_gcd.u_ctl1.wait_count,
                     TESTBED.u_gcd.u_ctl1.pd_sync,
                     TESTBED.u_gcd.locked2, TESTBED.u_gcd.code2,
                     TESTBED.u_gcd.lead_lag2, TESTBED.u_gcd.measure2,
                     TESTBED.u_gcd.u_ctl2.wait_count,
                     TESTBED.u_gcd.u_ctl2.pd_sync);
            dbg_code1 = TESTBED.u_gcd.code1;
            dbg_code2 = TESTBED.u_gcd.code2;
            dbg_locked1 = TESTBED.u_gcd.locked1;
            dbg_locked2 = TESTBED.u_gcd.locked2;
            dbg_initialized = 1;
        end
        `elsif GATE
        if (!dbg_initialized ||
            (TESTBED.u_gcd.code1 !== dbg_code1) ||
            (TESTBED.u_gcd.code2 !== dbg_code2) ||
            (TESTBED.u_gcd.locked1 !== dbg_locked1) ||
            (TESTBED.u_gcd.locked2 !== dbg_locked2) ||
            ((lock_wait_cycles % 128) == 0)) begin
            $display("GATE_SEARCH t=%0.3f ns cycle=%0d | L1=%b code1=%b lead1=%b phase1=%0.3f | L2=%b code2=%b lead2=%b phase2=%0.3f | out1=%b out2=%b",
                     $realtime, lock_wait_cycles,
                     TESTBED.u_gcd.locked1, TESTBED.u_gcd.code1,
                     TESTBED.u_gcd.lead_lag1, observed_phase(observed_o1_edge),
                     TESTBED.u_gcd.locked2, TESTBED.u_gcd.code2,
                     TESTBED.u_gcd.lead_lag2, observed_phase(observed_o2_edge),
                     clk_o1, clk_o2);
            dbg_code1 = TESTBED.u_gcd.code1;
            dbg_code2 = TESTBED.u_gcd.code2;
            dbg_locked1 = TESTBED.u_gcd.locked1;
            dbg_locked2 = TESTBED.u_gcd.locked2;
            dbg_initialized = 1;
        end
        `elsif POST
        if (!dbg_initialized ||
            (TESTBED.u_gcd.code1 !== dbg_code1) ||
            (TESTBED.u_gcd.code2 !== dbg_code2) ||
            (TESTBED.u_gcd.locked1 !== dbg_locked1) ||
            (TESTBED.u_gcd.locked2 !== dbg_locked2) ||
            ((lock_wait_cycles % 128) == 0)) begin
            $display("POST_SEARCH t=%0.3f ns cycle=%0d | L1=%b code1=%b lead1=%b phase1=%0.3f | L2=%b code2=%b lead2=%b phase2=%0.3f | out1=%b out2=%b",
                     $realtime, lock_wait_cycles,
                     TESTBED.u_gcd.locked1, TESTBED.u_gcd.code1,
                     TESTBED.u_gcd.lead_lag1, observed_phase(observed_o1_edge),
                     TESTBED.u_gcd.locked2, TESTBED.u_gcd.code2,
                     TESTBED.u_gcd.lead_lag2, observed_phase(observed_o2_edge),
                     clk_o1, clk_o2);
            dbg_code1 = TESTBED.u_gcd.code1;
            dbg_code2 = TESTBED.u_gcd.code2;
            dbg_locked1 = TESTBED.u_gcd.locked1;
            dbg_locked2 = TESTBED.u_gcd.locked2;
            dbg_initialized = 1;
        end
        `endif
    end

    if (locked !== 1'b1) begin
        `ifdef RTL
        $display("DLL_TIMEOUT t=%0.3f ns after %0d cycles", $realtime, lock_wait_cycles);
        $display("  PATH1: locked=%b code=%b lead=%b measure=%b wait=%b meta=%b sync=%b prev_valid=%b prev_lead=%b",
                 TESTBED.u_gcd.locked1, TESTBED.u_gcd.code1,
                 TESTBED.u_gcd.lead_lag1, TESTBED.u_gcd.measure1,
                 TESTBED.u_gcd.u_ctl1.wait_count,
                 TESTBED.u_gcd.u_ctl1.pd_meta,
                 TESTBED.u_gcd.u_ctl1.pd_sync,
                 TESTBED.u_gcd.u_ctl1.prev_valid,
                 TESTBED.u_gcd.u_ctl1.prev_lead_lag);
        $display("  PATH2: locked=%b code=%b lead=%b measure=%b wait=%b meta=%b sync=%b prev_valid=%b prev_lead=%b enable=%b",
                 TESTBED.u_gcd.locked2, TESTBED.u_gcd.code2,
                 TESTBED.u_gcd.lead_lag2, TESTBED.u_gcd.measure2,
                 TESTBED.u_gcd.u_ctl2.wait_count,
                 TESTBED.u_gcd.u_ctl2.pd_meta,
                 TESTBED.u_gcd.u_ctl2.pd_sync,
                 TESTBED.u_gcd.u_ctl2.prev_valid,
                 TESTBED.u_gcd.u_ctl2.prev_lead_lag,
                 TESTBED.u_gcd.locked1);
        `elsif GATE
        $display("GATE_TIMEOUT t=%0.3f ns after %0d cycles", $realtime, lock_wait_cycles);
        $display("  PATH1: locked=%b code=%b lead=%b clk_o1=%b",
                 TESTBED.u_gcd.locked1, TESTBED.u_gcd.code1,
                 TESTBED.u_gcd.lead_lag1, clk_o1);
        $display("  PATH2: locked=%b code=%b lead=%b clk_o2=%b",
                 TESTBED.u_gcd.locked2, TESTBED.u_gcd.code2,
                 TESTBED.u_gcd.lead_lag2, clk_o2);
        `elsif POST
        $display("POST_TIMEOUT t=%0.3f ns after %0d cycles", $realtime, lock_wait_cycles);
        $display("  PATH1: locked=%b code=%b lead=%b clk_o1=%b",
                 TESTBED.u_gcd.locked1, TESTBED.u_gcd.code1,
                 TESTBED.u_gcd.lead_lag1, clk_o1);
        $display("  PATH2: locked=%b code=%b lead=%b clk_o2=%b",
                 TESTBED.u_gcd.locked2, TESTBED.u_gcd.code2,
                 TESTBED.u_gcd.lead_lag2, clk_o2);
        `endif
        `HW2_RESULT_BANNER(1'b0, "DLL TEST", "LOCK TIMEOUT: controllers did not both lock in time.")
        $fatal(1, "DLL did not lock within %0d input cycles", MAX_LOCK_CYCLES);
    end

    $display("DLL lock detected at input cycle %0d", ref_edge_count);
    repeat (4) @(negedge clk_in);
    check_enable = 1;
    repeat (VERIFY_CYCLES) @(negedge clk_in);
    check_enable = 0;

    if (fail_flag || (o1_checks < VERIFY_CYCLES-1) ||
        (o2_checks < VERIFY_CYCLES-1)) begin
        `HW2_RESULT_BANNER(1'b0, "DLL TEST", "Locked outputs failed phase, period or activity checks.")
        $fatal(1, "DLL TEST FAILED: o1_checks=%0d, o2_checks=%0d",
                 o1_checks, o2_checks);
    end

    verify_absolute_delay;
    `ifdef DLL_UNIT_DIAG
    $display("DLL UNIT-DELAY DIAGNOSTIC PASSED (NOT 1 GHz timing verification)");
    `HW2_RESULT_BANNER(1'b1, "DLL UNIT-DELAY DIAGNOSTIC", "20 ns clock; targets 10/20 ns. NOT 1 GHz timing sign-off.")
    `else
    $display("DLL TEST PASSED: locked, periods checked, physical delays verified");
    `HW2_RESULT_BANNER(1'b1, "DLL 1 GHz TEST", "Targets 0.5/1.0 ns passed with the loaded model; check SDF.")
    `endif

    repeat (2) @(negedge clk_in);
    $finish;
end

endmodule

`endif
