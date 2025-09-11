# DEVS on FPGA: Accelerating DEVS Simulation with Hardware

This repository contains the source code and design files for the **Implementation of DEVS (Discrete Event System Specification) on an FPGA**. The project explores a novel approach to DEVS simulation by leveraging the inherent parallelism and high-speed processing of Field-Programmable Gate Arrays (FPGAs).

---

## The DEVS-FPGA Relationship

The relationship between DEVS and FPGAs is a powerful and natural fit due to their fundamental structural and behavioral similarities. Both are inherently **modular and parallel** systems.

* **Direct Mapping**: A DEVS model, with its well-defined states and transitions, can be directly translated into a hardware module on the FPGA.
* **Massive Parallelism**: DEVS's native concurrency, where multiple events can occur simultaneously, aligns perfectly with the massive parallel architecture of an FPGA. This enables the transformation of a traditional sequential software simulation into a hardware-level concurrent execution.

### Why Implement DEVS on an FPGA?

Implementing DEVS on an FPGA provides significant advantages over a software-based approach:

* **High Speed**: FPGAs can execute many operations simultaneously, accelerating simulation times.
* **Low Latency**: Events are processed with minimal delay, making the system highly responsive.
* **Energy Efficiency**: Hardware execution consumes less power compared to the continuous processing of a CPU for the same task.
* **Scalability**: The architecture can be easily scaled to handle larger systems with a higher number of events and states.
* **Real-Time Applications**: The hardware implementation can be directly integrated with physical sensors or control systems for real-time applications, such as smart traffic management or complex sensor networks.

---

## DEVS-on-FPGA Design
### Schematic

The diagram illustrates the **top-level schematic** of the DEVS-on-FPGA implementation, showing the modular and hierarchical design. The system is composed of three primary components interconnected with their respective inputs and outputs.

![Schematic of the design](Images/Schematic.png)

* **`dut_root_coord` (Root Coordinator):** This module acts as the entry point for the entire simulation. It initiates the process by sending a `step` signal and receives a final `done` signal to indicate the end of the simulation cycle.
* **`dut_coord` (Coordinator):** The central hub of the design, this module manages the execution flow. It synchronizes the `done` signals from the connected simulators and, based on their status, provides the next `step` signal to advance the simulation.
* **`dut_sim` (Simulator):** This core component emulates a single **atomic DEVS model**. It is responsible for processing input events (`x`), generating output events (`y`), and updating its internal state based on control signals from the `coordinator`.

---

### Design Validation

The entire circuit was validated using a comprehensive **testbench** to observe the system's behavior in detail. This approach allowed for thorough observation of input and output events, ensuring that the DEVS logic was correctly translated and processed in the hardware.

---

### Organization

The following image shows the file organization and a view of the simulation scope within the Vivado environment. It provides a hierarchical representation of the project's components and their corresponding signals during a testbench-driven simulation.

<p align="center">
  <img src="Images/Organization.png" alt="Files organization"/>
</p>

The **`Scope`** pane on the left shows the hierarchy of the design, with `top_level` acting as the **Design Under Test (DUT)**. You can see how the `dut_root_coord`, `dut_coord`, and `dut_sim` modules are instantiated within `top_level`, demonstrating the modular structure.

The **`Objects`** pane on the right lists the key signals and variables within the selected scope. The values shown represent the current state of the signals during the simulation run. These objects are crucial for debugging and validating the design.

* `clk` and `rst`: The clock and reset signals for the entire system.
* `x_in_tb[7:0]` and `y_out_tb[7:0]`: The input and output event buses, as driven and observed by the testbench.
* `at_w[7:0]` and `star_w[7:0]`: Internal state variables representing `@` and `*` as described in DEVS theory, managed by the coordinator.
* `step_w[7:0]` and `done_simulator_w[7:0]`: Signals used by the coordinator to control the simulation flow and receive feedback from the simulators.

This view confirms that the **testbench** is correctly interacting with the **top-level** module and that the internal signals are behaving as expected according to the DEVS simulation logic.

---

## Repository Structure

This repository is organized to provide a clear view of the project's development journey, from early experiments to the final, validated design.

* `Experimental projects/`: This directory contains various development versions created during the design phase. It includes initial logical experiments and proofs of concept that led to the final architecture.
* `Final Version/`: The final, presented version of the DEVS-on-FPGA project. This represents the stable and validated design, including the final Verilog source files.
* `Practical Projects/`: Includes small, practical exercises created to help understand fundamental Verilog logic, the Vivado workflow, and interactions with the FPGA board.
* `Waves Behavioral Simulations/`: Stores the waveform files generated during behavioral simulations, which were used to debug and verify the design's functionality.

---

## Workflow and Requirements

This repository is used solely for **version control and code documentation**. While you can browse and edit the source code here, **Vivado is an essential tool** for the project's development and use.

### Why Vivado is Required

**Vivado** is a complete software suite developed by Xilinx for the synthesis and analysis of HDL (Hardware Description Language) designs. It is the only way to:
* **Synthesize** the Verilog code into a netlist (the hardware schematic).
* **Implement** the design to place and route it on a specific FPGA device.
* **Generate a bitstream** file (.bit), which is the final configuration file used to program the FPGA.
* **Run simulations** with the built-in simulator to verify the design's behavior and validate the hardware's functionality.

### How to Install Vivado

You can download and install Vivado from the official AMD/Xilinx website.

1.  Go to the **[AMD/Xilinx Downloads page](https://www.xilinx.com/support/download.html)**.
2.  Select the **Vivado** section and choose the latest version of the "Unified Installer".
3.  Follow the installation wizard. During the process, select the **"Vivado"** product and the specific FPGA family you will be using (e.g., Artix-7, Kintex-7, etc.) to minimize the installation size.
4.  After the installation is complete, you will need a license. A free license called the **"Vivado ML Standard Edition"** is available and sufficient for most hobbyist and academic projects. You can generate this license within the Vivado License Manager.