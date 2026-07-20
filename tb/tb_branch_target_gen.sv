//==============================================================================
// Project      : RISCV64 Processor
// Module       : Branch Target Generator Testbench
// File         : tb_branch_target_gen.sv
//
// Description  :
//   Self-checking testbench for branch_target_gen
//==============================================================================

`timescale 1ns/1ps

module tb_branch_target_gen;

    import riscv_pkg::*;

    //==========================================================================
    // Testbench Signals
    //==========================================================================

    xlen_t pc_i;
    xlen_t imm_i;

    xlen_t branch_target_o;

    //==========================================================================
    // DUT
    //==========================================================================

    branch_target_gen dut (

        .pc_i            (pc_i),
        .imm_i           (imm_i),

        .branch_target_o (branch_target_o)

    );

    //==========================================================================
    // Test Sequence
    //==========================================================================

    initial begin

        $dumpfile("../waves/tb_branch_target_gen.vcd");
        $dumpvars(0, tb_branch_target_gen);

        //----------------------------------------------------------------------
        // Test 1 : Forward Branch
        //----------------------------------------------------------------------

        pc_i  = 64'h0000_0000_8000_0000;
        imm_i = 64'h0000_0000_0000_0010;

        #1;

        if (branch_target_o !== 64'h0000_0000_8000_0010) begin

            $display("TEST-1 FAILED");
            $display("Expected : %h", 64'h0000_0000_8000_0010);
            $display("Received : %h", branch_target_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 2 : Larger Forward Branch
        //----------------------------------------------------------------------

        pc_i  = 64'h0000_0000_8000_0100;
        imm_i = 64'h0000_0000_0000_0040;

        #1;

        if (branch_target_o !== 64'h0000_0000_8000_0140) begin

            $display("TEST-2 FAILED");
            $display("Expected : %h", 64'h0000_0000_8000_0140);
            $display("Received : %h", branch_target_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 3 : Backward Branch
        //----------------------------------------------------------------------

        pc_i  = 64'h0000_0000_8000_0100;
        imm_i = -64'd16;

        #1;

        if (branch_target_o !== 64'h0000_0000_8000_00F0) begin

            $display("TEST-3 FAILED");
            $display("Expected : %h", 64'h0000_0000_8000_00F0);
            $display("Received : %h", branch_target_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 4 : Zero Offset
        //----------------------------------------------------------------------

        pc_i  = 64'h0000_0000_8000_0200;
        imm_i = 64'd0;

        #1;

        if (branch_target_o !== 64'h0000_0000_8000_0200) begin

            $display("TEST-4 FAILED");
            $display("Expected : %h", 64'h0000_0000_8000_0200);
            $display("Received : %h", branch_target_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // PASS
        //----------------------------------------------------------------------

        $display("");
        $display("==============================================");
        $display(" ALL BRANCH TARGET GENERATOR TESTS PASSED");
        $display("==============================================");
        $display("");

        #10;

        $finish;

    end

endmodule
