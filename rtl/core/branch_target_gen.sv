//==============================================================================
// Project      : RISCV64 Processor
// Module       : Branch Target Generator
// File         : branch_target_gen.sv
//
// Description  :
//   Computes the target address for branch instructions.
//
// Operation:
//   branch_target_o = pc_i + imm_i
//==============================================================================

`timescale 1ns/1ps

module branch_target_gen import riscv_pkg::*; (

    //==========================================================================
    // Inputs
    //==========================================================================

    input  xlen_t pc_i,
    input  xlen_t imm_i,

    //==========================================================================
    // Output
    //==========================================================================

    output xlen_t branch_target_o

);

    //==========================================================================
    // Branch Target Calculation
    //==========================================================================

    assign branch_target_o = pc_i + imm_i;

endmodule
