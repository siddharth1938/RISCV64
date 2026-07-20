//==============================================================================
// Project      : RISCV64 Processor
// Module       : Write Back Multiplexer Testbench
// File         : tb_wb_mux.sv
//
// Description  :
//   Self-checking testbench for wb_mux
//==============================================================================

`timescale 1ns/1ps

module tb_wb_mux;

    import riscv_pkg::*;

    //==========================================================================
    // Testbench Signals
    //==========================================================================

    xlen_t alu_result_i;
    xlen_t mem_data_i;
    xlen_t pc_plus4_i;

    logic [1:0] wb_sel_i;

    xlen_t write_data_o;

    //==========================================================================
    // DUT
    //==========================================================================

    wb_mux dut (

        .alu_result_i (alu_result_i),
        .mem_data_i   (mem_data_i),
        .pc_plus4_i   (pc_plus4_i),

        .wb_sel_i     (wb_sel_i),

        .write_data_o (write_data_o)

    );

    //==========================================================================
    // Test Sequence
    //==========================================================================

    initial begin

        $dumpfile("../waves/tb_wb_mux.vcd");
        $dumpvars(0, tb_wb_mux);

        //----------------------------------------------------------------------
        // Initialize Inputs
        //----------------------------------------------------------------------

        alu_result_i = 64'h1111_1111_1111_1111;
        mem_data_i   = 64'h2222_2222_2222_2222;
        pc_plus4_i   = 64'h3333_3333_3333_3333;

        //----------------------------------------------------------------------
        // Test 1 : Select ALU Result
        //----------------------------------------------------------------------

        wb_sel_i = 2'b00;

        #1;

        if (write_data_o !== alu_result_i) begin

            $display("TEST-1 FAILED");
            $display("Expected : %h", alu_result_i);
            $display("Received : %h", write_data_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 2 : Select Memory Data
        //----------------------------------------------------------------------

        wb_sel_i = 2'b01;

        #1;

        if (write_data_o !== mem_data_i) begin

            $display("TEST-2 FAILED");
            $display("Expected : %h", mem_data_i);
            $display("Received : %h", write_data_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 3 : Select PC + 4
        //----------------------------------------------------------------------

        wb_sel_i = 2'b10;

        #1;

        if (write_data_o !== pc_plus4_i) begin

            $display("TEST-3 FAILED");
            $display("Expected : %h", pc_plus4_i);
            $display("Received : %h", write_data_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // Test 4 : Reserved Selection
        //----------------------------------------------------------------------

        wb_sel_i = 2'b11;

        #1;

        if (write_data_o !== 64'd0) begin

            $display("TEST-4 FAILED");
            $display("Expected : %h", 64'd0);
            $display("Received : %h", write_data_o);

            $finish;

        end

        //----------------------------------------------------------------------
        // PASS
        //----------------------------------------------------------------------

        $display("");
        $display("===========================================");
        $display("    ALL WB MUX TESTS PASSED");
        $display("===========================================");
        $display("");

        #10;

        $finish;

    end

endmodule
