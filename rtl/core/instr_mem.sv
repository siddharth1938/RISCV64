//==============================================================================
// Project      : RISCV64 Processor
// Module       : Instruction Memory
// File         : instr_mem.sv
//
// Description  :
//   Behavioral Instruction Memory (ROM)
//
//   Responsibilities:
//     - Store processor instructions.
//     - Return the instruction corresponding to the supplied address.
//
//   Future Enhancements:
//     - Initialize from HEX/BIN file
//     - Replace with Instruction Cache
//     - AXI/AHB Memory Interface
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

module instr_mem
    import riscv_pkg::*;
(

    //--------------------------------------------------------------------------
    // Address Interface
    //--------------------------------------------------------------------------

    // Instruction Address (Program Counter)
    input  xlen_t  addr_i,

    //--------------------------------------------------------------------------
    // Instruction Output
    //--------------------------------------------------------------------------

    // Instruction located at addr_i
    output instr_t instr_o

);

    //==========================================================================
    // Instruction Memory
    //==========================================================================

    // Behavioral ROM
    instr_t mem [0:IMEM_DEPTH-1];

    //==========================================================================
// Memory Initialization
//==========================================================================

    initial
     begin

        $display("--------------------------------------------------");
        $display("[IMEM] Loading Program Memory...");
        $display("--------------------------------------------------");

        $readmemh("../programs/matrix_mul_3x3.hex", mem);

        $display("[IMEM] Program Successfully Loaded.");
        $display("--------------------------------------------------");
    end

    //==========================================================================
    // Instruction Read Logic
    //==========================================================================

    // Word-aligned instruction access
    assign instr_o = mem[addr_i[IMEM_ADDR_BITS+1:2]];

endmodule : instr_mem
