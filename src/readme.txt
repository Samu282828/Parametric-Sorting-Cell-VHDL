# Source Code

This folder contains the VHDL source files for the Sorting Cell project.

## Files
* **sorting_cell.vhd**: Top-level module integrating the SIPO, Sorter, and PISO components.
* **sorter.vhd**: Implementation of the Odd-Even Transposition Sort logic.
* **sipo.vhd**: Serial-In Parallel-Out interface for input data conversion.
* **piso.vhd**: Parallel-In Serial-Out interface for output data conversion.
* **mux.vhd**: Multiplexer component used for data path selection.
* **dfe_n.vhd**: D Flip-Flop module for synchronous data storage and synchronization.

## Implementation Notes
The design follows a modular hierarchical approach, where basic components (DFF, MUX) are used to build more complex interface and processing blocks.
