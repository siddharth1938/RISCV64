//==============================================================================
// Project      : RISCV64 Processor
// Module       : Control Unit
// File         : control_unit.sv
//
// Description  :
//   Generates processor control signals from the decoded instruction fields.
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module control_unit

    import riscv_pkg::*;
    import riscv_opcode_pkg::*;
    import riscv_funct_pkg::*;
    import riscv_alu_pkg::*;

(

    //--------------------------------------------------------------------------
    // Decoded Instruction Fields
    //--------------------------------------------------------------------------

    input opcode_t opcode_i,
    input funct3_t funct3_i,
    input funct7_t funct7_i,

    //--------------------------------------------------------------------------
    // Control Outputs
    //--------------------------------------------------------------------------

    output alu_op_t alu_op_o,
    output logic    reg_write_o,
    output logic    alu_src_o

);

    //==========================================================================
    // Control Logic
    //==========================================================================

    always_comb begin

        //----------------------------------------------------------------------
        // Default Outputs
        //----------------------------------------------------------------------

        alu_op_o    = ALU_ADD;
        reg_write_o = 1'b0;
        alu_src_o   = 1'b0;

        //----------------------------------------------------------------------
        // Main Opcode Decode
        //----------------------------------------------------------------------

        unique case (opcode_i)

            //------------------------------------------------------------------
            // R-Type Instructions
            //------------------------------------------------------------------

            OPCODE_OP: begin

                reg_write_o = 1'b1;
                alu_src_o   = 1'b0;

                unique case (funct3_i)

                    F3_ADD_SUB:
                        alu_op_o = (funct7_i == F7_SUB) ? ALU_SUB : ALU_ADD;

                    F3_SLL:
                        alu_op_o = ALU_SLL;

                    F3_SLT:
                        alu_op_o = ALU_SLT;

                    F3_SLTU:
                        alu_op_o = ALU_SLTU;

                    F3_XOR:
                        alu_op_o = ALU_XOR;

                    F3_SRL_SRA:
                        alu_op_o = (funct7_i == F7_SUB) ? ALU_SRA : ALU_SRL;

                    F3_OR:
                        alu_op_o = ALU_OR;

                    F3_AND:
                        alu_op_o = ALU_AND;

                    default:
                        alu_op_o = ALU_ADD;

                endcase

            end

            //------------------------------------------------------------------
            // I-Type Arithmetic Instructions
            //------------------------------------------------------------------

            OPCODE_OP_IMM: begin

                reg_write_o = 1'b1;
                alu_src_o   = 1'b1;

                unique case (funct3_i)

                    F3_ADD_SUB:
                        alu_op_o = ALU_ADD;

                    F3_SLL:
                        alu_op_o = ALU_SLL;

                    F3_SLT:
                        alu_op_o = ALU_SLT;

                    F3_SLTU:
                        alu_op_o = ALU_SLTU;

                    F3_XOR:
                        alu_op_o = ALU_XOR;

                    F3_SRL_SRA:
                        alu_op_o = (funct7_i == F7_SUB) ? ALU_SRA : ALU_SRL;

                    F3_OR:
                        alu_op_o = ALU_OR;

                    F3_AND:
                        alu_op_o = ALU_AND;

                    default:
                        alu_op_o = ALU_ADD;

                endcase

            end

            //------------------------------------------------------------------
            // Default
            //------------------------------------------------------------------

            default: begin

                alu_op_o    = ALU_ADD;
                reg_write_o = 1'b0;
                alu_src_o   = 1'b0;

            end

        endcase

    end

endmodule : control_unit
