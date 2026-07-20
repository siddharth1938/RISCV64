//==============================================================================
// Project      : RISCV64 Processor
// Module       : Execute Stage
// File         : execute_stage.sv
//
// Description  :
//   Integrates the Execute stage of the RV64I processor.
//
//   This module instantiates:
//     - ALU Operand MUX
//     - ALU
//     - Branch Comparator
//     - Branch Target Generator
//     - JALR Target Generator
//
//==============================================================================

`timescale 1ns/1ps

module execute_stage
    import riscv_pkg::*;
    import riscv_alu_pkg::*;
(

    //--------------------------------------------------------------------------
    // Inputs
    //--------------------------------------------------------------------------

    // Register File Outputs
    input  xlen_t   rs1_data_i,
    input  xlen_t   rs2_data_i,

    // Immediate Generator Output
    input  xlen_t   imm_i,

    // Program Counter
    input  xlen_t   pc_i,

    // Control Signals
    input  logic    alu_src_i,
    input  alu_op_t alu_op_i,
    input  funct3_t funct3_i,

    //--------------------------------------------------------------------------
    // Outputs
    //--------------------------------------------------------------------------

    // ALU Result
    output xlen_t   alu_result_o,

    // Branch Decision
    output logic    branch_taken_o,

    // Branch Target Address
    output xlen_t   branch_target_o,

    // JALR Target Address
    output xlen_t   jalr_target_o

);

    //==========================================================================
    // Internal Signals
    //==========================================================================

    // ALU Operand B
    xlen_t alu_operand_b;

    // ALU Zero Flag (Unused)
    logic zero_unused;

    //==========================================================================
    // ALU Operand Multiplexer
    //==========================================================================

    alu_mux u_alu_mux (

        .rs2_data_i      (rs2_data_i),
        .imm_i           (imm_i),
        .alu_src_i       (alu_src_i),

        .alu_operand_b_o (alu_operand_b)

    );

    //==========================================================================
    // Arithmetic Logic Unit
    //==========================================================================

    alu u_alu (

        .operand_a_i (rs1_data_i),
        .operand_b_i (alu_operand_b),

        .alu_op_i    (alu_op_i),

        .result_o    (alu_result_o),
        .zero_o      (zero_unused)

    );

    //==========================================================================
    // Branch Comparator
    //==========================================================================

    branch_comparator u_branch_comparator (

        .rs1_data_i      (rs1_data_i),
        .rs2_data_i      (rs2_data_i),
        .funct3_i        (funct3_i),

        .branch_taken_o  (branch_taken_o)

    );

    //==========================================================================
    // Branch Target Generator
    //==========================================================================

    branch_target_gen u_branch_target_gen (

        .pc_i             (pc_i),
        .imm_i            (imm_i),

        .branch_target_o  (branch_target_o)

    );

    //==========================================================================
    // JALR Target Generator
    //==========================================================================

    jalr_target_gen u_jalr_target_gen (

        .rs1_data_i      (rs1_data_i),
        .imm_i           (imm_i),

        .jalr_target_o   (jalr_target_o)

    );

endmodule : execute_stage
