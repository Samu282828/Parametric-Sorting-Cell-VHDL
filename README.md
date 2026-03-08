# Parametric Sorting Cell in VHDL

## Project Description
VHDL implementation of a sorting cell designed to order a parametric set of symbols. The system manages data through serial interfaces and performs sorting using a parallel architecture.

## Architecture and Features
* **Sorting Algorithm**: Odd-Even Transposition Sort.
* **SIPO (Serial In Parallel Out)**: Input stage for serial-to-parallel data conversion.
* **Sorter**: Core logic for parallel sorting of input symbols.
* **PISO (Parallel In Serial Out)**: Output stage for parallel-to-serial data conversion.
* **Parametric Design**: Configurable number of symbols and bit-width per symbol.

## Verification
* Functional verification performed via VHDL Testbench.
* Scenarios tested: Standard sorting operation and block overflow management.

## Tools Used
* **Language**: VHDL
* **Simulation/Synthesis**: [ModelSim / Vivado]
