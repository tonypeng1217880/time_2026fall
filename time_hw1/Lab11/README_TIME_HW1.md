# TIME HW1 flow based on the ICLAB Lab11 structure

This directory is the TSMC90, core-only flow for the `gcd` square-root RTL.
The original `time_hw1/verilog` directory is not part of this flow and is kept
unchanged as a reference.

## Active stages

- `00_TESTBED`: shared RTL/GATE/POST testbench and pattern
- `01_RTL`: `gcd.v`
- `02_SYN`: TSMC90 Design Compiler setup and synthesis Tcl
- `03_GATE`: links to `gcd_SYN.v` and `gcd_SYN.sdf`
- `05_APR`: TSMC90 MMMC, IO placement, and modular Innovus commands
- `06_POST`: links to `gcd_APR.v` and `gcd_APR.sdf`

The copied ISP, CHIP, SRAM, U18 LEF/LIB/RC, and pad files are legacy reference
material only. No active script in this flow references them.

## Run order

1. In `01_RTL`, run `./01_run_vcs_rtl`.
2. In `02_SYN`, run `./01_run_dc_shell`, then `./08_check`.
3. In `03_GATE`, run `./01_run_vcs_gate`; it refreshes the synthesis links.
4. In `05_APR`, run `./00_combine` and `source ./01_setenv` if the server needs
   the OA environment override.
5. Run `make apr_init`, then in Innovus run `source ./cmd/Lab11_APR.cmd`.
6. In `06_POST`, run `./01_run_vcs_post`; it refreshes the APR links.

## Process-specific notes

- DC uses `slow.db` and `fast.db` from the TSMC90 SynopsysDC directory.
- APR and CTS reuse the `gcd_SYN.sdc` written by Design Compiler so clock,
  I/O delay, and TSMC90 load constraints stay consistent.
- Gate/post simulation uses the TSMC90 `tsmc090.v` model.
- APR uses `VDD/VSS`, the `M1`-`M9` stack, TSMC90 filler/tie cells, and the
  TSMC90 stream-out map.
- Automatic antenna-diode insertion is intentionally disabled until the valid
  TSMC90 antenna diode cell name is confirmed. Antenna verification remains on.
