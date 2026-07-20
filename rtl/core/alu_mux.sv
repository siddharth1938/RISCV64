//==============================================================================
// Project      : RISCV64 Processor
// Module       : ALU Operand Multiplexer
// File         : alu_mux.sv
//
// Description  :
//   Selects the second operand for the ALU.
//
//   Operand Selection:
//     alu_src_i = 0 --> Register File (rs2)
//     alu_src_i = 1 --> Immediate Generator
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module alu_mux
    import riscv_pkg::*;
(

    //--------------------------------------------------------------------------
    // Register File Operand
    //--------------------------------------------------------------------------

    input  xlen_t rs2_data_i,

    //--------------------------------------------------------------------------
    // Immediate Operand
    //--------------------------------------------------------------------------

    input  xlen_t imm_i,

    //--------------------------------------------------------------------------
    // Operand Select
    //--------------------------------------------------------------------------

    input  logic  alu_src_i,

    //--------------------------------------------------------------------------
    // Selected ALU Operand
    //--------------------------------------------------------------------------

    output xlen_t alu_operand_b_o

);

    //==========================================================================
    // Operand Selection Logic
    //==========================================================================

    assign alu_operand_b_o = (alu_src_i) ? imm_i : rs2_data_i;

endmodule : alu_mux
