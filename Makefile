.DEFAULT_GOAL := help

VLSI ?= ../vlsi-toolkit/vlsi
TOOL_SETUP ?= ../vlsi-toolkit/scripts/tool_setup_and_check.sh
DESIGN ?= and_gate
SIM ?=
CONFIG ?=
SIM_NAME = $(if $(strip $(SIM)),$(SIM),verilator)

DIRECTED_CONFIG ?= $(if $(strip $(CONFIG)),$(CONFIG),config/simulation/directed/$(DESIGN).toml)
UVM_CONFIG ?= $(if $(strip $(CONFIG)),$(CONFIG),config/simulation/uvm/$(DESIGN).toml)
SYNTH_CONFIG ?= $(if $(strip $(CONFIG)),$(CONFIG),config/synthesis/$(DESIGN).toml)
TIMING_CONFIG ?= $(if $(strip $(CONFIG)),$(CONFIG),config/timing/$(DESIGN).toml)
SIM_WAVEFORM ?= build/sim/$(DESIGN)-$(SIM_NAME)/waveforms/$(DESIGN).vcd
UVM_WAVEFORM ?= build/sim/$(DESIGN)-uvm-verilator/waveforms/$(DESIGN)_uvm.vcd
WAVEFORM ?=
LIBERTY ?=

SIM_OPTION = $(if $(strip $(SIM)),--sim "$(SIM)",)
SIM_BUILD_OPTION = $(if $(strip $(SIM)),--build-dir "build/sim/$(DESIGN)-$(SIM)",)

.PHONY: help doctor setup setup-check smoke clean clean-dry-run sim run uvm synth synth-mapped timing library-check wave wave-uvm

help:
	@printf '%s\n' \
	  'VLSI Toolkit Demo RTL targets:' \
	  '  make sim [DESIGN=and_gate|mux_2x4|counter_4bit|adder_4bit] [SIM=iverilog|verilator]' \
	  '  make uvm [DESIGN=and_gate] [CONFIG=FILE]' \
	  '  make synth [DESIGN=and_gate|mux_2x4|counter_4bit|adder_4bit] | make synth-mapped [DESIGN=name]' \
	  '  make timing [DESIGN=and_gate|mux_2x4|counter_4bit|adder_4bit]' \
	  '  Use CONFIG=FILE or WAVEFORM=FILE to override automatic selection' \
	  '  make wave [DESIGN=and_gate|mux_2x4|counter_4bit|adder_4bit] | make wave-uvm [DESIGN=and_gate]' \
	  '  make doctor | library-check LIBERTY=path/to/cells.lib' \
	  '  make setup | setup-check | smoke' \
	  '  make clean-dry-run | clean'

doctor:
	$(VLSI) doctor

setup:
	$(TOOL_SETUP)

setup-check:
	$(TOOL_SETUP) --check-only

smoke:
	$(TOOL_SETUP) --smoke-only

clean-dry-run:
	$(VLSI) clean --dry-run

clean:
	$(VLSI) clean

sim run:
	./scripts/simulation/directed/run_directed.sh "$(DIRECTED_CONFIG)" $(SIM_OPTION) $(SIM_BUILD_OPTION)

uvm:
	./scripts/simulation/uvm/run_uvm.sh "$(UVM_CONFIG)"

synth:
	./scripts/synthesis/synth.sh "$(SYNTH_CONFIG)"

synth-mapped:
	./scripts/synthesis/synth.sh "$(TIMING_CONFIG)"

timing:
	./scripts/timing/timing.sh "$(TIMING_CONFIG)"

library-check:
	@test -n "$(LIBERTY)" || { echo 'Set LIBERTY, for example: make library-check LIBERTY=/path/to/cells.lib' >&2; exit 2; }
	$(VLSI) library check --liberty "$(LIBERTY)"

wave:
	gtkwave "$(if $(strip $(WAVEFORM)),$(WAVEFORM),$(SIM_WAVEFORM))"

wave-uvm:
	gtkwave "$(if $(strip $(WAVEFORM)),$(WAVEFORM),$(UVM_WAVEFORM))"
