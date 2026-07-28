//==============================================================================
// Project      : RISCV64 Processor
// Module       : Top-Level Testbench
// File         : tb_riscv64_top.sv
//
// Description  :
//   End-to-end self-checking verification environment for the RISCV64
//   single-cycle processor.
//
//   Program Under Test:
//     programs/matrix_mul_3x3.hex
//
//   Verification Scope:
//     - Reset sequence
//     - Instruction fetch
//     - Program Counter progression
//     - Register file updates
//     - Data memory operations
//     - Arithmetic/Logic operations
//     - JAL infinite-loop verification
//
//   Notes:
//     - This is a directed, self-checking testbench.
//     - Internal DUT signals are accessed hierarchically.
//     - Functional coverage is achieved through architectural state checks.
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
    end;

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
    // Helper Task : Advance One Instruction
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
                "PASS : %-30s PC = %h",
                test_name,
                actual
            );

        end
        else begin

            failed_tests++;

            $display(
                "FAIL : %-30s Expected=%h Got=%h",
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
                "PASS : %-30s INSTR = %h",
                test_name,
                actual
            );

        end
        else begin

            failed_tests++;

            $display(
                "FAIL : %-30s Expected=%h Got=%h",
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
        input int    reg_index,
        input xlen_t expected

    );

        xlen_t actual;

    begin

        total_tests++;

        actual = dut.u_regfile.reg_file[reg_index];

        if (actual === expected) begin

            passed_tests++;

            $display(
                "PASS : %-30s x%0d = %0d",
                test_name,
                reg_index,
                actual
            );

        end
        else begin

            failed_tests++;

            $display(
                "FAIL : %-30s x%0d Expected=%0d Got=%0d",
                test_name,
                reg_index,
                expected,
                actual
            );

        end

    end

    endtask

    //==========================================================================
    // Helper Task : Check Data Memory
    //==========================================================================

    task automatic check_mem(

        input string test_name,
        input int    mem_index,
        input xlen_t expected

    );

        xlen_t actual;

    begin

        total_tests++;

        actual = dut.u_data_mem.mem[mem_index];

        if (actual === expected) begin

            passed_tests++;

            $display(
                "PASS : %-30s MEM[%0d] = %0d",
                test_name,
                mem_index,
                actual
            );

        end
        else begin

            failed_tests++;

            $display(
                "FAIL : %-30s MEM[%0d] Expected=%0d Got=%0d",
                test_name,
                mem_index,
                expected,
                actual
            );

        end

    end

    endtask

    //==========================================================================
    // Helper Task : Check x0
    //==========================================================================

    task automatic check_x0;

    begin

        total_tests++;

        if (dut.u_regfile.reg_file[0] === 64'd0) begin

            passed_tests++;

            $display("PASS : x0 Architectural Register");

        end
        else begin

            failed_tests++;

            $display(
                "FAIL : x0 Modified! Value=%0d",
                dut.u_regfile.reg_file[0]
            );

        end

    end

    endtask

    //==========================================================================
    // Helper Task : Print Summary
    //==========================================================================

    task automatic print_summary;

    begin

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

    end

    endtask
