.PHONY: prepare_syn prepare_apr syn syn_dv read_dv_rtl read_ddc \
        vcs_rtl vcs_gate vcs_post irun_rtl irun_gate irun_post \
        xrun_rtl xrun_gate xrun_post nWave verdi_rtl verdi_gate \
        verdi_post apr_init clean clean_vcs check_verdi

top_design := gcd
source_file := filelist.f
output_file := simv
log_file := vcs.log
syn_tcl := syn.tcl
syn_log := syn.log

num_CPU_cores := 4
TIMESCALE := -timescale=1ns/1ps
TIMESCALE_CADENCE := -timescale 1ns/1ps
TEST_MODE ?= DLL_TEST
# Keep the compile-time PLI, runtime dumper and waveform viewer on one version.
# Override explicitly with: make vcs_gate VERDI=/path/to/verdi
VERDI ?= /usr/cad/synopsys/verdi/2022.06
VERDI_PLI_DIR = $(patsubst %/novas.tab,%,$(firstword $(wildcard $(VERDI)/share/PLI/VCS/LINUX64/novas.tab $(VERDI)/share/PLI/VCS/linux64/novas.tab)))
VERDI_ENV = env VERDI_HOME="$(VERDI)" NOVAS_HOME="$(VERDI)"
# Do not reuse the original csrc directory linked with the old 2019 PLI.
VCS_BUILD_DIR ?= csrc_fsdb_$(notdir $(VERDI))
TSMC90_SIM := /usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Verilog/tsmc090.v
RTL_CELL_SIM := ../00_TESTBED/RTL_CELL_MODEL.v

VCS_COMMON = $(VERDI_ENV) vcs $(TIMESCALE) \
	-j$(num_CPU_cores) \
	-sverilog \
	+v2k \
	-full64 \
	-Mupdate \
	-Mdir=$(VCS_BUILD_DIR) \
	-R \
	-debug_access+all \
	+incdir+. \
	+incdir+../00_TESTBED \
	-f $(source_file) \
	-o $(output_file) \
	-l $(log_file) \
	-P "$(VERDI_PLI_DIR)/novas.tab" \
	   "$(VERDI_PLI_DIR)/pli.a"

VCS_RTL_SIM = $(VCS_COMMON) \
	-v $(RTL_CELL_SIM) \
	+define+RTL \
	+define+$(TEST_MODE) \
	+notimingchecks

VCS_GATE_SIM = $(VCS_COMMON) \
	-v $(TSMC90_SIM) \
	+define+GATE \
	+define+$(TEST_MODE) \
	+maxdelays \
	+neg_tchk \
	+nowarnNTCDSN

VCS_POST_SIM = $(VCS_COMMON) \
	-v $(TSMC90_SIM) \
	+define+POST \
	+define+$(TEST_MODE) \
	+mindelays \
	+notimingcheck \
	+neg_tchk \
	+nowarnNTCDSN

IRUN_COMMON = irun -f $(source_file) \
	-incdir . \
	-incdir ../00_TESTBED \
	-override_precision \
	$(TIMESCALE_CADENCE) \
	-sdf_precision 1ps \
	-loadpli1 debpli:novas_pli_boot \
	-debug

IRUN_RTL_SIM = $(IRUN_COMMON) -v $(RTL_CELL_SIM) -notimingchecks -define RTL -define $(TEST_MODE)
IRUN_GATE_SIM = $(IRUN_COMMON) -v $(TSMC90_SIM) -maxdelays -define GATE -define $(TEST_MODE)
IRUN_POST_SIM = $(IRUN_COMMON) -v $(TSMC90_SIM) -mindelays -notimingchecks -define POST -define $(TEST_MODE)

XRUN_COMMON = xrun -f $(source_file) \
	-mcl $(num_CPU_cores) \
	-incdir . \
	-incdir ../00_TESTBED \
	-override_precision \
	$(TIMESCALE_CADENCE) \
	-sdf_precision 1ps \
	-loadpli1 debpli:novas_pli_boot \
	-debug

XRUN_RTL_SIM = $(XRUN_COMMON) -v $(RTL_CELL_SIM) -notimingchecks -define RTL -define $(TEST_MODE)
XRUN_GATE_SIM = $(XRUN_COMMON) -v $(TSMC90_SIM) -maxdelays -define GATE -define $(TEST_MODE)
XRUN_POST_SIM = $(XRUN_COMMON) -v $(TSMC90_SIM) -mindelays -notimingchecks -define POST -define $(TEST_MODE)

DC_SHELL = dc_shell -f $(syn_tcl) | tee $(syn_log)

DC_SHELL_GUI = dc_shell -f $(syn_tcl) \
	-output_log_file $(syn_log) \
	-gui

READ_RTL_GUI = dc_shell -x 'read_verilog ../01_RTL/$(top_design).v' -gui
READ_DDC_GUI = dc_shell -x 'read_ddc $(top_design)_SYN.ddc' -gui

INNOVUS_INIT = env -u OA_HOME innovus -cpus $(num_CPU_cores) \
	-init ./cmd/run_apr.cmd \
	-log ./log/run_apr.log \
	-cmd ./log/run_apr.cmdlog

prepare_syn:
	@mkdir -p Report Netlist

prepare_apr:
	@mkdir -p DBS StreamOut timingReports log
	@test -r ../02_SYN/Netlist/$(top_design)_SYN.v || { \
		echo "ERROR: missing ../02_SYN/Netlist/$(top_design)_SYN.v; run synthesis first."; \
		exit 1; \
	}
	@ln -sfn ../02_SYN/Netlist/$(top_design)_SYN.v $(top_design)_SYN.v

check_verdi:
	@test -n "$(VERDI_PLI_DIR)" || { echo "ERROR: No 64-bit VCS novas.tab under $(VERDI)/share/PLI/VCS"; exit 1; }
	@test -r "$(VERDI_PLI_DIR)/pli.a" || { echo "ERROR: Missing $(VERDI_PLI_DIR)/pli.a"; exit 1; }
	@echo "FSDB: VERDI_HOME=NOVAS_HOME=$(VERDI); PLI=$(VERDI_PLI_DIR)"

vcs_rtl: check_verdi
	$(VCS_RTL_SIM)

vcs_gate: check_verdi
	$(VCS_GATE_SIM)

vcs_post: check_verdi
	$(VCS_POST_SIM)

irun_rtl:
	$(IRUN_RTL_SIM)

irun_gate:
	$(IRUN_GATE_SIM)

irun_post:
	$(IRUN_POST_SIM)

xrun_rtl:
	$(XRUN_RTL_SIM)

xrun_gate:
	$(XRUN_GATE_SIM)

xrun_post:
	$(XRUN_POST_SIM)

syn: prepare_syn
	$(DC_SHELL)

syn_dv: prepare_syn
	$(DC_SHELL_GUI)

read_dv_rtl:
	$(READ_RTL_GUI)

read_ddc:
	$(READ_DDC_GUI)

apr_init: prepare_apr
	$(INNOVUS_INIT)

nWave:
	$(VERDI_ENV) "$(VERDI)/bin/nWave" -ssf *.fsdb

verdi_rtl:
	$(VERDI_ENV) "$(VERDI)/bin/verdi" -ssf *.fsdb -sv +incdir+. +incdir+../00_TESTBED -v $(RTL_CELL_SIM) -f $(source_file) +define+RTL +define+$(TEST_MODE) +v2k -autoalias

verdi_gate:
	$(VERDI_ENV) "$(VERDI)/bin/verdi" -ssf *.fsdb -sv +incdir+. +incdir+../00_TESTBED -v $(TSMC90_SIM) -f $(source_file) +define+GATE +define+$(TEST_MODE) +v2k -autoalias

verdi_post:
	$(VERDI_ENV) "$(VERDI)/bin/verdi" -ssf *.fsdb -sv +incdir+. +incdir+../00_TESTBED -v $(TSMC90_SIM) -f $(source_file) +define+POST +define+$(TEST_MODE) +v2k -autoalias

clean_vcs:
	rm -rf $(VCS_BUILD_DIR) csrc simv simv.daidir ucli.key novas.* *.log *.sdf.X

clean:
	rm -rf *.fsdb $(VCS_BUILD_DIR) csrc simv simv.daidir ucli.key novas.* *.log *.sdf.X
	rm -rf INCA_libs xcelium.d nWaveLog verdiLog
	rm -rf alib-* *.svf dwsvf* *.pvl *.syn *.mr
	rm -rf Report Netlist DBS StreamOut timingReports log
	rm -rf *.globals *.enc *.inn *.rpt *.rpt.dat *.CCOPT.spec
