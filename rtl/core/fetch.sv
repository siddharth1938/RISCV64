//==============================================================================
// Project      : RISCV64 Processor
// Module       : Instruction Fetch Unit
// File         : fetch.sv
//
// Description  :
//   Instruction Fetch (IF) stage of the RISCV64 processor.
//
//   Responsibilities:
//     - Maintains the Program Counter (PC)
//     - Fetches instructions from Instruction Memory
//     - Supplies the current PC and instruction to the Decode stage
//
//   Future Enhancements:
//     - Branch Prediction
//     - Instruction Cache
//     - Pipeline Stall Support
//     - Pipeline Flush Support
//     - Exception Redirect
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Reference    :
//   - RISC-V Unprivileged ISA Specification
//   - OpenHW CVA6 (Reference Only)
//
// Target ISA   : RV64I (Future: RV64GC)
// Language     : SystemVerilog
//
// Created      : July 2026
// Version      : 1.0
//==============================================================================

`timescale 1ns/1ps

//------------------------------------------------------------------------------
// Import Project Package
//------------------------------------------------------------------------------



//==============================================================================
// Module Declaration
//==============================================================================

module fetch 
    import riscv_pkg::*;
    (

    //--------------------------------------------------------------------------
    // Clock and Reset
    //--------------------------------------------------------------------------

    input  logic  clk_i,          // System Clock
    input  logic  rst_ni,         // Active-Low Reset

    //--------------------------------------------------------------------------
    // Fetch Control
    //--------------------------------------------------------------------------

    
    input  logic  load_pc_i,      // PC Load Enable
    input  xlen_t next_pc_i,      // Next PC (Branch/Jump Target)

    //--------------------------------------------------------------------------
    // Outputs
    //--------------------------------------------------------------------------

    output xlen_t  pc_o,          // Current Program Counter
    output instr_t instr_o        // Current Instruction

);

    //==========================================================================
    // Internal Signals
    //==========================================================================

    xlen_t pc_addr;

    //==========================================================================
    // Program Counter
    //==========================================================================

    pc u_pc (

        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        

        .load_pc_i  (load_pc_i),
        .next_pc_i  (next_pc_i),

        .pc_o       (pc_addr)

    );

    //==========================================================================
    // Instruction Memory
    //==========================================================================

    instr_mem u_instr_mem (

        .addr_i     (pc_addr),
        .instr_o    (instr_o)

    );

    //==========================================================================
    // Outputs
    //==========================================================================

    assign pc_o = pc_addr;

endmodule : fetch
