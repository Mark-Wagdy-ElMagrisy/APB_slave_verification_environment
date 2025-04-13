# APB Slave Verification Project

This project implements and verifies an Advanced Peripheral Bus (APB) slave module using SystemVerilog. The design includes a testbench, assertions, coverage metrics, and a scoreboard to ensure correctness and compliance with the APB protocol.

## Project Structure

The project consists of the following key files:

### Source Files
- **[APB.sv](APB.sv)**: Implements the APB slave module, including address decoding, state machine, and data handling logic.
- **[APB_slave_pkg.sv](APB_slave_pkg.sv)**: Contains reusable classes for constraints and coverage groups for APB transactions.
- **[Interface.sv](Interface.sv)**: Defines the APB interface using a SystemVerilog interface construct.
- **[Encrypted_APB_Wrapper.sv](Encrypted_APB_Wrapper.sv)**: Wrapper module for the APB slave, partially encrypted for IP protection.

### Verification Files
- **[testbench.sv](testbench.sv)**: Testbench for verifying the APB slave module. Includes randomized tests, assertions, and coverage collection.
- **[Assertions.sv](Assertions.sv)**: Contains assertions to validate APB protocol compliance.
- **[APB_slave_scoreboard.sv](APB_slave_scoreboard.sv)**: Scoreboard to monitor and verify the correctness of APB transactions.

### Simulation and Configuration Files
- **[run.do](run.do)**: QuestaSim script to compile, simulate, and generate coverage reports.
- **[APB_slave_verification.mpf](APB_slave_verification.mpf)**: Configuration file for simulation settings.
- **[coverage_rpt.txt](coverage_rpt.txt)**: Coverage report generated after simulation.

### Top-Level Module
- **[top.sv](top.sv)**: Top-level module that instantiates the APB interface, APB wrapper, and testbench.

## Features

1. **APB Slave Design**:
   - Implements a state machine with `IDLE`, `SETUP`, `ENABLE`, and `READY` states.
   - Supports read and write operations with address decoding.

2. **Verification Environment**:
   - **Assertions**: Validates protocol compliance for read and write operations.
   - **Randomized Testing**: Generates randomized transactions using constraints.
   - **Coverage**: Collects functional and toggle coverage for APB signals.
   - **Scoreboard**: Tracks correct and erroneous transactions.

3. **Simulation Automation**:
   - The `run.do` script automates compilation, simulation, and coverage reporting.

## How to Run

1. **Setup QuestaSim**:
   - Ensure QuestaSim is installed and licensed on your system.

2. **Compile and Simulate**:
   - Run the `run.do` script in QuestaSim:
     ```bash
     vsim -do run.do
     ```

3. **View Coverage**:
   - Open the generated `coverage_rpt.txt` to review coverage metrics.

## Key Components

### APB Interface
Defined in `Interface.sv`, the APB interface includes:
- Address (`PADDR`), data (`PWDATA`, `PRDATA`), and control signals (`PWRITE`, `PENABLE`, `PSELx`).
- Clock (`PCLK`) and reset (`PRESETn`).

### APB Slave
Implemented in `APB.sv`, the slave module:
- Decodes addresses and handles read/write operations.
- Uses a state machine for transaction control.

### Testbench
The testbench in `testbench.sv`:
- Generates randomized transactions.
- Validates protocol compliance using assertions.
- Collects coverage data.

### Assertions
Assertions in `Assertions.sv`:
- Ensure correct behavior during reset, read, and write operations.

### Coverage
Coverage is collected using:
- Covergroups in `APB_slave_pkg.sv`.
- Functional and toggle coverage metrics.

## Coverage Metrics

The coverage report (`coverage_rpt.txt`) includes:
- **Statement Coverage**: Percentage of executed statements.
- **Toggle Coverage**: Percentage of toggled signals.
- **Functional Coverage**: Coverage of defined coverpoints and crosspoints.

## Known Issues

- Address decoding in `APB.sv` has a potential issue with the `correct_slave` signal. It uses a bitwise OR (`|`) instead of a logical AND (`&&`).
- Address encoding in `APB.sv` may have incorrect bit slicing for `PADDR`.

## Future Improvements

- Fix known issues in address decoding and encoding.
- Add more functional coverage points for edge cases.
- Enhance the scoreboard to include detailed transaction logs.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

## Contact

For questions or contributions, please contact the project maintainer.