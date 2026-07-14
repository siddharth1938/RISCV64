//==============================================================================
// Project      : RISCV64 Processor
// Package      : funct3 / funct7 Definitions
// File         : riscv_funct_pkg.sv
//
// Description  :
//   Common RV64I funct3 and funct7 definitions.
//==============================================================================

`timescale 1ns/1ps

package riscv_funct_pkg;

    import riscv_pkg::*;

    //==========================================================================
    // OP / OP-IMM funct3
    //==========================================================================

    localparam funct3_t F3_ADD_SUB = 3'b000;
    localparam funct3_t F3_SLL     = 3'b001;
    localparam funct3_t F3_SLT     = 3'b010;
    localparam funct3_t F3_SLTU    = 3'b011;
    localparam funct3_t F3_XOR     = 3'b100;
    localparam funct3_t F3_SRL_SRA = 3'b101;
    localparam funct3_t F3_OR      = 3'b110;
    localparam funct3_t F3_AND     = 3'b111;

    //==========================================================================
    // Branch funct3
    //==========================================================================

    localparam funct3_t F3_BEQ     = 3'b000;
    localparam funct3_t F3_BNE     = 3'b001;
    localparam funct3_t F3_BLT     = 3'b100;
    localparam funct3_t F3_BGE     = 3'b101;
    localparam funct3_t F3_BLTU    = 3'b110;
    localparam funct3_t F3_BGEU    = 3'b111;

    //==========================================================================
    // Load / Store funct3
    //==========================================================================

    localparam funct3_t F3_BYTE    = 3'b000;
    localparam funct3_t F3_HALF    = 3'b001;
    localparam funct3_t F3_WORD    = 3'b010;
    localparam funct3_t F3_DWORD   = 3'b011;

    //==========================================================================
    // funct7
    //==========================================================================

    localparam funct7_t F7_ADD     = 7'b0000000;
    localparam funct7_t F7_SUB     = 7'b0100000;

endpackage : riscv_funct_pkg

