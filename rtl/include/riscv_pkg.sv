//==============================================================================
// Project      : RISCV64 Processor
// Package      : Global Package
// File         : riscv_pkg.sv
//
// Description  :
//   Global processor configuration, parameters and common typedefs.
//==============================================================================

`timescale 1ns/1ps

package riscv_pkg;

    //==========================================================================
    // Processor Configuration
    //==========================================================================

    parameter int unsigned XLEN = 64;
    parameter int unsigned ILEN = 32;

    //==========================================================================
    // Memory Configuration
    //==========================================================================

    parameter int unsigned IMEM_DEPTH = 256;
    parameter int unsigned DMEM_DEPTH = 256;

    localparam int unsigned IMEM_ADDR_BITS = $clog2(IMEM_DEPTH);
    localparam int unsigned DMEM_ADDR_BITS = $clog2(DMEM_DEPTH);

    //==========================================================================
    // Reset Configuration
    //==========================================================================

    parameter logic [XLEN-1:0] RESET_VECTOR = 64'h8000_0000;

    //==========================================================================
    // Common Types
    //==========================================================================

    typedef logic [XLEN-1:0] xlen_t;
    typedef logic [ILEN-1:0] instr_t;

    typedef logic [4:0] reg_addr_t;

    typedef logic [6:0] opcode_t;
    typedef logic [2:0] funct3_t;
    typedef logic [6:0] funct7_t;

endpackage : riscv_pkg
