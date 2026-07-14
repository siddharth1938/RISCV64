//==============================================================================
// Project      : RISCV64 Processor
// Module       : Global Package
// File         : riscv_pkg.sv
//
// Description  :
//   Global package containing processor-wide parameters, common typedefs,
//   constants, and shared definitions.
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

package riscv_pkg;

    //==========================================================================
    // Processor Configuration
    //==========================================================================

    parameter int unsigned XLEN = 64;
    parameter int unsigned ILEN = 32;

    //==========================================================================
    // Memory Configuration
    //==========================================================================

    // Instruction Memory
    parameter int unsigned IMEM_DEPTH = 256;

    // Data Memory
    parameter int unsigned DMEM_DEPTH = 256;

    //==========================================================================
    // Address Widths (Automatically Calculated)
    //==========================================================================

    localparam int unsigned IMEM_ADDR_BITS = $clog2(IMEM_DEPTH);

    localparam int unsigned DMEM_ADDR_BITS = $clog2(DMEM_DEPTH);

    //==========================================================================
    // Reset Configuration
    //==========================================================================

    parameter logic [XLEN-1:0] RESET_VECTOR = 64'h8000_0000;

    //==========================================================================
    // Common Data Types
    //==========================================================================

    typedef logic [XLEN-1:0] xlen_t;

    typedef logic [ILEN-1:0] instr_t;

endpackage : riscv_pkg
