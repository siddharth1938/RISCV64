//==============================================================================
// Project      : RISCV64 Processor
// Package      : Opcode Definitions
// File         : riscv_opcode_pkg.sv
//
// Description  :
//   RV64I Primary Opcode Definitions
//==============================================================================

`timescale 1ns/1ps

package riscv_opcode_pkg;

    import riscv_pkg::*;

    //==========================================================================
    // RV64I Primary Opcodes
    //==========================================================================

    localparam opcode_t OPCODE_LUI       = 7'b0110111;
    localparam opcode_t OPCODE_AUIPC     = 7'b0010111;

    localparam opcode_t OPCODE_JAL       = 7'b1101111;
    localparam opcode_t OPCODE_JALR      = 7'b1100111;

    localparam opcode_t OPCODE_BRANCH    = 7'b1100011;

    localparam opcode_t OPCODE_LOAD      = 7'b0000011;
    localparam opcode_t OPCODE_STORE     = 7'b0100011;

    localparam opcode_t OPCODE_OP_IMM    = 7'b0010011;
    localparam opcode_t OPCODE_OP        = 7'b0110011;

    localparam opcode_t OPCODE_MISC_MEM  = 7'b0001111;
    localparam opcode_t OPCODE_SYSTEM    = 7'b1110011;

endpackage : riscv_opcode_pkg
