# FSM Controller Design and RTL Verification

A beginner-friendly Verilog project demonstrating a finite state machine (FSM) controller and a self-checking testbench. The controller sequences through IDLE, ACTIVE, and DONE based on `start` and `finish`.

> Educational project: run the simulation, understand the code, and be ready to explain it before presenting it as portfolio work. The included tests are directed scenarios, not exhaustive formal verification.

## Specification
Inputs: `clk`, `rst_n` (active-low synchronous reset), `start`, `finish`.
Outputs: `busy` (high in ACTIVE), `done` (high in DONE).

States:
- IDLE waits for `start`.
- ACTIVE waits for `finish`.
- DONE indicates completion for one state cycle, then returns to IDLE.

Transitions:
- IDLE + `start=1` -> ACTIVE
- ACTIVE + `finish=1` -> DONE
- DONE -> IDLE
- Otherwise remain in the current state.

## Files
- `rtl/fsm_controller.v` — FSM RTL
- `tb/tb_fsm_controller.v` — self-checking testbench

## Run on macOS with Icarus Verilog
```bash
iverilog -V
iverilog -g2012 -Wall -o fsm_sim rtl/fsm_controller.v tb/tb_fsm_controller.v
vvp fsm_sim
```
A successful run ends with `ALL TESTS PASSED`.

## Test scenarios
1. Reset enters IDLE.
2. IDLE outputs are low.
3. `start` enters ACTIVE and asserts `busy`.
4. FSM remains ACTIVE while `finish` is low.
5. `finish` enters DONE and asserts `done`.
6. DONE returns to IDLE after one cycle.
7. Reset returns an active controller to IDLE.

## Concepts demonstrated
- FSMs and state transitions
- Sequential and combinational logic
- Clocked state register and synchronous active-low reset
- `case`-based next-state logic
- Moore-style outputs
- Self-checking testbench

## Limitations and extensions
- Educational controller, not production IP.
- Directed tests only; not exhaustive.
- Possible extensions: illegal-state recovery tests, randomized tests, coverage, linting, and synthesis.

## Interview questions
- What is an FSM?
- Moore vs Mealy FSM?
- Why use a clocked block for the state register?
- Why separate next-state logic?
- What does synchronous active-low reset mean?
- What is the difference between RTL and a testbench?
