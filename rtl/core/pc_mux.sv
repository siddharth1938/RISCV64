//==============================================================================
// Project      : RISCV64 Processor
// Module       : PC Multiplexer
// File         : pc_mux.sv
//
// Description  :
//   Selects the next Program Counter (PC) value.
//
// Selection:
//   00 : PC + 4
//   01 : Branch Target
//   10 : Jump Target (JAL)
//   11 : JALR Target
//==============================================================================

`timescale 1ns/1ps

module pc_mux import riscv_pkg::*; (

    //==========================================================================
    // Inputs
    //==========================================================================

    input  xlen_t pc_plus4_i,
    input  xlen_t branch_target_i,
    input  xlen_t jump_target_i,
    input  xlen_t jalr_target_i,

    input  logic [1:0] pc_sel_i,

    //==========================================================================
    // Output
    //==========================================================================

    output xlen_t next_pc_o

);

    //==========================================================================
    // PC Selection Logic
    //==========================================================================

    always_comb begin

        unique case (pc_sel_i)

            2'b00 : next_pc_o = pc_plus4_i;

            2'b01 : next_pc_o = branch_target_i;

            2'b10 : next_pc_o = jump_target_i;

            2'b11 : next_pc_o = jalr_target_i;

            default : next_pc_o = pc_plus4_i;

        endcase

    end

endmodule
