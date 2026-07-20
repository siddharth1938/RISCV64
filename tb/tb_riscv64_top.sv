//==============================================================================
// Project      : RISCV64 Processor
// Module       : Top-Level Testbench
// File         : tb_riscv64_top.sv
//
// Description  :
//   End-to-end testbench for riscv64_top, running the program preloaded
//   into instr_mem (programs/matrix_mul_3x3.hex) and self-checking
//   architectural register state at fixed points in execution.
//
//   IMPORTANT - Program under test:
//     matrix_mul_3x3.hex currently contains a 10-instruction placeholder
//     (ADDI / ADD / SUB / JALR only) - it does NOT contain the compiled
//     matrix multiplication C program, and it exercises neither the
//     branch_comparator nor data_mem paths. The final instruction is
//     "jalr x0, 0(x1)" with x1=1, which computes target (1+0)&~1 = 0 and
//     loops back to the start of the program forever. Because x4 is not
//     reset each pass ("add x4,x1,x4" accumulates), register state is
//     genuinely different after each loop pass, so this testbench checks
//     three full passes (30 cycles) rather than a single static endpoint.
//
//   Instruction trace (indices 0-9, hand-decoded):
//     0: addi x0,x0,0      (nop)
//     1: addi x1,x0,1
//     2: addi x2,x0,2
//     3: addi x3,x0,3
//     4: add  x4,x1,x4
//     5: sub  x5,x4,x1
//     6: add  x6,x5,x5
//     7: add  x7,x6,x6
//     8: add  x8,x7,x7
//     9: jalr x0,0(x1)     -> next PC = 0
//
//   Expected state after pass k (x1..x3 constant, x4..x8 evolve):
//     x1=1  x2=2  x3=3
//     x4=k
//     x5=k-1
//     x6=2*(k-1)
//     x7=4*(k-1)
//     x8=8*(k-1)
//
//   ASSUMPTION: the register file's uninitialized entries read as 0 at
//   simulation start (true for Verilator's default array init, which is
//   what your tb_regfile results were built on). If you compile with a
//   simulator/flag that randomizes uninitialized state instead, the
//   pass-1 expected values below will not hold.
//
//   Future work: this does not validate BRANCH or LOAD/STORE. A follow-up
//   hex containing a BEQ/BNE and a LW/SW is needed to close that gap.
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module tb_riscv64_top;

    import riscv_pkg::*;

    //==========================================================================
    // Clock / Reset
    //==========================================================================

    logic clk_i;
    logic rst_ni;

    initial begin
        clk_i = 1'b0;
        forever #5 clk_i = ~clk_i;
    end

    //==========================================================================
    // Statistics
    //==========================================================================

    integer total_tests;
    integer passed_tests;
    integer failed_tests;

    //==========================================================================
    // DUT
    //==========================================================================

    riscv64_top dut (

        .clk_i  (clk_i),
        .rst_ni (rst_ni)

    );

    //==========================================================================
    // Waveform Dump
    //==========================================================================

    initial begin
        $dumpfile("../waves/tb_riscv64_top.vcd");
        $dumpvars(0, tb_riscv64_top);
    end

    //==========================================================================
    // Per-Cycle Trace  (PC + fetched instruction)
    //==========================================================================

    always @(posedge clk_i) begin
        if (rst_ni)
            $strobe("[TRACE] time=%0t  pc=%h  instr=%h", $time, dut.pc, dut.instruction);
    end

    //==========================================================================
    // Self-Checking Task - single register
    //==========================================================================

    task automatic check_reg(

        input string  test_name,
        input int     reg_index,
        input xlen_t  expected

    );

        xlen_t actual;

    begin

        total_tests++;

        actual = dut.u_regfile.reg_file[reg_index];

        if (actual === expected) begin

            passed_tests++;
            $display("PASS : %-22s x%0d = %0d", test_name, reg_index, actual);

        end
        else begin

            failed_tests++;
            $display("FAIL : %-22s x%0d  expected=%0d  got=%0d",
                      test_name, reg_index, expected, actual);

        end

    end

    endtask

    //==========================================================================
    // Self-Checking Task - x0 architectural invariant
    //==========================================================================

    task automatic check_x0(input string test_name);

    begin

        total_tests++;

        if (dut.u_regfile.reg_file[0] === 64'd0) begin
            passed_tests++;
            $display("PASS : %-22s x0 = 0", test_name);
        end
        else begin
            failed_tests++;
            $display("FAIL : %-22s x0 != 0 (got %0d)",
                      test_name, dut.u_regfile.reg_file[0]);
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
        $display("        RISCV64 TOP-LEVEL VERIFICATION");
        $display("==================================================");
        $display("");

        //----------------------------------------------------------------------
        // Reset
        //----------------------------------------------------------------------

        rst_ni = 1'b0;
        repeat (2) @(negedge clk_i);
        rst_ni = 1'b1;

        $display("[INFO] Reset released. PC should now be at RESET_VECTOR.");

        //----------------------------------------------------------------------
        // Pass 1  (cycles 1-10 : instruction indices 0-9)
        //----------------------------------------------------------------------

        repeat (10) @(posedge clk_i);
        @(negedge clk_i);

        $display("");
        $display("---- Checking state after pass 1 ----");

        check_reg("x1 after pass 1", 1, 64'd1);
        check_reg("x2 after pass 1", 2, 64'd2);
        check_reg("x3 after pass 1", 3, 64'd3);
        check_reg("x4 after pass 1", 4, 64'd1);
        check_reg("x5 after pass 1", 5, 64'd0);
        check_reg("x6 after pass 1", 6, 64'd0);
        check_reg("x7 after pass 1", 7, 64'd0);
        check_reg("x8 after pass 1", 8, 64'd0);
        check_x0  ("x0 after pass 1");

        //----------------------------------------------------------------------
        // Pass 2  (cycles 11-20)
        //----------------------------------------------------------------------

        repeat (10) @(posedge clk_i);
        @(negedge clk_i);

        $display("");
        $display("---- Checking state after pass 2 ----");

        check_reg("x4 after pass 2", 4, 64'd2);
        check_reg("x5 after pass 2", 5, 64'd1);
        check_reg("x6 after pass 2", 6, 64'd2);
        check_reg("x7 after pass 2", 7, 64'd4);
        check_reg("x8 after pass 2", 8, 64'd8);
        check_x0  ("x0 after pass 2");

        //----------------------------------------------------------------------
        // Pass 3  (cycles 21-30)
        //----------------------------------------------------------------------

        repeat (10) @(posedge clk_i);
        @(negedge clk_i);

        $display("");
        $display("---- Checking state after pass 3 ----");

        check_reg("x4 after pass 3", 4, 64'd3);
        check_reg("x5 after pass 3", 5, 64'd2);
        check_reg("x6 after pass 3", 6, 64'd4);
        check_reg("x7 after pass 3", 7, 64'd8);
        check_reg("x8 after pass 3", 8, 64'd16);
        check_x0  ("x0 after pass 3");

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
            $display("*      ALL TOP-LEVEL TESTS PASSED             *");
            $display("*                                             *");
            $display("***********************************************");

        end
        else begin

            $display("***********************************************");
            $display("*                                             *");
            $display("*      TOP-LEVEL TESTS FAILED                 *");
            $display("*                                             *");
            $display("***********************************************");

        end

        $display("");
        $finish;

    end

endmodule : tb_riscv64_top
