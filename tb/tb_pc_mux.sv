//==============================================================================
// Project      : RISCV64 Processor
// Module       : PC Multiplexer Testbench
// File         : tb_pc_mux.sv
//
// Description  :
//   Self-checking testbench for pc_mux
//==============================================================================

`timescale 1ns/1ps

module tb_pc_mux;

    import riscv_pkg::*;

    //==========================================================================
    // Testbench Signals
    //==========================================================================

    xlen_t pc_plus4_i;
    xlen_t branch_target_i;
    xlen_t jump_target_i;
    xlen_t jalr_target_i;

    logic [1:0] pc_sel_i;

    xlen_t next_pc_o;

    //==========================================================================
    // DUT
    //==========================================================================

    pc_mux dut (

        .pc_plus4_i      (pc_plus4_i),
        .branch_target_i (branch_target_i),
        .jump_target_i   (jump_target_i),
        .jalr_target_i   (jalr_target_i),

        .pc_sel_i        (pc_sel_i),

        .next_pc_o       (next_pc_o)

    );

    //==========================================================================
    // Test Sequence
    //==========================================================================

    initial begin

        $dumpfile("../waves/tb_pc_mux.vcd");
        $dumpvars(0, tb_pc_mux);

        //----------------------------------------------------------------------
        // Initialize Inputs
        //----------------------------------------------------------------------

        pc_plus4_i      = 64'h0000_0000_8000_0004;
        branch_target_i = 64'h0000_0000_8000_0100;
        jump_target_i   = 64'h0000_0000_8000_0200;
        jalr_target_i   = 64'h0000_0000_8000_0300;

        //----------------------------------------------------------------------
        // Test 1 : Sequential PC (PC + 4)
        //----------------------------------------------------------------------

        pc_sel_i = 2'b00;

        #1;

        if (next_pc_o !== pc_plus4_i) begin

            $display("TEST-1 FAILED");
            $display("Expected : %h", pc_plus4_i);
            $display("Received : %h", next_pc_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 2 : Branch Target
        //----------------------------------------------------------------------

        pc_sel_i = 2'b01;

        #1;

        if (next_pc_o !== branch_target_i) begin

            $display("TEST-2 FAILED");
            $display("Expected : %h", branch_target_i);
            $display("Received : %h", next_pc_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 3 : Jump Target (JAL)
        //----------------------------------------------------------------------

        pc_sel_i = 2'b10;

        #1;

        if (next_pc_o !== jump_target_i) begin

            $display("TEST-3 FAILED");
            $display("Expected : %h", jump_target_i);
            $display("Received : %h", next_pc_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 4 : JALR Target
        //----------------------------------------------------------------------

        pc_sel_i = 2'b11;

        #1;

        if (next_pc_o !== jalr_target_i) begin

            $display("TEST-4 FAILED");
            $display("Expected : %h", jalr_target_i);
            $display("Received : %h", next_pc_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // PASS
        //----------------------------------------------------------------------

        $display("");
        $display("===========================================");
        $display("    ALL PC MUX TESTS PASSED");
        $display("===========================================");
        $display("");

        #10;

        $finish;

    end

endmodule
