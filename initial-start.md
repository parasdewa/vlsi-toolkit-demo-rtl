# Initial Start: Add and Run a Design

This guide uses the structural 4-bit adder in this project. Run commands from
the project root. The design is split across `rtl/full_adder.sv` and
`rtl/adder_4bit.sv`; the top module is `ripple_carry_adder_4bit`. Its current
directed testbench is `tb/directed/tb_4bit_adder.sv`, with top module
`tb_ripple_carry_adder_4bit`.

## 1. Add RTL and testbench files

- Put synthesizable design files in `rtl/`. For this adder, keep the reusable
  `full_adder` module in `rtl/full_adder.sv` and the 4-bit top in
  `rtl/adder_4bit.sv`.
- Put non-UVM (directed) testbenches in `tb/directed/`. For example, add
  `tb/directed/tb_adder_4bit.sv` and set its actual module name as the
  simulation top. This checkout's equivalent file is named
  `tb_4bit_adder.sv`.
- Put UVM interfaces, packages, agents, environment, sequences, tests, and the
  simulation top in the matching subdirectories under `tb/uvm/`.
- Keep synthesis and timing constraints under `constraints/abc/` and
  `constraints/sdc/`, not in `rtl/`.

For a multi-file design, list dependency modules first. The adder manifests
list `full_adder.sv` before `adder_4bit.sv`. Do not put testbench files in a
synthesis source list.

## 2. Directed simulation and waveform

Create `config/simulation/directed/adder_4bit.toml` (this project already has
it) and update these fields for your design:

```toml
[project]
# Keep for manifests under config/simulation/directed/.
root = "../../.."

[run]
sim = "verilator"
uvm = false
# UPDATE: current directed testbench module name (not the RTL top).
top = "tb_ripple_carry_adder_4bit" # testbench module, not RTL top
# UPDATE: list every RTL file in dependency/compile order.
rtl = ["rtl/full_adder.sv", "rtl/adder_4bit.sv"]
# UPDATE: directed testbench file(s).
tb = ["tb/directed/tb_4bit_adder.sv"]
# UPDATE: add include paths if required.
include = ["rtl/include"]
waveform = true
# UPDATE: choose a VCD name; DESIGN=adder_4bit looks for this filename.
waveform_file = "waveforms/adder_4bit.vcd"
# UPDATE: unique build directory for this design/simulator.
build_dir = "build/sim/adder_4bit-verilator"
jobs = 1
```

Update `root`, `top`, ordered `rtl` and `tb` paths, waveform name, and a unique
`build_dir`. The `DESIGN` value selects the manifest filename; it does not set
the RTL or testbench module name.

```bash
make sim DESIGN=adder_4bit                 # Verilator
make sim DESIGN=adder_4bit SIM=iverilog    # Icarus override
make wave DESIGN=adder_4bit                # GTKWave, Verilator VCD
make wave DESIGN=adder_4bit SIM=iverilog   # GTKWave, Icarus VCD
```

The testbench needs the toolkit's conditional `VLSI_WAVEFORM` dump hook for
the manifest's waveform path to be used. `make wave` opens an existing VCD; it
does not run simulation.

## 3. UVM simulation and waveform

The adder example currently has no UVM testbench. After adding one, create
`config/simulation/uvm/adder_4bit.toml`. Set `top` to the UVM top module,
`rtl` to the ordered design source list, and `tb` to every UVM source in
dependency order (interface, package, agent/environment, sequence/test, top).
Also set `root`, include directories, `waveform_file`, and `build_dir`:

```toml
[project]
# Keep for manifests under config/simulation/uvm/.
root = "../../.."

[run]
sim = "verilator"
uvm = true
# UPDATE: UVM top module name.
top = "adder_4bit_uvm_top"
# UPDATE: list RTL files in compile dependency order.
rtl = ["rtl/full_adder.sv", "rtl/adder_4bit.sv"]
# UPDATE: replace with the UVM source files you create, dependency first.
tb = [
  "tb/uvm/interfaces/adder_if.sv",
  "tb/uvm/packages/adder_pkg.sv",
  "tb/uvm/env/adder_env.sv",
  "tb/uvm/tests/adder_test.sv",
  "tb/uvm/top/adder_4bit_uvm_top.sv",
]
# UPDATE: add include paths required by your sources.
include = ["rtl/include", "tb/uvm"]
waveform = true
# UPDATE: use <design>_uvm.vcd for automatic make wave-uvm DESIGN lookup.
waveform_file = "waveforms/adder_4bit_uvm.vcd"
# UPDATE: unique UVM build directory.
build_dir = "build/sim/adder_4bit-uvm-verilator"
jobs = 1
```

Use the design-named manifest and matching waveform convention:

```bash
make uvm DESIGN=adder_4bit
make wave-uvm DESIGN=adder_4bit
```

UVM runs with Verilator and requires a compatible UVM package. Set
`VERILATOR_UVM_DIR` if automatic package discovery does not find it. Keep
`jobs = 1` on memory-limited machines. The `tb` paths above are examples;
create the files before running this flow.

## 4. Generic synthesis

Create `config/synthesis/adder_4bit.toml`. Set `root`, the synthesizable RTL
top, ordered RTL files, include directories, and a design-specific output path:

```toml
[project]
# Keep for manifests under config/synthesis/.
root = "../.."

[synth]
# UPDATE: synthesizable RTL top module.
top = "ripple_carry_adder_4bit"
# UPDATE: list synthesizable RTL only, in dependency order.
rtl = ["rtl/full_adder.sv", "rtl/adder_4bit.sv"]
# UPDATE: add include paths if required.
include = ["rtl/include"]
# UPDATE: unique generic synthesis build directory.
build_dir = "build/synth/adder_4bit/generic"
```

Run generic Yosys synthesis:

```bash
make synth DESIGN=adder_4bit
```

## 5. Technology mapping and timing analysis

Create one SDC file and a timing manifest. The existing example files are
`constraints/abc/adder_4bit.abc`, `constraints/sdc/adder_4bit.sdc`, and
`config/timing/adder_4bit.toml`. The SDC describes clocks and I/O timing; the
ABC file describes mapping driver/load assumptions. Update them for the
interface and compatible target library. The library path is machine-specific
and must be supplied explicitly; the toolkit does not select or install a PDK.

In the timing manifest, update both tables. `[synth]` maps the RTL and chooses
the technology output directory. `[timing]` must point to the mapped netlist
created in that directory, and use the same Liberty library:

```toml
[project]
# Keep for manifests under config/timing/.
root = "../.."

[synth]
# UPDATE: synthesizable RTL top and ordered RTL sources.
top = "ripple_carry_adder_4bit"
rtl = ["rtl/full_adder.sv", "rtl/adder_4bit.sv"]
include = ["rtl/include"]
# UPDATE: compatible Liberty; use this same path in the [timing] section.
liberty = "/absolute/path/to/compatible_standard_cells.lib"
# UPDATE: ABC driver/load assumptions for this design/library.
abc_constraints = "constraints/abc/adder_4bit.abc"
# UPDATE: desired mapping delay in picoseconds.
delay_ps = 10000
# UPDATE: mapped synthesis output directory.
build_dir = "build/synth/technology/adder_4bit"

[timing]
# UPDATE: use the same RTL top and Liberty as [synth].
top = "ripple_carry_adder_4bit"
# UPDATE: must point to <top>_netlist.v in the [synth] output directory.
netlist = "build/synth/technology/adder_4bit/ripple_carry_adder_4bit_netlist.v"
liberty = "/absolute/path/to/compatible_standard_cells.lib"
# UPDATE: SDC file with the design clock and I/O constraints.
sdc = "constraints/sdc/adder_4bit.sdc"
# UPDATE: timing report output directory.
build_dir = "build/timing/adder_4bit"
```

Run mapped synthesis first, then OpenSTA timing:

```bash
make synth-mapped DESIGN=adder_4bit
make timing DESIGN=adder_4bit
```

The example SDC and ABC values are starting assumptions, not signoff
constraints. Review the reports and replace the example clock and I/O delays
with requirements for your design.

## 6. Tool check and help

```bash
../vlsi-toolkit/vlsi doctor
make help
```

Use `make clean-dry-run` to preview cleanup and `make clean` to remove generated
build outputs. The project `.gitignore` keeps generated build products out of
source control.
