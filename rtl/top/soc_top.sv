//==============================================================================
// Project      : RISCV64 Processor
// Module       : SoC Top
// File         : soc_top.sv
//
// Description  :
//   Top-level wrapper integrating the RV64I processor core with the
//   instruction fetch unit and data memory.
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module soc_top
    import riscv_pkg::*;
(
    input logic clk_i,
    input logic rst_ni
);

    //==========================================================================
    // Fetch <-> Core Interface
    //==========================================================================

    xlen_t  pc;
    xlen_t  next_pc;
    instr_t instruction;

    logic load_pc;

    //==========================================================================
    // Core <-> Data Memory Interface
    //==========================================================================

    xlen_t mem_addr;
    xlen_t mem_write_data;
    xlen_t mem_read_data;

    logic mem_read;
    logic mem_write;

    //==========================================================================
    // Fetch Unit
    //==========================================================================

    fetch u_fetch (

        .clk_i          (clk_i),
        .rst_ni         (rst_ni),

        .load_pc_i      (load_pc),
        .next_pc_i      (next_pc),

        .pc_o           (pc),
        .instr_o        (instruction)

    );

    //==========================================================================
    // RISC-V Core
    //==========================================================================

    riscv64_core u_core (

        .clk_i              (clk_i),
        .rst_ni             (rst_ni),

        // Instruction Interface
        .pc_i               (pc),
        .instruction_i      (instruction),

        .load_pc_o          (load_pc),
        .next_pc_o          (next_pc),

        // Data Memory Interface
        .mem_data_i         (mem_read_data),

        .mem_addr_o         (mem_addr),
        .mem_write_data_o   (mem_write_data),

        .mem_read_o         (mem_read),
        .mem_write_o        (mem_write)

    );

    //==========================================================================
    // Data Memory
    //==========================================================================

    data_mem u_data_mem (

        .clk_i          (clk_i),

        .addr_i         (mem_addr),
        .write_data_i   (mem_write_data),

        .mem_read_i     (mem_read),
        .mem_write_i    (mem_write),

        .read_data_o    (mem_read_data)

    );

endmodule : soc_top
