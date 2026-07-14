//==============================================================================
// Project      : RISCV64 Processor
// Module       : Instruction Decoder
// File         : decoder.sv
//
// Description  :
//   Decodes a 32-bit RISC-V instruction into its constituent fields.
//
//   Responsibilities:
//     - Extract opcode
//     - Extract destination register
//     - Extract source registers
//     - Extract funct3
//     - Extract funct7
//
//   Future Enhancements:
//     - Illegal Instruction Detection
//     - Compressed Instruction Support (RV64C)
//     - Instruction Classification
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module decoder
    import riscv_pkg::*;
    import riscv_opcode_pkg::*;
    import riscv_funct_pkg::*;
(

    //--------------------------------------------------------------------------
    // Instruction Input
    //--------------------------------------------------------------------------

    input  instr_t     instr_i,

    //--------------------------------------------------------------------------
    // Decoded Fields
    //--------------------------------------------------------------------------

    output opcode_t    opcode_o,
    output reg_addr_t  rd_o,
    output reg_addr_t  rs1_o,
    output reg_addr_t  rs2_o,
    output funct3_t    funct3_o,
    output funct7_t    funct7_o

);

    //==========================================================================
    // Field Extraction
    //==========================================================================

    assign opcode_o = instr_i[6:0];

    assign rd_o     = instr_i[11:7];

    assign funct3_o = instr_i[14:12];

    assign rs1_o    = instr_i[19:15];

    assign rs2_o    = instr_i[24:20];

    assign funct7_o = instr_i[31:25];

endmodule : decoder
