# VLSI Toolkit Demo RTL

A small project for exercising the VLSI Toolkit flows with an AND gate, a
4-to-1 mux, a 4-bit counter, and a structural 4-bit adder. The AND gate has
directed and UVM testbenches; the mux, counter, and adder currently have
directed testbenches. The adder's `full_adder` module is instantiated four
times by `ripple_carry_adder_4bit`.

## Workflow at a glance

1. Check that the toolkit tools are available.
2. Run the directed testbench with Verilator or Icarus Verilog.
3. Optionally run the UVM testbench with Verilator.
4. Inspect the generated waveforms with GTKWave.
5. Run generic synthesis, or map the design to Sky130 and run OpenSTA timing.

Run commands from this demo project's root. Examples show direct CLI options
and TOML manifest forms for simulation, synthesis, and timing.

For shorter project commands, use the root Makefile:

```bash
make help
make doctor
make setup
make setup-check
make sim
make sim SIM=iverilog
make sim DESIGN=mux_2x4
make sim DESIGN=counter_4bit SIM=iverilog
make sim DESIGN=adder_4bit
make sim DESIGN=adder_4bit SIM=iverilog
make uvm
make synth
make synth DESIGN=mux_2x4
make synth-mapped
make synth-mapped DESIGN=counter_4bit
make synth DESIGN=adder_4bit
make synth-mapped DESIGN=adder_4bit
make timing
make timing DESIGN=mux_2x4
make timing DESIGN=adder_4bit
make wave
make wave DESIGN=counter_4bit
make wave DESIGN=adder_4bit
make wave DESIGN=adder_4bit SIM=iverilog
make wave-uvm
make clean-dry-run
```

Pass `DESIGN=name` to select the matching design manifests.
`CONFIG=path/to/manifest.toml` and `WAVEFORM=path/to/file.vcd` override the
selected manifest and waveform path when needed.
Mapped synthesis and timing require a compatible Liberty file and constraints
configured in that design's timing manifest.
Run `make synth-mapped` before `make timing`.
The available UVM testbench is for `and_gate`; the mux, counter, and adder have
no UVM testbench or UVM manifest yet. Each directed manifest writes a design-named
VCD under that design's build directory, where `make wave DESIGN=mux_2x4` and
`make wave DESIGN=counter_4bit` look by default. See
[`initial-start.md`](initial-start.md) for the adder's source layout, TOML
fields, and commands for simulation, waveform viewing, synthesis, and timing.

## Project contents

| Path | Purpose |
| --- | --- |
| `rtl/and_gate.sv` | AND-gate design under test |
| `rtl/mux_2x4.sv` | 4-to-1 mux design under test |
| `rtl/counter_4bit.sv` | 4-bit counter design under test |
| `rtl/full_adder.sv`, `rtl/adder_4bit.sv` | Full-adder cell and structural 4-bit adder top |
| `tb/directed/and_gate_tb.sv` | AND-gate directed testbench |
| `tb/tb_mux_2x4.sv`, `tb/tb_counter_4bit.sv` | Mux and counter directed testbenches |
| `tb/directed/tb_4bit_adder.sv` | Structural adder directed testbench |
| `tb/uvm/` | UVM interfaces, packages, agents, environment, sequences, tests, and top |
| `constraints/abc/` | ABC input-driver and output-load assumptions |
| `constraints/sdc/` | Example OpenSTA timing constraints |
| `config/` | Directed, UVM, synthesis, and timing TOML manifests |
| `scripts/` | Directed, UVM, synthesis, and timing command wrappers |
| `build/` | Generated simulations, netlists, reports, and logs by flow |

The source tree follows the same layout produced by `vlsi init`. Constraint
files are grouped separately from the RTL sources.

```text
.
├── config/
│   ├── simulation/
│   │   ├── directed/and_gate.toml
│   │   ├── directed/mux_2x4.toml
│   │   ├── directed/counter_4bit.toml
│   │   ├── directed/adder_4bit.toml
│   │   └── uvm/and_gate.toml
│   ├── synthesis/{and_gate,mux_2x4,counter_4bit,adder_4bit}.toml
│   └── timing/{and_gate,mux_2x4,counter_4bit,adder_4bit}.toml
├── rtl/
│   ├── include/
│   ├── and_gate.sv
│   ├── mux_2x4.sv
│   ├── full_adder.sv
│   ├── adder_4bit.sv
│   └── counter_4bit.sv
├── constraints/
│   ├── abc/{and_gate,mux_2x4,counter_4bit,adder_4bit}.abc
│   └── sdc/{and_gate,mux_2x4,counter_4bit,adder_4bit}.sdc
├── tb/
│   ├── directed/and_gate_tb.sv
│   ├── directed/tb_4bit_adder.sv
│   └── uvm/
│       ├── interfaces/
│       ├── packages/
│       ├── agents/
│       ├── env/
│       ├── sequences/
│       ├── tests/
│       └── top/
├── scripts/
│   ├── _common.sh
│   ├── simulation/
│   │   ├── directed/run_directed.sh
│   │   └── uvm/run_uvm.sh
│   ├── synthesis/synth.sh
│   └── timing/timing.sh
├── tests/                      # unit and regression tests
└── build/                      # generated flow outputs (Git ignored)
```

The wrappers can be used after changing to the project root:

```bash
./scripts/simulation/directed/run_directed.sh
./scripts/simulation/directed/run_directed.sh --sim iverilog
./scripts/simulation/uvm/run_uvm.sh
./scripts/synthesis/synth.sh
./scripts/timing/timing.sh
```

The wrappers use the `and_gate` manifests by default. Select the mux or counter
from the Makefile with `DESIGN=name`, or pass a manifest path to a wrapper (or
use `--config MANIFEST.toml`):

```bash
./scripts/simulation/directed/run_directed.sh config/simulation/directed/my_design.toml
./scripts/simulation/uvm/run_uvm.sh config/simulation/uvm/my_design.toml
./scripts/synthesis/synth.sh config/synthesis/my_design.toml
./scripts/timing/timing.sh config/timing/my_design.toml
```

For example, `make sim DESIGN=mux_2x4`, `make synth DESIGN=counter_4bit`,
`make synth-mapped DESIGN=mux_2x4`, and `make timing DESIGN=counter_4bit`
select the corresponding design manifests without spelling out their paths.

Give each design's simulation manifest a unique `build_dir` so its compile
log, run log, and requested waveform are kept separate.

Each wrapper defaults to this project's `and_gate` manifest. It also accepts a
different manifest path as its first argument (or `--config MANIFEST.toml`),
so additional designs can use the same flow scripts. The direct CLI examples
below remain useful when you want to pass settings explicitly.

## 1. Check the tools

This project expects `vlsi-toolkit` to be checked out beside it. Check the
available tools from the demo directory:

```bash
../vlsi-toolkit/vlsi doctor
```

If tools need to be installed, run the toolkit setup script. It can install
missing Ubuntu packages and build the supported Verilator and OpenSTA versions:

```bash
../vlsi-toolkit/scripts/tool_setup_and_check.sh
```

See the toolkit's [installation guide](../vlsi-toolkit/docs/INSTALLATION.md)
for setup modes and requirements.

## 2. Run the directed simulation

Run the self-checking testbench directly with Verilator:

```bash
../vlsi-toolkit/vlsi run --sim verilator \
  --project . \
  --top and_gate_tb \
  --rtl rtl/and_gate.sv \
  --tb tb/directed/and_gate_tb.sv \
  --waveform \
  --build-dir build/sim/plain-verilator
```

Run the same testbench directly with Icarus Verilog:

```bash
../vlsi-toolkit/vlsi run --sim iverilog \
  --project . \
  --top and_gate_tb \
  --rtl rtl/and_gate.sv \
  --tb tb/directed/and_gate_tb.sv \
  --waveform \
  --build-dir build/sim/plain-iverilog
```

The equivalent manifest-based run uses
`config/simulation/directed/and_gate.toml`, which selects Verilator:

```bash
../vlsi-toolkit/vlsi run --config config/simulation/directed/and_gate.toml
```

Override the manifest's simulator to use Icarus:

```bash
../vlsi-toolkit/vlsi run --config config/simulation/directed/and_gate.toml --sim iverilog
```

## 3. Run the UVM simulation

UVM uses Verilator and its UVM 2020.3.2 sources. If the toolkit cannot locate
the UVM package automatically, set `VERILATOR_UVM_DIR` to the directory
containing `uvm_pkg_all_v2020_3_2_nodpi.svh`:

```bash
export VERILATOR_UVM_DIR="/path/to/verilator/test_regress/t/uvm"
```

Run UVM directly by listing its interface, package, and testbench top:

```bash
../vlsi-toolkit/vlsi run --sim verilator --uvm --jobs 1 \
  --project . \
  --top and_gate_tb_top \
  --rtl rtl/and_gate.sv \
  --tb tb/uvm/interfaces/and_gate_if.sv \
  --tb tb/uvm/packages/and_gate_pkg.sv \
  --tb tb/uvm/top/and_gate_tb_top.sv \
  --include tb/uvm \
  --build-dir build/sim/uvm-verilator
```

Or load the UVM settings from the manifest:

```bash
../vlsi-toolkit/vlsi run --config config/simulation/uvm/and_gate.toml
```

The manifest limits Verilator to one build job. A first UVM build may take
several minutes. The scoreboard checks all four AND-gate input combinations.

## 4. Open the waveforms

The manifests write simulation outputs under `build/sim/and_gate-verilator/`
and `build/sim/and_gate-uvm-verilator/`.
Open their VCD files with GTKWave:

```bash
gtkwave build/sim/and_gate-verilator/waveforms/and_gate.vcd
gtkwave build/sim/and_gate-uvm-verilator/waveforms/and_gate_uvm.vcd
```

Direct runs write outputs to the `--build-dir` selected in their command. Use
the path printed by `vlsi run` if you choose a different build directory.

## 5. Synthesize the design

Generic synthesis runs Yosys without mapping to a particular cell library.
Run it directly:

```bash
../vlsi-toolkit/vlsi synth \
  --project . \
  --top and_gate \
  --rtl rtl/and_gate.sv \
  --build-dir build/synth/generic
```

Or use the synthesis settings in `config/synthesis/and_gate.toml`:

```bash
../vlsi-toolkit/vlsi synth --config config/synthesis/and_gate.toml
```

Generic synthesis checks the flow and writes netlists and reports. It does not
produce a technology-specific timing result. For that, continue with mapped
synthesis and OpenSTA below.

## 6. Run mapped synthesis and timing analysis

OpenSTA needs a mapped netlist, an SDC constraints file, and the matching
Liberty timing library. This host has a Sky130 HD typical-corner library at the
path below. Replace it with a compatible installed Liberty file on another
system. Load the OpenSTA helper if `sta` is not already on `PATH`:

```bash
source "$HOME/opt/opensta/opensta-env.sh"
export LIBERTY="$HOME/opt/pdk/sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"
../vlsi-toolkit/vlsi library check --liberty "$LIBERTY"
```

For a direct run, map and synthesize the RTL with Yosys/ABC, then analyze the
mapped netlist with OpenSTA:

```bash
../vlsi-toolkit/vlsi synth \
  --project . \
  --top and_gate \
  --rtl rtl/and_gate.sv \
  --liberty "$LIBERTY" \
  --abc-constraints constraints/abc/and_gate.abc \
  --delay-ps 10000 \
  --build-dir build/synth/technology/sky130

../vlsi-toolkit/vlsi timing \
  --project . \
  --top and_gate \
  --netlist build/synth/technology/sky130/and_gate_netlist.v \
  --liberty "$LIBERTY" \
  --sdc constraints/sdc/and_gate.sdc \
  --build-dir build/timing/sky130
```

The equivalent manifest commands are:

```bash
../vlsi-toolkit/vlsi synth --config config/timing/and_gate.toml
../vlsi-toolkit/vlsi timing --config config/timing/and_gate.toml
```

The [timing manifest](config/timing/and_gate.toml) stores the Liberty path, ABC
constraints, netlist path, SDC, and separate output directories. Update its two
`liberty` values if the library is installed elsewhere. ABC's estimate uses
the driver and load in `constraints/abc/and_gate.abc`; OpenSTA uses the clock
and I/O budgets in `constraints/sdc/and_gate.sdc`.

These SDC values are demonstration assumptions, not characterized interface
requirements. Replace them with the design's real timing requirements before
using slack to evaluate a design. Without routed parasitics, the timing report
does not include wire delay. On this host, unrestricted ABC selected the
Sky130 low-power isolation cell `sky130_fd_sc_hd__lpflow_inputiso0n_1` for the
AND function. Review the mapped netlist and target cell-use rules; this is an
integration example, not a validated cell-selection or physical-design flow.

## 7. Build outputs and cleanup

This project's simulation, synthesis, and timing outputs and per-flow logs are
kept under its `build/` directory. Toolkit setup logs remain in the toolkit
repository. Preview the demo paths that cleanup would remove:

```bash
../vlsi-toolkit/vlsi clean --dry-run
```

After reviewing the paths, clean this demo project from its root directory:

```bash
../vlsi-toolkit/vlsi clean
```

This removes this project's `build/`, `logs/`, and `log/` paths. It does not
remove build outputs elsewhere, including the toolkit's own build directory.

## More toolkit documentation

- [Create a project](../vlsi-toolkit/docs/NEW_PROJECT.md)
- [Simulation and UVM](../vlsi-toolkit/docs/COMPILATION_AND_SIMULATION.md)
- [Synthesis](../vlsi-toolkit/docs/SYNTHESIS.md)
- [Timing analysis](../vlsi-toolkit/docs/TIMING_ANALYSIS.md)
- [Waveforms](../vlsi-toolkit/docs/WAVEFORMS.md)
- [Troubleshooting](../vlsi-toolkit/docs/TROUBLESHOOTING.md)
