//==============================================================================
// Project      : RISCV64 Processor
// Module       : Top Level Processor
// File         : riscv64_top.sv
//
// Description  :
//   Top-level integration of the RV64I single-cycle processor.
//
//   fetch (pc+imem) -> decoder -> {imm_gen, regfile, control_unit}
//        -> execute_stage -> data_mem -> wb_mux -> regfile write-back
//        -> pc_mux -> fetch (PC redirect)
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module riscv64_top
    import riscv_pkg::*;
    import riscv_opcode_pkg::*;
    import riscv_funct_pkg::*;
    import riscv_alu_pkg::*;
(
    input logic clk_i,
    input logic rst_ni
);

    //==========================================================================
    // Program Counter / Fetch Signals
    //==========================================================================

    xlen_t  pc;
    xlen_t  next_pc;
    xlen_t  pc_plus4;
    instr_t instruction;

    //==========================================================================
    // Decoder Outputs
    //==========================================================================

    opcode_t   opcode;
    reg_addr_t rs1_addr;
    reg_addr_t rs2_addr;
    reg_addr_t rd_addr;
    funct3_t   funct3;
    funct7_t   funct7;

    //==========================================================================
    // Immediate Generator
    //==========================================================================

    xlen_t immediate;

    //==========================================================================
    // Register File
    //==========================================================================

    xlen_t rs1_data;
    xlen_t rs2_data;
    xlen_t write_back_data;

    //==========================================================================
    // Control Signals
    //==========================================================================

    alu_op_t    alu_op;
    logic       reg_write;
    logic       alu_src;
    logic       mem_read;
    logic       mem_write;
    logic [1:0] wb_sel;
    logic       branch;
    logic       jump;
    logic       jalr;

    //==========================================================================
    // Execute Stage
    //==========================================================================

    xlen_t alu_result;
    xlen_t branch_target;
    xlen_t jalr_target;
    logic  branch_taken;

    //==========================================================================
    // Data Memory
    //==========================================================================

    xlen_t mem_data;

    //==========================================================================
    // PC Redirect
    //==========================================================================

    logic [1:0] pc_sel;

    //==========================================================================
    // Fetch Stage (contains PC + Instruction Memory internally)
    //==========================================================================

    fetch u_fetch (

        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .load_pc_i  (1'b1),          // pc_mux always supplies the correct
                                      // next value (PC+4 included at pc_sel=00)
        .next_pc_i  (next_pc),

        .pc_o       (pc),
        .instr_o    (instruction)

    );

    assign pc_plus4 = pc + xlen_t'(4);

    //==========================================================================
    // Instruction Decoder
    //==========================================================================

    decoder u_decoder (

        .instr_i  (instruction),

        .opcode_o (opcode),
        .rd_o     (rd_addr),
        .rs1_o    (rs1_addr),
        .rs2_o    (rs2_addr),
        .funct3_o (funct3),
        .funct7_o (funct7)

    );

    //==========================================================================
    // Immediate Generator
    //==========================================================================

    imm_gen u_imm_gen (

        .instr_i (instruction),
        .imm_o   (immediate)

    );

    //==========================================================================
    // Control Unit
    //==========================================================================

    control_unit u_control_unit (

        .opcode_i    (opcode),
        .funct3_i    (funct3),
        .funct7_i    (funct7),

        .alu_op_o    (alu_op),
        .reg_write_o (reg_write),
        .alu_src_o   (alu_src),

        .mem_read_o  (mem_read),
        .mem_write_o (mem_write),

        .wb_sel_o    (wb_sel),

        .branch_o    (branch),
        .jump_o      (jump),
        .jalr_o      (jalr)

    );

    //==========================================================================
    // Register File
    //==========================================================================

    regfile u_regfile (

        .clk_i      (clk_i),

        .rs1_addr_i (rs1_addr),
        .rs1_data_o (rs1_data),

        .rs2_addr_i (rs2_addr),
        .rs2_data_o (rs2_data),

        .rd_addr_i  (rd_addr),
        .rd_data_i  (write_back_data),
        .rd_we_i    (reg_write)

    );

    //==========================================================================
    // Execute Stage (ALU + Branch Compare + Branch/JALR Target Math)
    //==========================================================================

    execute_stage u_execute_stage (

        .rs1_data_i      (rs1_data),
        .rs2_data_i      (rs2_data),
        .imm_i           (immediate),
        .pc_i            (pc),

        .alu_src_i       (alu_src),
        .alu_op_i        (alu_op),
        .funct3_i        (funct3),

        .alu_result_o    (alu_result),
        .branch_taken_o  (branch_taken),
        .branch_target_o (branch_target),
        .jalr_target_o   (jalr_target)

    );

    //==========================================================================
    // Data Memory
    //==========================================================================

    data_mem u_data_mem (

        .clk_i        (clk_i),

        .addr_i       (alu_result),
        .write_data_i (rs2_data),

        .mem_read_i   (mem_read),
        .mem_write_i  (mem_write),

        .read_data_o  (mem_data)

    );

    //==========================================================================
    // Write-Back Mux
    //==========================================================================

    wb_mux u_wb_mux (

        .alu_result_i (alu_result),
        .mem_data_i   (mem_data),
        .pc_plus4_i   (pc_plus4),

        .wb_sel_i     (wb_sel),

        .write_data_o (write_back_data)

    );

    //==========================================================================
    // PC Selection Logic
    //   (branch / jump / jalr are mutually exclusive - only one opcode class
    //    is active per instruction - so priority order doesn't affect
    //    correctness, only readability.)
    //==========================================================================

    always_comb begin

        pc_sel = 2'b00;

        if (branch && branch_taken)
            pc_sel = 2'b01;
        else if (jump)
            pc_sel = 2'b10;
        else if (jalr)
            pc_sel = 2'b11;

    end

    //==========================================================================
    // Next PC Mux
    //==========================================================================

    pc_mux u_pc_mux (

        .pc_plus4_i      (pc_plus4),
        .branch_target_i (branch_target),
        .jump_target_i   (branch_target), // JAL target uses the same PC+imm math
        .jalr_target_i   (jalr_target),

        .pc_sel_i        (pc_sel),

        .next_pc_o       (next_pc)

    );

endmodule : riscv64_top
