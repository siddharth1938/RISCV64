//==============================================================================
// Project      : RISCV64 Processor
// Module       : Program Counter (PC)
// File         : pc.sv
//
// Description  :
//   Program Counter for the RISCV64 processor.
//
//   Responsibilities:
//     - Load the reset vector after reset.
//     - Increment the PC by one instruction (4 bytes).
//     - Redirect the PC during branch/jump operations.
//
//   Future Enhancements:
//     - Compressed Instructions (PC + 2)
//     - Branch Prediction
//     - Exception Handling
//     - Debug Mode
//     - Pipeline Flush Support
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Reference    :
//   - RISC-V Unprivileged ISA Specification
//   - OpenHW CVA6 (Architecture Reference)
//
// Target ISA   : RV64I (Future: RV64GC)
// Language     : SystemVerilog
//
// Created      : July 2026
// Version      : 1.0
//==============================================================================

`timescale 1ns/1ps



//==============================================================================
// Module Declaration
//==============================================================================

module pc import riscv_pkg::*;(

    //--------------------------------------------------------------------------
    // Clock and Reset
    //--------------------------------------------------------------------------

    input  logic  clk_i,
    input  logic  rst_ni,

    //--------------------------------------------------------------------------
    // Control Interface
    //--------------------------------------------------------------------------

    // Program Counter Redirect Enable
    input  logic  load_pc_i,

    // Redirect Address
    input  xlen_t next_pc_i,

    //--------------------------------------------------------------------------
    // Output Interface
    //--------------------------------------------------------------------------

    // Current Program Counter
    output xlen_t pc_o

);

    //==========================================================================
    // Local Parameters
    //==========================================================================

    localparam xlen_t PC_INCREMENT = xlen_t'(4);

    //==========================================================================
    // Internal Signals
    //==========================================================================

    // Current Program Counter Register
    xlen_t pc_q;

    // Next Program Counter Value
    xlen_t pc_d;

    //==========================================================================
    // Next-State Combinational Logic
    //==========================================================================

    always_comb begin

        // Default Sequential Execution
        pc_d = pc_q + PC_INCREMENT;

        // Program Counter Redirection
        if (load_pc_i) begin
            pc_d = next_pc_i;
        end

    end

    //==========================================================================
    // Sequential Logic
    //==========================================================================

    always_ff @(posedge clk_i or negedge rst_ni) begin

        if (!rst_ni) begin
            pc_q <= RESET_VECTOR;
        end
        else begin
            pc_q <= pc_d;
        end

    end

    //==========================================================================
    // Output Logic
    //==========================================================================

    assign pc_o = pc_q;

endmodule : pc
