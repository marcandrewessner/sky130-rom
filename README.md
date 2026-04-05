# asic-template

A ready-to-run RTL-to-GDSII template. It ships with a working counter design, a cocotb simulation flow, and a LibreLane physical implementation flow — all inside a reproducible Nix environment. Clone it, run it, then replace the example design with your own.

## Prerequisites

This project uses [Nix](https://nixos.org) to manage the entire tool chain. Nix is a package manager that pins every dependency to an exact version and builds it in isolation — the environment is fully reproducible and portable across machines. Anyone who enters the shell gets bit-for-bit the same tools, with no manual installation and no version drift.

Install Nix with the extra substituters for the FOSSI Foundation binary cache (avoids building EDA tools from source, which would take hours):

```sh
curl --proto '=https' --tlsv1.2 -fsSL https://artifacts.nixos.org/nix-installer | sh -s -- install --no-confirm --extra-conf "
    extra-substituters = https://nix-cache.fossi-foundation.org
    extra-trusted-public-keys = nix-cache.fossi-foundation.org:3+K59iFwXqKsL7BNu6Guy0v+uTlwsxYQxjspXzqLYQs=
"
```

For full details see the [LibreLane Nix installation guide](https://librelane.readthedocs.io/en/stable/installation/nix_installation/index.html#nix-based-installation).

## Quick start

```sh
nix-shell        # enter the environment — first run downloads all tools (~15 min)
make test        # simulate and verify
make build       # synthesize, place, route → GDSII
```

Outputs land in `build/` (a symlink to the final outputs of the latest run).

## Replacing the example design

1. Drop your `.sv` files into `src/` — both the test runner and LibreLane pick them up automatically.
2. Update `librelane_config.json`: set `DESIGN_NAME`, `CLOCK_PORT`, `CLOCK_PERIOD`, and any floorplan parameters. See the [LibreLane docs](https://librelane.readthedocs.io) for the full variable reference.
3. Replace or add testbenches and testmodules in `test/`. See [test/README.md](test/README.md).

## How it fits together

```
src/                      # Your design sources (.sv) — shared by both flows
test/                     # Simulation (see test/README.md)
librelane_config.json     # LibreLane design configuration
shell.nix                 # Nix development environment
Makefile                  # Entry point for all workflows
runs/                     # LibreLane run history (gitignored)
build -> runs/LAST_RUN/final   # Symlink to latest build outputs (tracked in git)
```

`src/` is the single source of truth for your design. The test runner compiles everything in `src/` together with the testbenches; LibreLane does the same for the physical flow.

`shell.nix` bootstraps from the LibreLane Nix flake, which brings in the full tool chain (Yosys, OpenROAD, Magic, Netgen, Icarus, and more) at the exact versions LibreLane was tested against. On top of that it adds `gnumake`, `cocotb`, and `cocotb-bus` for simulation. It also pins `PDK_ROOT` to `.pdk/` inside the project so the PDK stays local. All Makefile targets must be run inside the Nix shell.

Each `make build` creates a timestamped directory under `runs/`. The `LAST_RUN` symlink is updated to point at the latest one, and `build` resolves through it to `runs/LAST_RUN/final/` — so `build/` always reflects the most recent outputs without needing to be updated itself. `runs/` is gitignored; `build` is tracked.

## Makefile

```
make test      # run all cocotb testmodules
make build     # run LibreLane, update runs/LAST_RUN
make all       # test then build (default)
make clean     # remove simulation artifacts and all run directories
```

## Extending the environment

To add tools or Python packages, edit `shell.nix`:

```nix
pkgs.librelane-shell.override {
  extra-packages = with pkgs; [ gnumake your-tool ];
  extra-python-packages = ps: with ps; [ cocotb cocotb-bus your-package ];
}
```
