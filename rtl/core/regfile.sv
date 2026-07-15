//==============================================================================
// Project      : RISCV64 Processor
// Module       : Register File
// File         : regfile.sv
//
// Description  :
//   32 x 64-bit Integer Register File for the RV64I ISA.
//
//   Features:
//     - 32 General Purpose Registers (x0 - x31)
//     - Two Combinational Read Ports
//     - One Synchronous Write Port
//     - x0 is Hardwired to Zero
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Reference    :
//   - RISC-V Unprivileged ISA Specification
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module regfile
    import riscv_pkg::*;
(

    //--------------------------------------------------------------------------
    // Clock
    //--------------------------------------------------------------------------

    input logic clk_i,

    //--------------------------------------------------------------------------
    // Read Port 1
    //--------------------------------------------------------------------------

    input  reg_addr_t rs1_addr_i,
    output xlen_t     rs1_data_o,

    //--------------------------------------------------------------------------
    // Read Port 2
    //--------------------------------------------------------------------------

    input  reg_addr_t rs2_addr_i,
    output xlen_t     rs2_data_o,

    //--------------------------------------------------------------------------
    // Write Port
    //--------------------------------------------------------------------------

    input  reg_addr_t rd_addr_i,
    input  xlen_t     rd_data_i,
    input  logic      rd_we_i

);

    //==========================================================================
    // Register File Storage
    //==========================================================================

    xlen_t reg_file [0:31];

    //==========================================================================
    // Read Port 1
    //==========================================================================

    assign rs1_data_o = (rs1_addr_i == 5'd0) ?
                        '0 :
                        reg_file[rs1_addr_i];

    //==========================================================================
    // Read Port 2
    //==========================================================================

    assign rs2_data_o = (rs2_addr_i == 5'd0) ?
                        '0 :
                        reg_file[rs2_addr_i];

    //==========================================================================
    // Write Port
    //==========================================================================

    always_ff @(posedge clk_i) begin

        if (rd_we_i && (rd_addr_i != 5'd0))
            reg_file[rd_addr_i] <= rd_data_i;

    end

endmodule : regfile
