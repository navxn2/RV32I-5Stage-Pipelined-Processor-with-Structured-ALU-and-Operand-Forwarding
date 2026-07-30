# RV32I 5-Stage Pipelined Processor with Structured ALU & Operand Forwarding

A working RISC-V (RV32I) CPU, built from scratch in Verilog — five pipeline stages, a modular ALU, hazard forwarding, and a 94-check self-verifying testbench.

This isn't a toy ALU project. It's a real pipelined processor: instructions are fetched, decoded, executed, memory-accessed, and written back, with data hazards resolved on the fly through operand forwarding.

## Why this project

Most student RISC-V projects stop at "it adds two numbers." This one goes further:
- A genuinely pipelined datapath (IF → ID → EX → MEM → WB), not a single-cycle stand-in
- A **structured ALU** — separate arithmetic, logic, and barrel-shifter units instead of one monolithic case statement
- A **forwarding unit** that resolves EX/MEM → EX and MEM/WB → EX hazards, so dependent instructions don't need to stall
- A **self-checking testbench** with 18 test groups and 94 automated pass/fail assertions — not just waveform-staring
- Bugs found and documented, not swept under the rug (see below)

## Architecture

IF → ID → EX → MEM → WB


| Stage | What it does |
|---|---|
| **IF** | Fetches instruction, increments PC |
| **ID** | Decodes instruction, reads registers, generates immediates, sets control signals |
| **EX** | Runs the ALU, resolves data hazards via forwarding |
| **MEM** | Reads/writes data memory |
| **WB** | Writes result back to the register file |

Each stage boundary is a dedicated pipeline register (IF/ID, ID/EX, EX/MEM, MEM/WB) that carries data and control signals forward in lockstep.

### The ALU — split by function, not by case statement

`TOP_ALU` routes operands into one of three independent execution units, selected by a 2-bit control field:

| Unit | Handles |
|---|---|
| `AU_ALU` | ADD / SUB, with Negative, Zero, Carry, and Overflow flags |
| `LU_ALU` | AND, OR, XOR, pass-through |
| `BS_ALU` | Logical left/right shift, arithmetic right shift — built as a 5-stage log-shifter, not a barrel of muxes |

### Hazard forwarding

The `forwarding_unit` checks if an upcoming instruction needs a register value that's still in flight (EX/MEM or MEM/WB stage) and forwards it directly — instead of stalling the pipeline and burning cycles.

## Verification

This is the part most student projects skip. The testbench (`TOP_PROCESSOR_tb.v`) doesn't just print waveforms — it **builds instructions programmatically**, runs them through the real pipeline, and automatically checks the results against expected values.

| Metric | Result |
|---|---|
| Test groups | 18 |
| Automated checks | 94 |
| Passed | **94** |
| Failed | 0 |

Coverage includes reset behavior, ALU corner cases (max/min immediates, overflow, sign extension), pipeline throughput, EX/MEM and MEM/WB forwarding, load-use hazards, write-after-write hazards, high register numbers, and multi-register isolation.

Full log: [`Simulation/results.txt`](Simulation/results.txt)

### Bug found (and left visible, on purpose)

`SW` (store word) currently writes the immediate address offset into memory instead of the `rs2` register value. The testbench catches this itself (Test Group 17) and reports it explicitly — because a verification suite that only ever says PASS isn't verifying anything.

## Repository structure

├── RTL/ Synthesizable Verilog source (19 modules)
├── Testbench/ Self-checking testbench
├── Memory/ Instruction memory init file (code.mem)
├── Simulation/ Full simulation log / results
├── Documentation/ Architecture notes, diagrams (WIP)
└── Waveforms/ Simulation waveform captures (WIP)


## Running it yourself

Needs [Icarus Verilog](http://iverilog.icarus.com/):

```bash
cd RTL
iverilog -g2005 -o sim.vvp *.v ../Testbench/TOP_PROCESSOR_tb.v
vvp sim.vvp
```

Use `-g2005`, not `-g2012` — one module uses `type` as a signal name, which later Verilog/SystemVerilog standards reserve as a keyword.

## Tech

Verilog-2005 · 5-stage RISC pipeline · Vivado (design entry/simulation) · Icarus Verilog (open verification)
