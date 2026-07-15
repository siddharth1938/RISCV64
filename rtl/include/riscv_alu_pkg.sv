//==============================================================================
// Project      : RISCV64 Processor
// Package      : ALU Operation Package
// File         : riscv_alu_pkg.sv
//
// Description  :
//   Defines the internal ALU operations used by the RISCV64 processor.
//
//   NOTE:
//   These are INTERNAL processor operations.
//   They are NOT part of the RISC-V ISA encoding.
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//
//==============================================================================

`timescale 1ns/1ps

package riscv_alu_pkg;

    //==========================================================================
    // ALU Operation Enumeration
    //==========================================================================

    typedef enum logic [3:0] {

        ALU_ADD  = 4'd0,
        ALU_SUB  = 4'd1,

        ALU_AND  = 4'd2,
        ALU_OR   = 4'd3,
        ALU_XOR  = 4'd4,

        ALU_SLL  = 4'd5,
        ALU_SRL  = 4'd6,
        ALU_SRA  = 4'd7,

        ALU_SLT  = 4'd8,
        ALU_SLTU = 4'd9

    } alu_op_t;

endpackage : riscv_alu_pkg
