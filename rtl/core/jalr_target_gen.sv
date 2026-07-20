//==============================================================================
// Project      : RISCV64 Processor
// Module       : JALR Target Generator
// File         : jalr_target_gen.sv
//
// Description  :
//   Computes the target address for JALR instructions.
//
// Operation:
//   jalr_target_o = (rs1_data_i + imm_i) & ~1
//
// RISC-V ISA Requirement:
//   The least significant bit of the target address must be cleared.
//==============================================================================

`timescale 1ns/1ps

module jalr_target_gen import riscv_pkg::*; (

    //==========================================================================
    // Inputs
    //==========================================================================

    input  xlen_t rs1_data_i,
    input  xlen_t imm_i,

    //==========================================================================
    // Output
    //==========================================================================

    output xlen_t jalr_target_o

);

    //==========================================================================
    // Internal Signals
    //==========================================================================

    xlen_t target_addr;

    //==========================================================================
    // JALR Target Calculation
    //==========================================================================

    assign target_addr = rs1_data_i + imm_i;

    //==========================================================================
    // Clear LSB as required by the RISC-V ISA
    //==========================================================================

    assign jalr_target_o = {target_addr[XLEN-1:1], 1'b0};

endmodule
