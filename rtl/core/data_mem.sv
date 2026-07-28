//==============================================================================
// Project      : RISCV64 Processor
// Module       : Top-Level Testbench
// File         : tb_riscv64_top.sv
//
// Description  :
//   Self-checking top-level verification environment for the RISCV64
//   single-cycle processor.
//
//   Program Under Test:
//      matrix_mul_3x3.hex
//
//   Features:
//      - Reset verification
//      - Instruction fetch verification
//      - Program Counter verification
//      - Register verification
//      - Data Memory verification
//      - ALU operation verification
//      - JAL infinite-loop verification
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module tb_riscv64_top;

    import riscv_pkg::*;

    //==========================================================================
    // Parameters
    //==========================================================================

    localparam xlen_t TB_RESET_VECTOR = 64'h0000_0000_8000_0000;

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
    // Test Statistics
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
    // Execution Trace
    //==========================================================================

    always @(posedge clk_i) begin

        if (rst_ni) begin

            $strobe(
                "[TRACE] T=%0t | PC=%h | INSTR=%h",
                $time,
                dut.pc,
                dut.instruction
            );

        end

    end

    //==========================================================================
    // Helper Task : Wait One Instruction
    //==========================================================================

    task automatic wait_instruction;

    begin

        @(posedge clk_i);
        @(negedge clk_i);

    end

    endtask

    //==========================================================================
    // Helper Task : Check Program Counter
    //==========================================================================

    task automatic check_pc(

        input string test_name,
        input xlen_t expected

    );

        xlen_t actual;

    begin

        total_tests++;

        actual = dut.pc;

        if (actual === expected) begin

            passed_tests++;

            $display(
                "PASS : %-35s PC = %h",
                test_name,
                actual
            );

        end
        else begin

            failed_tests++;

            $display(
                "FAIL : %-35s Expected=%h Got=%h",
                test_name,
                expected,
                actual
            );

        end

    end

    endtask

    //==========================================================================
    // Helper Task : Check Instruction
    //==========================================================================

    task automatic check_instruction(

        input string test_name,
        input instr_t expected

    );

        instr_t actual;

    begin

        total_tests++;

        actual = dut.instruction;

        if (actual === expected) begin

            passed_tests++;

            $display(
                "PASS : %-35s INSTR = %h",
                test_name,
                actual
            );

        end
        else begin

            failed_tests++;

            $display(
                "FAIL : %-35s Expected=%h Got=%h",
                test_name,
                expected,
                actual
            );

        end

    end

    endtask

    //==========================================================================
    // Helper Task : Check Register
    //==========================================================================

    task automatic check_reg(

        input string test_name,
        input int unsigned reg_index,
        input xlen_t expected

    );

        xlen_t actual;

    begin

        total_tests++;

        actual = dut.u_regfile.reg_file[reg_index];

        if (actual === expected) begin

            passed_tests++;

            $display(
                "PASS : %-35s x%0d = %0d",
                test_name,
                reg_index,
                actual
            );

        end
        else begin

            failed_tests++;

            $display(
                "FAIL : %-35s x%0d Expected=%0d Got=%0d",
                test_name,
                reg_index,
                expected,
                actual
            );

        end

    end

    endtask

    //==========================================================================
    // Helper Task : Check Memory Address
    //==========================================================================

    task automatic check_mem_addr(

        input string test_name,
        input xlen_t address,
        input xlen_t expected

    );

        xlen_t actual;

    begin

        total_tests++;

        actual = dut.u_data_mem.mem[address[DMEM_ADDR_BITS+2:3]];

        if (actual === expected) begin

            passed_tests++;

            $display(
                "PASS : %-35s MEM[%h] = %0d",
                test_name,
                address,
                actual
            );

        end
        else begin

            failed_tests++;

            $display(
                "FAIL : %-35s MEM[%h] Expected=%0d Got=%0d",
                test_name,
                address,
                expected,
                actual
            );

        end

    end

    endtask

    //==========================================================================
    // Helper Task : Verify x0 Register
    //==========================================================================

    task automatic check_x0;

    begin

        total_tests++;

        if (dut.u_regfile.reg_file[0] == 64'd0) begin

            passed_tests++;

            $display("PASS : x0 remains hardwired to zero");

        end
        else begin

            failed_tests++;

            $display(
                "FAIL : x0 modified! value=%0d",
                dut.u_regfile.reg_file[0]
            );

        end

    end

    endtask

    //==========================================================================
    // Helper Task : Print Test Banner
    //==========================================================================

    task automatic print_banner;

    begin

        $display("");
        $display("==================================================");
        $display("        RISCV64 TOP-LEVEL VERIFICATION");
        $display("==================================================");
        $display("");

    end

    endtask

    //==========================================================================
    // Helper Task : Print Summary
    //==========================================================================

    task automatic print_summary;

    begin

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

    end

    endtask

    //==========================================================================
    // Main Test Sequence
    // (Continues in Part 2)
    //==========================================================================
    