//==============================================================================
// Project      : RISCV64 Processor
// Module       : Top-Level Testbench
// File         : tb_riscv64_top.sv
//
// Description  :
//   Version 1 verification environment for the RISCV64I Processor.
//
//   Features:
//     - Clock Generation
//     - Reset Generation
//     - DUT Instantiation
//     - Waveform Dump
//
//   Future Versions:
//     - Execution Monitor
//     - Register Checker
//     - Memory Checker
//     - Scoreboard
//     - Functional Coverage
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

    //==========================================================================
    // Local Parameters
    //==========================================================================

    localparam time CLK_PERIOD = 10ns;      // 100 MHz
    localparam int  RESET_CYCLES = 5;

    //==========================================================================
    // Clock & Reset
    //==========================================================================

    logic clk_i;
    logic rst_ni;

    //==========================================================================
    // Simulation Statistics
    //==========================================================================

    integer cycle_count;

    //==========================================================================
    // DUT
    //==========================================================================

    riscv64_top dut (

        .clk_i  (clk_i),
        .rst_ni (rst_ni)

    );

    //==========================================================================
    // Clock Generation
    //==========================================================================

    initial begin

        clk_i = 1'b0;

        forever #(CLK_PERIOD/2)
            clk_i = ~clk_i;

    end

    //==========================================================================
    // Reset Generation
    //==========================================================================

    initial begin

        rst_ni = 1'b0;

        repeat (RESET_CYCLES)
            @(posedge clk_i);

        rst_ni = 1'b1;

        $display("");
        $display("==========================================================");
        $display("        RISCV64 Processor Simulation Started");
        $display("==========================================================");
        $display("Reset Released : %0t", $time);
        $display("");

    end

    //==========================================================================
    // Cycle Counter
    //==========================================================================

    initial
        cycle_count = 0;

    always_ff @(posedge clk_i) begin

        if (!rst_ni)
            cycle_count <= 0;
        else
            cycle_count <= cycle_count + 1;

    end

    //==========================================================================
    // Waveform Dump
    //==========================================================================

    initial begin

        $dumpfile("../waves/tb_riscv64_top.vcd");
        $dumpvars(0, tb_riscv64_top);

    end;
    //==========================================================================
    // Execution Monitor
    //==========================================================================
    //
    // Displays the processor state every clock cycle after reset.
    // This monitor is intended for debugging while developing the
    // processor. It is NOT a checker.
    //
    //==========================================================================

    always_ff @(posedge clk_i) begin

        if (rst_ni) begin

            $display("");
            $display("====================================================================");
            $display("Cycle : %0d    Time : %0t", cycle_count, $time);
            $display("====================================================================");

            //--------------------------------------------------------------
            // Fetch Stage
            //--------------------------------------------------------------

            $display("FETCH");
            $display("-----");
            $display("PC          : 0x%016h", dut.pc);
            $display("Instruction : 0x%08h", dut.instruction);

            //--------------------------------------------------------------
            // Decode Stage
            //--------------------------------------------------------------

            $display("");
            $display("DECODE");
            $display("------");

            $display("Opcode      : 0x%02h", dut.opcode);
            $display("RS1         : x%0d", dut.rs1_addr);
            $display("RS2         : x%0d", dut.rs2_addr);
            $display("RD          : x%0d", dut.rd_addr);

            $display("Funct3      : 0x%0h", dut.funct3);
            $display("Funct7      : 0x%02h", dut.funct7);

            $display("Immediate   : 0x%016h", dut.immediate);

            //--------------------------------------------------------------
            // Register File
            //--------------------------------------------------------------

            $display("");
            $display("REGISTER FILE");
            $display("-------------");

            $display("RS1 Data    : 0x%016h", dut.rs1_data);
            $display("RS2 Data    : 0x%016h", dut.rs2_data);

            //--------------------------------------------------------------
            // Execute Stage
            //--------------------------------------------------------------

            $display("");
            $display("EXECUTE");
            $display("-------");

            $display("ALU Result  : 0x%016h", dut.alu_result);
            $display("Branch Taken: %0b", dut.branch_taken);

            //--------------------------------------------------------------
            // Memory Stage
            //--------------------------------------------------------------

            $display("");
            $display("MEMORY");
            $display("------");

            $display("Read Data   : 0x%016h", dut.mem_data);

            //--------------------------------------------------------------
            // Write Back
            //--------------------------------------------------------------

            $display("");
            $display("WRITE BACK");
            $display("----------");

            $display("WB Select   : %0d", dut.wb_sel);
            $display("WB Data     : 0x%016h", dut.write_back_data);

            $display("====================================================================");

        end

    end


    //==========================================================================
    // End of Part 2
    //==========================================================================
        //==========================================================================
    // Watchdog Timer
    //==========================================================================
    //
    // Prevents the simulation from running forever if the processor
    // gets stuck.
    //
    //==========================================================================

    localparam int MAX_CYCLES = 1000;

    always @(posedge clk_i) begin

        if (rst_ni && (cycle_count >= MAX_CYCLES)) begin

            $display("");
            $display("============================================================");
            $display("                 WATCHDOG TIMEOUT");
            $display("============================================================");
            $display("Maximum Cycle Count Reached : %0d", MAX_CYCLES);
            $display("Simulation Time             : %0t", $time);
            $display("Processor appears to be stuck.");
            $display("============================================================");
            $finish;

        end

    end


    //==========================================================================
    // Simulation Report
    //==========================================================================
    //
    // Prints a summary when the simulation ends.
    //
    //==========================================================================

    final begin

        $display("");
        $display("");
        $display("============================================================");
        $display("              RISCV64I SIMULATION REPORT");
        $display("============================================================");
        $display("");

        $display("Clock Period     : %0t", CLK_PERIOD);
        $display("Simulation Time  : %0t", $time);
        $display("Clock Cycles     : %0d", cycle_count);

        $display("");
        $display("Waveform File    : waveform.vcd");
        $display("");

        if (cycle_count < MAX_CYCLES)
            $display("Simulation Status : COMPLETED");
        else
            $display("Simulation Status : TIMEOUT");

        $display("");
        $display("============================================================");
        $display("          End of RISCV64I Simulation");
        $display("============================================================");
        $display("");

    end

endmodule : tb_riscv64_top
