# RV32I 5-Stage Pipelined Processor with Structured ALU and Operand Forwarding

A 5-stage pipelined RISC-V (RV32I subset) processor implemented in Verilog, featuring a
modular, structured ALU (Arithmetic / Logical / Barrel-Shifter units) and a hazard
forwarding unit for data-hazard resolution.

## Architecture

Classic 5-stage pipeline:

```
IF  ->  ID  ->  EX  ->  MEM  ->  WB
```

| Stage | Responsibility |
|---|---|
| IF  | Instruction fetch from instruction memory, PC update |
| ID  | Instruction decode, register read, immediate generation, control signal decode |
| EX  | ALU execution (arithmetic / logical / shift), operand forwarding |
| MEM | Data memory read/write |
| WB  | Write-back to register file |

Pipeline registers (IF/ID, ID/EX, EX/MEM, MEM/WB) carry data and control signals
between stages.

### Structured ALU

The ALU (`TOP_ALU`) is split into three independent sub-units, selected by
`control[3:2]`:

| Unit | Operations |
|---|---|
| `AU_ALU` (Arithmetic Unit) | ADD, SUB (with N/Z/C/V flags) |
| `LU_ALU` (Logical Unit) | AND, OR, XOR, pass-through |
| `BS_ALU` (Barrel Shifter) | SLL, SRL, arithmetic right shift |

### Hazard Handling

A dedicated `forwarding_unit` resolves EX/MEM -> EX and MEM/WB -> EX data hazards,
allowing back-to-back dependent instructions to execute correctly without inserting
extra stall cycles in most cases.

## Repository Structure

```
├── RTL/            Synthesizable Verilog source files
├── Testbench/       Self-checking testbench
├── Memory/          Instruction memory initialization file (code.mem)
├── Constraints/      Board/timing constraints (.xdc), if applicable
├── Documentation/    Project report and architecture diagrams
├── Waveforms/        Simulation waveform screenshots
└── Simulation/       Simulation run logs / results
```

## Running the Simulation

Using [Icarus Verilog](http://iverilog.icarus.com/):

```bash
cd RTL
iverilog -g2005 -o sim.vvp *.v ../Testbench/TOP_PROCESSOR_tb.v
vvp sim.vvp
```

> Note: use `-g2005` (not `-g2012`), since one module uses `type` as a port/signal
> name, which is a reserved keyword in later Verilog/SystemVerilog standards.

The testbench is self-checking: it loads instructions directly into instruction
memory, runs the pipeline, and compares the resulting register file / data memory
contents against expected values, printing PASS/FAIL for each check.

## Test Results

18 test groups, 94 automated checks — see [`Simulation/results.txt`](Simulation/results.txt)
for the full log.

| Result | Count |
|---|---|
| PASS | 94 |
| FAIL | 0 |

## Known Issues

- **SW (store word) bug:** `SW` currently stores the immediate address offset into
  memory instead of the `rs2` register value. This is intentionally documented and
  confirmed by Test Group 17 in the testbench, rather than hidden.

## License

See [LICENSE](LICENSE).
