# ALU Sequence: UVM Sequence-to-Driver Testbench

A small UVM 1.2 testbench that generates constrained-random ALU transactions and drives them through a complete UVM stack (test, env, agent, sequencer, driver). The project focuses on how sequences, sequence items and constraints work. There is no DUT: the driver computes the ALU result itself and prints it, so the project is a stimulus-generation exercise and not a full verification environment.

Built and run with Synopsys VCS U-2023.03-SP2-8 and UVM 1.2.

## What it does

1. `alu_test` builds the environment and starts a sequence on the sequencer.
2. `alu_seq` sends 150 randomized transactions in two phases.
3. `alu_driver` pulls each item, computes the ALU result, and prints the operands and result.

### Transaction fields (`alu_seq_item`)

| Field    | Type                | Randomized | Description                         |
|----------|---------------------|------------|-------------------------------------|
| `a`      | 36-bit signed       | yes        | First operand                       |
| `b`      | 21-bit signed       | yes        | Second operand                      |
| `opcode` | 1 bit               | yes        | `0` = add, `1` = XOR                |
| `ci`     | 1 bit               | yes        | Carry in (randomized, not used by the driver) |
| `z`      | 36-bit signed       | no         | Result, filled in by the driver     |
| `co`     | 1 bit               | no         | Carry out (not driven, stays 0)     |

### Stimulus (`alu_seq`)

- **Phase 1, 100 items:** random operands with `opcode == 1` forced, so every item is an XOR.
- **Phase 2, 50 items:** random operands and a random opcode, with a constraint that the carry into bit 6 of `a + b` equals 1. The constraint is written as `a[6] ^ b[6] ^ sum[6]`, which is the carry into a bit position. It is aimed at hitting a specific carry-propagation case in the adder.

### Driver behavior (`alu_driver`)

For each item the driver sets `z = a + b` when `opcode == 0`, or `z = a ^ b` when `opcode == 1`, prints `a`, `b`, `opcode`, `ci`, `z` and `co` in binary, then waits 1 ns before the next item.

## Testbench hierarchy

```
top
└── alu_test            (uvm_test_top)
    └── alu_env         (tree)
        └── alu_agent   (spy)
            ├── alu_seqr     (line)   sequencer for alu_seq_item
            └── alu_driver   (car)    seq_item_port connected to line.seq_item_export
```

`alu_seq` is created in the test and started on `tree.spy.line`.

## Files

| File               | Purpose                                                    |
|--------------------|------------------------------------------------------------|
| `top.sv`           | Top module, includes all files, calls `run_test("alu_test")` |
| `sequence_item.sv` | `alu_seq_item` transaction class                           |
| `sequence.sv`      | `alu_seq` sequence with the two stimulus phases            |
| `sequencer.sv`     | `alu_seqr`                                                 |
| `driver.sv`        | `alu_driver`, computes and prints the ALU result           |
| `agent.sv`         | `alu_agent`, builds and connects sequencer and driver      |
| `env.sv`           | `alu_env`                                                  |
| `test.sv`          | `alu_test`, raises and drops the objection, starts the sequence |
| `sv_uvm`           | csh script that compiles with VCS and runs `simv`          |
| `results.txt`      | Saved log from a sample run                                |

## How to run

You need Synopsys VCS and a UVM 1.2 source tree.

1. Open `sv_uvm` and set the two lines that are specific to the original machine:
   - `source /apps/design_environment.csh` should point to your own tool setup script.
   - `setenv UVM_HOME ...` should point to your UVM 1.2 directory.
2. Run:

```
./sv_uvm top.sv
```

The script compiles with `-sverilog -timescale=1ns/1ns` and the UVM DPI library, then runs `./simv`.

## Sample result

The saved run in `results.txt` completes cleanly:

- 150 transactions driven (100 from phase 1, 50 from phase 2)
- Of those, 124 were XOR and 26 were add. Phase 1 is all XOR, and phase 2 splits roughly evenly between the two.
- UVM report summary: 0 warnings, 0 errors, 0 fatals
- Simulation ends at 154 ns when the test drops its objection

Example driver output:

```
Data inside driver is: a=111100100111101010101100010110100101 b=100100100000001001111 opcode=1 ci=1 z=000011011000010110001000010111101010 co=0
```

## Known limitations

- No DUT, monitor, scoreboard or functional coverage. Results are printed but not checked.
- `ci` is randomized but ignored, and `co` is never driven.
- `b` is 21 bits wide and `a` is 36 bits, so in an add the result is computed at 36 bits with `b` sign-extended.
- `results.txt` was captured from an earlier run in which the hierarchy instance names differed from the current source (`three/sky/bike` instead of `tree/spy/car`). Rerun the simulation to regenerate it.

## Possible next steps

- Add a monitor and a scoreboard with a reference model.
- Add a covergroup on `opcode`, carry cases and operand ranges.
- Wire `ci` and `co` into the ALU model.
