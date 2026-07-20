//==============================================================================
// Project      : RISCV64 Processor
// Module       : Branch Comparator
// File         : branch_comparator.sv
//
// Description  :
//   Evaluates RV64I branch conditions and generates the branch_taken signal.
//
// Supported Instructions:
//   BEQ   - Branch if Equal
//   BNE   - Branch if Not Equal
//   BLT   - Branch if Less Than (Signed)
//   BGE   - Branch if Greater Than or Equal (Signed)
//   BLTU  - Branch if Less Than (Unsigned)
//   BGEU  - Branch if Greater Than or Equal (Unsigned)
//==============================================================================

`timescale 1ns/1ps

module branch_comparator import riscv_pkg::*; (

    //==========================================================================
    // Inputs
    //==========================================================================

    input  xlen_t   rs1_data_i,
    input  xlen_t   rs2_data_i,
    input  funct3_t funct3_i,

    //==========================================================================
    // Output
    //==========================================================================

    output logic    branch_taken_o

);

    //==========================================================================
    // Branch Comparison Logic
    //==========================================================================

    always_comb begin

        // Default: branch not taken
        branch_taken_o = 1'b0;

        unique case (funct3_i)

            //==============================================================
            // BEQ
            //==============================================================
            3'b000: begin
                branch_taken_o = (rs1_data_i == rs2_data_i);
            end

            //==============================================================
            // BNE
            //==============================================================
            3'b001: begin
                branch_taken_o = (rs1_data_i != rs2_data_i);
            end

            //==============================================================
            // BLT (Signed)
            //==============================================================
            3'b100: begin
                branch_taken_o = ($signed(rs1_data_i) < $signed(rs2_data_i));
            end

            //==============================================================
            // BGE (Signed)
            //==============================================================
            3'b101: begin
                branch_taken_o = ($signed(rs1_data_i) >= $signed(rs2_data_i));
            end

            //==============================================================
            // BLTU (Unsigned)
            //==============================================================
            3'b110: begin
                branch_taken_o = (rs1_data_i < rs2_data_i);
            end

            //==============================================================
            // BGEU (Unsigned)
            //==============================================================
            3'b111: begin
                branch_taken_o = (rs1_data_i >= rs2_data_i);
            end

            //==============================================================
            // Invalid funct3
            //==============================================================
            default: begin
                branch_taken_o = 1'b0;
            end

        endcase

    end

endmodule
