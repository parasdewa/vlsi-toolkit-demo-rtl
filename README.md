# VLSI Toolkit RTL Demo

This starter project includes a UVM environment with a sequence, driver, monitor,
and scoreboard. Edit `rtl/and_gate.sv` and the UVM files under `tb/` as needed.

## Choose a simulation manifest

There are two manifests, both using Verilator and separate build directories.
Run the basic testbench without UVM:

The commands below assume the toolkit checkout is the adjacent
`../vlsi-toolkit` directory.

```bash
../vlsi-toolkit/vlsi run --config vlsi.toml
```

Run the UVM testbench:

```bash
../vlsi-toolkit/vlsi run --config vlsi_uvm.toml
```

`--config FILE` tells the toolkit to load the project settings saved in that
TOML file: source lists, top module, simulator/UVM options, and build directory.
The basic manifest writes outputs under `build/run/`; the UVM manifest uses
`build/uvm/`.

You can synthesize from either manifest because both include the same `[synth]`
settings:

```bash
../vlsi-toolkit/vlsi synth --config vlsi.toml
```

## Run without a manifest

A manifest is optional. To run directly, pass the project root, top module,
and source files; repeat `--rtl` or `--tb` for additional files. For example,
run the UVM testbench without loading `vlsi_uvm.toml`, then synthesize the RTL:

```bash
../vlsi-toolkit/vlsi run --sim verilator --uvm --jobs 1 \
  --project . \
  --top and_gate_tb_top \
  --rtl rtl/and_gate.sv \
  --tb tb/and_gate_if.sv \
  --tb tb/and_gate_pkg.sv \
  --tb tb/and_gate_tb_top.sv \
  --include tb \
  --build-dir build/uvm-first-run

../vlsi-toolkit/vlsi synth \
  --project . \
  --top and_gate \
  --rtl rtl/and_gate.sv \
  --build-dir build/synth-first-run
```

The UVM simulation uses Verilator's UVM 2020.3.2 package. Set
`VERILATOR_UVM_DIR` to the directory containing
`uvm_pkg_all_v2020_3_2_nodpi.svh` if the toolkit cannot locate it automatically.
The scoreboard checks all four AND-gate input combinations and writes a VCD to
`build/uvm/waveforms/and_gate_uvm.vcd` inside this project.
