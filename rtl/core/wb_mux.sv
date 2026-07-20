//==============================================================================
// Project      : RISCV64 Processor
// Module       : Write Back Multiplexer
// File         : wb_mux.sv
//
// Description  :
//   Selects the data to be written back into the Register File.
//
// Write Back Sources:
//   00 : ALU Result
//   01 : Data Memory
//   10 : PC + 4
//   11 : Reserved (Outputs Zero)
//==============================================================================

`timescale 1ns/1ps

module wb_mux import riscv_pkg::*; (

    //==========================================================================
    // Inputs
    //==========================================================================

    input  xlen_t alu_result_i,
    input  xlen_t mem_data_i,
    input  xlen_t pc_plus4_i,

    input  logic [1:0] wb_sel_i,

    //==========================================================================
    // Output
    //==========================================================================

    output xlen_t write_data_o

);

    //==========================================================================
    // Write Back Multiplexer
    //==========================================================================

    always_comb begin

        unique case (wb_sel_i)

            2'b00 : write_data_o = alu_result_i;

            2'b01 : write_data_o = mem_data_i;

            2'b10 : write_data_o = pc_plus4_i;

            default : write_data_o = '0;

        endcase

    end

endmodule
