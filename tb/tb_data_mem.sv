//==============================================================================
// Project      : RISCV64 Processor
// Module       : Data Memory Testbench
// File         : tb_data_mem.sv
//
// Description  :
//   Self-checking testbench for data_mem
//==============================================================================

`timescale 1ns/1ps

module tb_data_mem;

    import riscv_pkg::*;

    //==========================================================================
    // Testbench Signals
    //==========================================================================

    logic clk_i;

    xlen_t addr_i;
    xlen_t write_data_i;

    logic mem_read_i;
    logic mem_write_i;

    xlen_t read_data_o;

    //==========================================================================
    // DUT
    //==========================================================================

    data_mem dut (

        .clk_i        (clk_i),

        .addr_i       (addr_i),
        .write_data_i (write_data_i),

        .mem_read_i   (mem_read_i),
        .mem_write_i  (mem_write_i),

        .read_data_o  (read_data_o)

    );

    //==========================================================================
    // Clock Generation
    //==========================================================================

    initial begin
        clk_i = 1'b0;
        forever #5 clk_i = ~clk_i;
    end

    //==========================================================================
    // Test Sequence
    //==========================================================================

    initial begin

        $dumpfile("../waves/tb_data_mem.vcd");
        $dumpvars(0, tb_data_mem);

        //----------------------------------------------------------------------
        // Initialize
        //----------------------------------------------------------------------

        addr_i       = '0;
        write_data_i = '0;
        mem_read_i   = 1'b0;
        mem_write_i  = 1'b0;

        #2;

        //----------------------------------------------------------------------
        // Test 1 : Read Empty Memory
        //----------------------------------------------------------------------

        addr_i      = 64'd0;
        mem_read_i  = 1'b1;

        #1;

        if (read_data_o !== 64'd0) begin
            $display("TEST-1 FAILED");
            $display("Expected = %h",64'd0);
            $display("Received = %h",read_data_o);
            $finish;
        end

        mem_read_i = 1'b0;

        //----------------------------------------------------------------------
        // Test 2 : Write Location 0
        //----------------------------------------------------------------------

        addr_i       = 64'd0;
        write_data_i = 64'h1234_5678_9ABC_DEF0;
        mem_write_i  = 1'b1;

        @(posedge clk_i);

        #1;

        mem_write_i = 1'b0;

        //----------------------------------------------------------------------
        // Test 3 : Read Location 0
        //----------------------------------------------------------------------

        mem_read_i = 1'b1;

        #1;

        if (read_data_o !== 64'h1234_5678_9ABC_DEF0) begin
            $display("TEST-3 FAILED");
            $display("Expected = %h",64'h1234_5678_9ABC_DEF0);
            $display("Received = %h",read_data_o);
            $finish;
        end

        mem_read_i = 1'b0;

        //----------------------------------------------------------------------
        // Test 4 : Write Location 8
        //----------------------------------------------------------------------

        addr_i       = 64'd8;
        write_data_i = 64'hDEAD_BEEF_CAFE_BABE;
        mem_write_i  = 1'b1;

        @(posedge clk_i);

        #1;

        mem_write_i = 1'b0;

        //----------------------------------------------------------------------
        // Test 5 : Read Location 8
        //----------------------------------------------------------------------

        mem_read_i = 1'b1;

        #1;

        if (read_data_o !== 64'hDEAD_BEEF_CAFE_BABE) begin
            $display("TEST-5 FAILED");
            $display("Expected = %h",64'hDEAD_BEEF_CAFE_BABE);
            $display("Received = %h",read_data_o);
            $finish;
        end

        mem_read_i = 1'b0;

        //----------------------------------------------------------------------
        // Test 6 : Read Location 0 Again
        //----------------------------------------------------------------------

        addr_i = 64'd0;
        mem_read_i = 1'b1;

        #1;

        if (read_data_o !== 64'h1234_5678_9ABC_DEF0) begin
            $display("TEST-6 FAILED");
            $display("Expected = %h",64'h1234_5678_9ABC_DEF0);
            $display("Received = %h",read_data_o);
            $finish;
        end

        mem_read_i = 1'b0;

        //----------------------------------------------------------------------
        // Test 7 : Read Disabled
        //----------------------------------------------------------------------

        #1;

        if (read_data_o !== 64'd0) begin
            $display("TEST-7 FAILED");
            $display("Expected = %h",64'd0);
            $display("Received = %h",read_data_o);
            $finish;
        end

        //----------------------------------------------------------------------
        // PASS
        //----------------------------------------------------------------------

        $display("");
        $display("===========================================");
        $display("   ALL DATA MEMORY TESTS PASSED");
        $display("===========================================");
        $display("");

        #10;
        $finish;

    end

endmodule
