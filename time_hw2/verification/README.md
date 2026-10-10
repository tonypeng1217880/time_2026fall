# Homework 2 DLL integration

The working RTL is `../01_RTL/gcd.v`, with top module `gcd`. It contains two
independent instances each of `tdl`, `pd`, and `controller`; no generate loops
or additional RTL files are required. The top adds a `locked` output for the
testbench. Both TDL inputs remain connected to the continuous input clock,
including during acquisition. The controller updates a code only once per
eight input cycles. Changing a mux selection can still create acquisition
transients; this is not a glitch-free clock-switching design.

## Acquisition (50% duty-cycle, 1 GHz input)

1. Channel 1 compares feedback to the inverted input clock and finds a delay
   near half a period. The physical inverter delay shifts this reference and
   must be included in the real library/SDF results.
2. Channel 2 starts after channel 1 locks; channel 1's code remains frozen.
3. Each controller resets/re-arms its PD for each code observation. Channel 1
   releases PD reset after a rising input edge; channel 2 releases it after
   a falling edge. These are local PD resets, not global controller resets.
4. For channel 2, delays below roughly T/2 can report lag, even though the
   desired delay is T. Its forward-acquisition mode continues scanning upward
   until it encounters lead, then uses the first subsequent lag to stop near
   T. This avoids hard-coding a target code or getting stuck at code zero.
5. Lock stops the code changes; it does not stop either output clock.

This strategy assumes the minimum delay is below T/2, code delay is monotonic,
the range covers T, and no code step skips the half-period-wide acquisition
region. Check these assumptions with the real TDL sweep. A single direction
reversal is a basic lock criterion, not a jitter-qualified phase-error meter.
Eight cycles allow settling and synchronization; they are not an averaged
measurement or a proof of metastability immunity. Close-edge behavior and
reset recovery/removal need the actual library model.

## Pattern and flow

- PD_TEST exercises the assignment's nine offsets. Zero offset is reported,
  without inventing a required direction for a racing detector.
- TDL_TEST measures valid codes 0 through 47. Delays and monotonicity are
  measured, not taken from the comments in the RTL.
- DLL_TEST waits for the DUT's locked flag with a 2000-cycle timeout, then
  independently checks 32 cycles of phase and period. The configurable 30 ps
  tolerance is a local engineering criterion, not an assignment requirement.
- After lock only, the pattern pauses and drains the input, sends one isolated
  pulse, and measures both physical delays. This rejects zero-cycle and
  extra-cycle false locks that periodic phase checking alone cannot detect.
  Continuous input is used throughout acquisition and the steady-state check.
- TESTBED connects the new locked port. The existing stage-local include files
  continue to refer to the shared files in 00_TESTBED.
- RTL simulation now loads TSMC90_SIM because the RTL instantiates library
  cells. Synthesis preserves the explicit PD and delay cells while leaving
  the TDL decoder/mux and controllers available for mapping.

On the course Linux host, run in `01_RTL`:

```sh
make vcs_rtl TEST_MODE=PD_TEST
make vcs_rtl TEST_MODE=TDL_TEST
make vcs_rtl TEST_MODE=DLL_TEST
```

The clock-delay tests require nonzero cell delays. A zero-delay RTL library
cannot validate this design. Run the course DC and SDF gate flow for the actual
pre-layout timing results. Standalone PD/TDL gate tests additionally need their
own synthesized modules and matching SDF; the top-level netlist is not a
substitute for a properly annotated standalone test.

## Local smoke checks (NOT sign-off)

`smoke_cells.v` is an approximate test-only model, NOT the TSMC library. It
does not model load, slew, timing checks, or PVT corners. It is deliberately
excluded from all normal synthesis/simulation file lists. Never submit its
results as the assignment's library/SDF timing results.

```powershell
./run_smoke.ps1 -IcarusBin 'path/to/iverilog/bin'
```

The runner checks PD, TDL, full integration, two delay scalings, and an
insufficient-delay-range timeout. Two deliberately incorrect DUTs also verify
that the pattern rejects zero-cycle and two-cycle false locks. Logs and compiled test programs are placed
in `results/`. No DC, actual TSMC90 library simulation, or APR has been run here.

Local verification completed on 2026-10-10: all eight checks passed (the
insufficient-range, zero-cycle, and two-cycle cases passed by being rejected).
Nominal approximate-model delays were 0.506 ns / 1.003 ns, with both loops
locked by input cycle 555. The 0.98x and 1.15x delay-model runs also passed.
These numbers characterize the smoke models only, not the TSMC implementation.

The portable test tool was obtained from the [Icarus Windows package page](https://bleyer.org/icarus/)
and unpacked with [innoextract](https://constexpr.org/innoextract/); no system
installation or PATH changes are required.
