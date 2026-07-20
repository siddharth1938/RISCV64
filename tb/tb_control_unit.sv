//==============================================================================
// Project      : RISCV64 Processor
// Module       : Control Unit Testbench
// File         : tb_control_unit.sv
//
// Description  :
//   Self-checking testbench for the Control Unit.
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module tb_control_unit;

    //==========================================================================
    // Package Imports
    //==========================================================================

    import riscv_pkg::*;
    import riscv_opcode_pkg::*;
    import riscv_funct_pkg::*;
    import riscv_alu_pkg::*;

    //==========================================================================
    // DUT Signals
    //==========================================================================

    opcode_t opcode_i;
    funct3_t funct3_i;
    funct7_t funct7_i;

    alu_op_t alu_op_o;

    logic reg_write_o;
    logic alu_src_o;

    logic mem_read_o;
    logic mem_write_o;

    logic [1:0] wb_sel_o;

    logic branch_o;
    logic jump_o;
    logic jalr_o;

    //==========================================================================
    // Statistics
    //==========================================================================

    integer total_tests;
    integer passed_tests;
    integer failed_tests;

    //==========================================================================
    // DUT
    //==========================================================================

    control_unit dut (

        .opcode_i(opcode_i),
        .funct3_i(funct3_i),
        .funct7_i(funct7_i),

        .alu_op_o(alu_op_o),

        .reg_write_o(reg_write_o),
        .alu_src_o(alu_src_o),

        .mem_read_o(mem_read_o),
        .mem_write_o(mem_write_o),

        .wb_sel_o(wb_sel_o),

        .branch_o(branch_o),
        .jump_o(jump_o),
        .jalr_o(jalr_o)

    );

    //==========================================================================
    // Waveform Dump
    //==========================================================================

    initial begin
        $dumpfile("../waves/tb_control_unit.vcd");
        $dumpvars(0, tb_control_unit);
    end

    //==========================================================================
    // Self Checking Task
    //==========================================================================

    task automatic check_control(

        input string      test_name,

        input opcode_t    opcode,
        input funct3_t    funct3,
        input funct7_t    funct7,

        input alu_op_t    exp_alu,

        input logic       exp_reg_write,
        input logic       exp_alu_src,

        input logic       exp_mem_read,
        input logic       exp_mem_write,

        input logic [1:0] exp_wb_sel,

        input logic       exp_branch,
        input logic       exp_jump,
        input logic       exp_jalr

    );

    begin

        total_tests++;

        opcode_i = opcode;
        funct3_i = funct3;
        funct7_i = funct7;

        #5;

        if (

            (alu_op_o    == exp_alu)       &&
            (reg_write_o == exp_reg_write) &&
            (alu_src_o   == exp_alu_src)   &&
            (mem_read_o  == exp_mem_read)  &&
            (mem_write_o == exp_mem_write) &&
            (wb_sel_o    == exp_wb_sel)    &&
            (branch_o    == exp_branch)    &&
            (jump_o      == exp_jump)      &&
            (jalr_o      == exp_jalr)

        )

        begin

            passed_tests++;

            $display("PASS : %s", test_name);

        end

        else

        begin

            failed_tests++;

            $display("");
            $display("======================================");
            $display("FAIL : %s", test_name);
            $display("======================================");

            $display("Expected");

            $display("ALU        : %0d", exp_alu);
            $display("REG_WRITE  : %0b", exp_reg_write);
            $display("ALU_SRC    : %0b", exp_alu_src);
            $display("MEM_READ   : %0b", exp_mem_read);
            $display("MEM_WRITE  : %0b", exp_mem_write);
            $display("WB_SEL     : %0b", exp_wb_sel);
            $display("BRANCH     : %0b", exp_branch);
            $display("JUMP       : %0b", exp_jump);
            $display("JALR       : %0b", exp_jalr);

            $display("");

            $display("Received");

            $display("ALU        : %0d", alu_op_o);
            $display("REG_WRITE  : %0b", reg_write_o);
            $display("ALU_SRC    : %0b", alu_src_o);
            $display("MEM_READ   : %0b", mem_read_o);
            $display("MEM_WRITE  : %0b", mem_write_o);
            $display("WB_SEL     : %0b", wb_sel_o);
            $display("BRANCH     : %0b", branch_o);
            $display("JUMP       : %0b", jump_o);
            $display("JALR       : %0b", jalr_o);

            $display("");

        end

    end

    endtask

    //==========================================================================
    // Test Sequence
    //==========================================================================

    initial begin

        total_tests  = 0;
        passed_tests = 0;
        failed_tests = 0;

        $display("");
        $display("==================================================");
        $display("        RISCV64 CONTROL UNIT VERIFICATION");
        $display("==================================================");
        $display("");

        //----------------------------------------------------------------------
        // R-Type Instructions
        //----------------------------------------------------------------------

        check_control("ADD",  OPCODE_OP, F3_ADD_SUB, F7_ADD, ALU_ADD,
                       1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);

        check_control("SUB",  OPCODE_OP, F3_ADD_SUB, F7_SUB, ALU_SUB,
                       1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);

        check_control("AND",  OPCODE_OP, F3_AND, F7_ADD, ALU_AND,
                       1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);

        check_control("OR",   OPCODE_OP, F3_OR, F7_ADD, ALU_OR,
                       1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);

        check_control("XOR",  OPCODE_OP, F3_XOR, F7_ADD, ALU_XOR,
                       1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);

        check_control("SLL",  OPCODE_OP, F3_SLL, F7_ADD, ALU_SLL,
                       1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);

        check_control("SRL",  OPCODE_OP, F3_SRL_SRA, F7_ADD, ALU_SRL,
                       1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);

        check_control("SRA",  OPCODE_OP, F3_SRL_SRA, F7_SUB, ALU_SRA,
                       1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);

        check_control("SLT",  OPCODE_OP, F3_SLT, F7_ADD, ALU_SLT,
                       1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);

        check_control("SLTU", OPCODE_OP, F3_SLTU, F7_ADD, ALU_SLTU,
                       1'b1, 1'b0, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);

        //----------------------------------------------------------------------
        // OP-IMM
        //----------------------------------------------------------------------

        check_control("ADDI", OPCODE_OP_IMM, F3_ADD_SUB, F7_ADD, ALU_ADD,
                       1'b1, 1'b1, 1'b0, 1'b0, 2'b00, 1'b0, 1'b0, 1'b0);

        //----------------------------------------------------------------------
        // LOAD
        //----------------------------------------------------------------------

        check_control("LD",   OPCODE_LOAD, F3_DWORD, F7_ADD, ALU_ADD,
                       1'b1, 1'b1, 1'b1, 1'b0, 2'b01, 1'b0, 1'b0, 1'b0);

        //----------------------------------------------------------------------
        // STORE
        //----------------------------------------------------------------------

        check_control("SD",   OPCODE_STORE, F3_DWORD, F7_ADD, ALU_ADD,
                       1'b0, 1'b1, 1'b0, 1'b1, 2'b00, 1'b0, 1'b0, 1'b0);

        //----------------------------------------------------------------------
        // BRANCH
        //----------------------------------------------------------------------

        check_control("BEQ",  OPCODE_BRANCH, F3_BEQ, F7_ADD, ALU_SUB,
                       1'b0, 1'b0, 1'b0, 1'b0, 2'b00, 1'b1, 1'b0, 1'b0);

        //----------------------------------------------------------------------
        // JAL
        //----------------------------------------------------------------------

        check_control("JAL",  OPCODE_JAL, 3'b000, 7'b0000000, ALU_ADD,
                       1'b1, 1'b0, 1'b0, 1'b0, 2'b10, 1'b0, 1'b1, 1'b0);

        //----------------------------------------------------------------------
        // JALR
        //----------------------------------------------------------------------

        check_control("JALR", OPCODE_JALR, 3'b000, 7'b0000000, ALU_ADD,
                       1'b1, 1'b1, 1'b0, 1'b0, 2'b10, 1'b0, 1'b0, 1'b1);

        //----------------------------------------------------------------------
        // Test Summary
        //----------------------------------------------------------------------

        $display("");
        $display("==================================================");
        $display("                TEST SUMMARY");
        $display("==================================================");

        $display("Total Tests  : %0d", total_tests);
        $display("Passed Tests : %0d", passed_tests);
        $display("Failed Tests : %0d", failed_tests);

        $display("");

        if (failed_tests == 0) begin

            $display("***********************************************");
            $display("*                                             *");
            $display("*      ALL CONTROL UNIT TESTS PASSED          *");
            $display("*                                             *");
            $display("***********************************************");

        end
        else begin

            $display("***********************************************");
            $display("*                                             *");
            $display("*      CONTROL UNIT TESTS FAILED              *");
            $display("*                                             *");
            $display("***********************************************");

        end

        $display("");
        $finish;

    end

endmodule : tb_control_unit
