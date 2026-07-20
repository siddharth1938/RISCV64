//==============================================================================
// Project      : RISCV64 Processor
// Module       : Branch Comparator Testbench
// File         : tb_branch_comparator.sv
//
// Description  :
//   Self-checking testbench for branch_comparator
//==============================================================================

`timescale 1ns/1ps

module tb_branch_comparator;

    import riscv_pkg::*;

    //==========================================================================
    // Testbench Signals
    //==========================================================================

    xlen_t   rs1_data_i;
    xlen_t   rs2_data_i;
    funct3_t funct3_i;

    logic    branch_taken_o;

    //==========================================================================
    // DUT
    //==========================================================================

    branch_comparator dut (

        .rs1_data_i      (rs1_data_i),
        .rs2_data_i      (rs2_data_i),
        .funct3_i        (funct3_i),
        .branch_taken_o  (branch_taken_o)

    );

    //==========================================================================
    // Test Task
    //==========================================================================

    task automatic run_test(

        input xlen_t   rs1,
        input xlen_t   rs2,
        input funct3_t funct3,
        input logic    expected,
        input string   test_name

    );

    begin

        rs1_data_i = rs1;
        rs2_data_i = rs2;
        funct3_i   = funct3;

        #1;

        if (branch_taken_o !== expected) begin

            $display("========================================");
            $display("TEST FAILED : %s", test_name);
            $display("----------------------------------------");
            $display("RS1      : %h", rs1);
            $display("RS2      : %h", rs2);
            $display("funct3   : %b", funct3);
            $display("Expected : %b", expected);
            $display("Received : %b", branch_taken_o);
            $display("========================================");

            $finish;

        end

        else begin

            $display("PASS : %s", test_name);

        end

    end

    endtask

    //==========================================================================
    // Test Sequence
    //==========================================================================

    initial begin

        $dumpfile("../waves/tb_branch_comparator.vcd");
        $dumpvars(0, tb_branch_comparator);

        //--------------------------------------------------
        // BEQ
        //--------------------------------------------------

        run_test(
            64'd10,
            64'd10,
            3'b000,
            1'b1,
            "BEQ Equal"
        );

        run_test(
            64'd10,
            64'd20,
            3'b000,
            1'b0,
            "BEQ Not Equal"
        );

        //--------------------------------------------------
        // BNE
        //--------------------------------------------------

        run_test(
            64'd10,
            64'd20,
            3'b001,
            1'b1,
            "BNE True"
        );

        run_test(
            64'd15,
            64'd15,
            3'b001,
            1'b0,
            "BNE False"
        );

        //--------------------------------------------------
        // BLT (Signed)
        //--------------------------------------------------

        run_test(
            -64'sd5,
             64'sd2,
             3'b100,
             1'b1,
             "BLT Signed"
        );

        run_test(
             64'sd8,
             64'sd3,
             3'b100,
             1'b0,
             "BLT False"
        );

        //--------------------------------------------------
        // BGE (Signed)
        //--------------------------------------------------

        run_test(
             64'sd7,
             64'sd7,
             3'b101,
             1'b1,
             "BGE Equal"
        );

        run_test(
            -64'sd10,
            -64'sd5,
             3'b101,
             1'b0,
             "BGE False"
        );

        //--------------------------------------------------
        // BLTU (Unsigned)
        //--------------------------------------------------

        run_test(
            64'd10,
            64'd20,
            3'b110,
            1'b1,
            "BLTU True"
        );

        run_test(
            64'hFFFF_FFFF_FFFF_FFFF,
            64'd1,
            3'b110,
            1'b0,
            "BLTU Max Unsigned"
        );

        //--------------------------------------------------
        // BGEU (Unsigned)
        //--------------------------------------------------

        run_test(
            64'd20,
            64'd10,
            3'b111,
            1'b1,
            "BGEU True"
        );

        run_test(
            64'd5,
            64'd10,
            3'b111,
            1'b0,
            "BGEU False"
        );

        //--------------------------------------------------
        // Invalid funct3
        //--------------------------------------------------

        run_test(
            64'd100,
            64'd100,
            3'b010,
            1'b0,
            "Invalid funct3"
        );

        //--------------------------------------------------
        // PASS
        //--------------------------------------------------

        $display("");
        $display("========================================");
        $display(" ALL BRANCH COMPARATOR TESTS PASSED");
        $display("========================================");
        $display("");

        #10;
        $finish;

    end

endmodule
