//==============================================================================
// Project      : RISCV64 Processor
// Module       : JALR Target Generator Testbench
// File         : tb_jalr_target_gen.sv
//
// Description  :
//   Self-checking testbench for jalr_target_gen
//==============================================================================

`timescale 1ns/1ps

module tb_jalr_target_gen;

    import riscv_pkg::*;

    //==========================================================================
    // Testbench Signals
    //==========================================================================

    xlen_t rs1_data_i;
    xlen_t imm_i;

    xlen_t jalr_target_o;

    //==========================================================================
    // DUT
    //==========================================================================

    jalr_target_gen dut (

        .rs1_data_i    (rs1_data_i),
        .imm_i         (imm_i),
        .jalr_target_o (jalr_target_o)

    );

    //==========================================================================
    // Test Sequence
    //==========================================================================

    initial begin

        $dumpfile("../waves/tb_jalr_target_gen.vcd");
        $dumpvars(0, tb_jalr_target_gen);

        //----------------------------------------------------------------------
        // Test 1 : Simple Positive Offset
        //----------------------------------------------------------------------

        rs1_data_i = 64'h0000_0000_8000_0000;
        imm_i      = 64'h0000_0000_0000_0008;

        #1;

        if (jalr_target_o !== 64'h0000_0000_8000_0008) begin

            $display("TEST-1 FAILED");
            $display("Expected : %h",64'h0000_0000_8000_0008);
            $display("Received : %h",jalr_target_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 2 : Odd Address (LSB Must Be Cleared)
        //----------------------------------------------------------------------

        rs1_data_i = 64'h0000_0000_8000_0005;
        imm_i      = 64'h0000_0000_0000_0008;

        #1;

        if (jalr_target_o !== 64'h0000_0000_8000_000C) begin

            $display("TEST-2 FAILED");
            $display("Expected : %h",64'h0000_0000_8000_000C);
            $display("Received : %h",jalr_target_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 3 : Zero Offset
        //----------------------------------------------------------------------

        rs1_data_i = 64'h0000_0000_8000_0100;
        imm_i      = 64'd0;

        #1;

        if (jalr_target_o !== 64'h0000_0000_8000_0100) begin

            $display("TEST-3 FAILED");
            $display("Expected : %h",64'h0000_0000_8000_0100);
            $display("Received : %h",jalr_target_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 4 : Negative Offset
        //----------------------------------------------------------------------

        rs1_data_i = 64'h0000_0000_8000_0100;
        imm_i      = -64'd16;

        #1;

        if (jalr_target_o !== 64'h0000_0000_8000_00F0) begin

            $display("TEST-4 FAILED");
            $display("Expected : %h",64'h0000_0000_8000_00F0);
            $display("Received : %h",jalr_target_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 5 : Alignment Check
        //----------------------------------------------------------------------

        rs1_data_i = 64'h0000_0000_0000_0001;
        imm_i      = 64'd0;

        #1;

        if (jalr_target_o !== 64'h0000_0000_0000_0000) begin

            $display("TEST-5 FAILED");
            $display("Expected : %h",64'h0000_0000_0000_0000);
            $display("Received : %h",jalr_target_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // PASS
        //----------------------------------------------------------------------

        $display("");
        $display("==================================================");
        $display(" ALL JALR TARGET GENERATOR TESTS PASSED");
        $display("==================================================");
        $display("");

        #10;

        $finish;

    end

endmodule
