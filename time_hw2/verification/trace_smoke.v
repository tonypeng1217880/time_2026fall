`timescale 1ns/1ps
// Optional white-box diagnostics for local smoke tests only.
module trace_smoke;
    always @(TESTBED.u_gcd.code1)
        $display("TRACE %0t code1=%0d PD1=%b", $time,
                 TESTBED.u_gcd.code1, TESTBED.u_gcd.lead_lag1);
    always @(TESTBED.u_gcd.code2)
        $display("TRACE %0t code2=%0d PD2=%b", $time,
                 TESTBED.u_gcd.code2, TESTBED.u_gcd.lead_lag2);
    always @(TESTBED.u_gcd.locked1 or TESTBED.u_gcd.locked2)
        $display("TRACE %0t locked1=%b locked2=%b", $time,
                 TESTBED.u_gcd.locked1, TESTBED.u_gcd.locked2);
endmodule
