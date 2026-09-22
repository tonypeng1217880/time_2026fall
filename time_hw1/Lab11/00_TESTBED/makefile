.PHONY: prepare_syn prepare_apr syn syn_dv read_dv_rtl read_ddc \
        vcs_rtl vcs_gate vcs_post irun_rtl irun_gate irun_post \
        xrun_rtl xrun_gate xrun_post nWave verdi_rtl verdi_gate \
        verdi_post apr_init clean

top_design := gcd
source_file := filelist.f
output_file := simv
log_file := vcs.log
syn_tcl := syn.tcl
syn_log := syn.log

num_CPU_cores := 8
TIMESCALE := -timescale=1ns/1ps
TIMESCALE_CADENCE := -timescale 1ns/1ps
VERDI := /usr/cad/synopsys/verdi/2019.06
TSMC90_SIM := /usr/cadtool/ee5216/CBDK_TSMC90GUTM_Arm_f1.0/CIC/Verilog/tsmc090.v

VCS_COMMON = vcs $(TIMESCALE) \
	-j$(num_CPU_cores) \
	-sverilog \
	+v2k \
	-full64 \
	-Mupdate \
	-R \
	-debug_access+all \
	+incdir+. \
	+incdir+../00_TESTBED \
	-f $(source_file) \
	-o $(output_file) \
	-l $(log_file) \
	-P $(VERDI)/share/PLI/VCS/linux64/novas.tab \
	   $(VERDI)/share/PLI/VCS/linux64/pli.a

VCS_RTL_SIM = $(VCS_COMMON) \
	+define+RTL \
	+notimingchecks

VCS_GATE_SIM = $(VCS_COMMON) \
	-v $(TSMC90_SIM) \
	+define+GATE \
	+maxdelays \
	+neg_tchk \
	+nowarnNTCDSN

VCS_POST_SIM = $(VCS_COMMON) \
	-v $(TSMC90_SIM) \
	+define+POST \
	+maxdelays \
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

IRUN_RTL_SIM = $(IRUN_COMMON) -notimingchecks -define RTL
IRUN_GATE_SIM = $(IRUN_COMMON) -v $(TSMC90_SIM) -maxdelays -define GATE
IRUN_POST_SIM = $(IRUN_COMMON) -v $(TSMC90_SIM) -maxdelays -define POST

XRUN_COMMON = xrun -f $(source_file) \
	-mcl $(num_CPU_cores) \
	-incdir . \
	-incdir ../00_TESTBED \
	-override_precision \
	$(TIMESCALE_CADENCE) \
	-sdf_precision 1ps \
	-loadpli1 debpli:novas_pli_boot \
	-debug

XRUN_RTL_SIM = $(XRUN_COMMON) -notimingchecks -define RTL
XRUN_GATE_SIM = $(XRUN_COMMON) -v $(TSMC90_SIM) -maxdelays -define GATE
XRUN_POST_SIM = $(XRUN_COMMON) -v $(TSMC90_SIM) -maxdelays -define POST

DC_SHELL = dcnxt_shell -f $(syn_tcl) \
	-x "set_host_options -max_cores $(num_CPU_cores)" \
	-output_log_file $(syn_log)

DC_SHELL_GUI = dcnxt_shell -f $(syn_tcl) \
	-x "set_host_options -max_cores $(num_CPU_cores)" \
	-output_log_file $(syn_log) \
	-gui

READ_RTL_GUI = dcnxt_shell -x 'read_verilog ../01_RTL/$(top_design).v' -gui
READ_DDC_GUI = dcnxt_shell -x 'read_ddc $(top_design)_SYN.ddc' -gui

INNOVUS_INIT = innovus -cpus $(num_CPU_cores) \
	-init ./cmd/run_apr.cmd \
	-log ./log/run_apr.log \
	-cmd ./log/run_apr.cmdlog

prepare_syn:
	@mkdir -p Report Netlist

prepare_apr:
	@mkdir -p DBS StreamOut timingReports log

vcs_rtl:
	$(VCS_RTL_SIM)

vcs_gate:
	$(VCS_GATE_SIM)

vcs_post:
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
	nWave -ssf *.fsdb

verdi_rtl:
	verdi -ssf *.fsdb -sv +incdir+. +incdir+../00_TESTBED -f $(source_file) +define+RTL +v2k -autoalias

verdi_gate:
	verdi -ssf *.fsdb -sv +incdir+. +incdir+../00_TESTBED -v $(TSMC90_SIM) -f $(source_file) +define+GATE +v2k -autoalias

verdi_post:
	verdi -ssf *.fsdb -sv +incdir+. +incdir+../00_TESTBED -v $(TSMC90_SIM) -f $(source_file) +define+POST +v2k -autoalias

clean:
	rm -rf *.fsdb csrc simv simv.daidir ucli.key novas.* *.log *.sdf.X
	rm -rf INCA_libs xcelium.d nWaveLog verdiLog
	rm -rf alib-* *.svf dwsvf* *.pvl *.syn *.mr
	rm -rf Report Netlist DBS StreamOut timingReports log
	rm -rf *.globals *.enc *.inn *.rpt *.rpt.dat *.CCOPT.spec
