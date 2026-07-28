//==============================================================================
// Project      : RISCV64 Processor
// Module       : PC Control Unit Testbench
// File         : tb_pc_control.sv
//
// Description  :
//   Self-checking testbench for the PC Control Unit.
//
//   Test Cases:
//     1. Sequential Execution
//     2. Branch Not Taken
//     3. Branch Taken
//     4. JAL Instruction
//     5. JALR Instruction
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module tb_pc_control;

    //==========================================================================
    // DUT Signals
    //==========================================================================

    logic branch_i;
    logic jump_i;
    logic jalr_i;
    logic branch_taken_i;

    logic load_pc_o;
    logic [1:0] pc_sel_o;

    //==========================================================================
    // Statistics
    //==========================================================================

    integer total_tests;
    integer passed_tests;
    integer failed_tests;

    //==========================================================================
    // DUT
    //==========================================================================

    pc_control dut (

        .branch_i(branch_i),
        .jump_i(jump_i),
        .jalr_i(jalr_i),
        .branch_taken_i(branch_taken_i),

        .load_pc_o(load_pc_o),
        .pc_sel_o(pc_sel_o)

    );

    //==========================================================================
    // Waveform Dump
    //==========================================================================

    initial begin
        $dumpfile("../waves/tb_pc_control.vcd");
        $dumpvars(0, tb_pc_control);
    end

    //==========================================================================
    // Self-Checking Task
    //==========================================================================

    task automatic check_output(

        input string test_name,
        input logic expected_load,
        input logic [1:0] expected_sel

    );

    begin

        total_tests++;

        if ((load_pc_o === expected_load) &&
            (pc_sel_o  === expected_sel)) begin

            passed_tests++;

            $display("PASS : %-25s load_pc=%b pc_sel=%b",
                     test_name, load_pc_o, pc_sel_o);

        end
        else begin

            failed_tests++;

            $display("FAIL : %-25s Expected(load=%b sel=%b) Got(load=%b sel=%b)",
                     test_name,
                     expected_load,
                     expected_sel,
                     load_pc_o,
                     pc_sel_o);

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
        $display("          PC CONTROL UNIT VERIFICATION");
        $display("==================================================");

        //----------------------------------------------------------------------
        // Test 1 : Sequential Execution
        //----------------------------------------------------------------------

        branch_i       = 0;
        jump_i         = 0;
        jalr_i         = 0;
        branch_taken_i = 0;

        #10;

        check_output("Sequential Execution",1'b1,2'b00);

        //----------------------------------------------------------------------
        // Test 2 : Branch Not Taken
        //----------------------------------------------------------------------

        branch_i       = 1;
        jump_i         = 0;
        jalr_i         = 0;
        branch_taken_i = 0;

        #10;

        check_output("Branch Not Taken",1'b1,2'b00);

        //----------------------------------------------------------------------
        // Test 3 : Branch Taken
        //----------------------------------------------------------------------

        branch_i       = 1;
        jump_i         = 0;
        jalr_i         = 0;
        branch_taken_i = 1;

        #10;

        check_output("Branch Taken",1'b1,2'b01);

        //----------------------------------------------------------------------
        // Test 4 : JAL
        //----------------------------------------------------------------------

        branch_i       = 0;
        jump_i         = 1;
        jalr_i         = 0;
        branch_taken_i = 0;

        #10;

        check_output("JAL Instruction",1'b1,2'b10);

        //----------------------------------------------------------------------
        // Test 5 : JALR
        //----------------------------------------------------------------------

        branch_i       = 0;
        jump_i         = 0;
        jalr_i         = 1;
        branch_taken_i = 0;

        #10;

        check_output("JALR Instruction",1'b1,2'b11);

        //----------------------------------------------------------------------
        // Summary
        //----------------------------------------------------------------------

        $display("");
        $display("==================================================");
        $display("                 TEST SUMMARY");
        $display("==================================================");

        $display("Total Tests  : %0d", total_tests);
        $display("Passed Tests : %0d", passed_tests);
        $display("Failed Tests : %0d", failed_tests);

        $display("");

        if (failed_tests == 0) begin

            $display("***********************************************");
            $display("*                                             *");
            $display("*     ALL PC CONTROL TESTS PASSED             *");
            $display("*                                             *");
            $display("***********************************************");

        end
        else begin

            $display("***********************************************");
            $display("*                                             *");
            $display("*      PC CONTROL TESTS FAILED                *");
            $display("*                                             *");
            $display("***********************************************");

        end

        $display("");

        $finish;

    end

endmodule : tb_pc_control
