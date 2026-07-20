//==============================================================================
// Project      : RISCV64 Processor
// Module       : ALU Operand Multiplexer Testbench
// File         : tb_alu_mux.sv
//
// Description  :
//   Self-checking testbench for the ALU Operand Multiplexer.
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module tb_alu_mux;

    import riscv_pkg::*;

    //==========================================================================
    // DUT Signals
    //==========================================================================

    xlen_t rs2_data;
    xlen_t immediate;
    logic  alu_src;

    xlen_t alu_operand_b;

    //==========================================================================
    // DUT
    //==========================================================================

    alu_mux dut (

        .rs2_data_i      (rs2_data),
        .imm_i           (immediate),
        .alu_src_i       (alu_src),
        .alu_operand_b_o (alu_operand_b)

    );

    //==========================================================================
    // Waveform Dump
    //==========================================================================

    initial begin

        $dumpfile("../waves/tb_alu_mux.vcd");
        $dumpvars(0, tb_alu_mux);

    end

    //==========================================================================
    // Test Sequence
    //==========================================================================

    initial begin

        $display("==================================================");
        $display("           ALU MUX TEST STARTED");
        $display("==================================================");

        //----------------------------------------------------------------------
        // Test 1 : Register Operand
        //----------------------------------------------------------------------

        rs2_data  = xlen_t'(25);
        immediate = xlen_t'(100);
        alu_src   = 1'b0;

        #10;

        if (alu_operand_b !== xlen_t'(25)) begin
            $display("TEST 1 FAILED");
            $fatal;
        end

        $display("TEST 1 PASSED");

        //----------------------------------------------------------------------
        // Test 2 : Immediate Operand
        //----------------------------------------------------------------------

        alu_src = 1'b1;

        #10;

        if (alu_operand_b !== xlen_t'(100)) begin
            $display("TEST 2 FAILED");
            $fatal;
        end

        $display("TEST 2 PASSED");

        //----------------------------------------------------------------------
        // Test 3 : Register Operand
        //----------------------------------------------------------------------

        rs2_data  = xlen_t'(555);
        immediate = xlen_t'(777);
        alu_src   = 1'b0;

        #10;

        if (alu_operand_b !== xlen_t'(555)) begin
            $display("TEST 3 FAILED");
            $fatal;
        end

        $display("TEST 3 PASSED");

        //----------------------------------------------------------------------
        // Test 4 : Immediate Operand
        //----------------------------------------------------------------------

        alu_src = 1'b1;

        #10;

        if (alu_operand_b !== xlen_t'(777)) begin
            $display("TEST 4 FAILED");
            $fatal;
        end

        $display("TEST 4 PASSED");

        //----------------------------------------------------------------------
        // Finish
        //----------------------------------------------------------------------

        $display("");
        $display("==================================================");
        $display("        ALL ALU MUX TESTS PASSED");
        $display("==================================================");

        #10;
        $finish;

    end

endmodule : tb_alu_mux
