//==============================================================================
// Project      : RISCV64 Processor
// Module       : Top-Level Testbench
// File         : tb_soc_top.sv
//
// Description  :
//   Version 1 verification environment for the RISCV64 Processor.
//
//   Part 1:
//     - Testbench Infrastructure
//     - Clock Generation
//     - Reset Generation
//     - Simulation Statistics
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module tb_soc_top;

    //==========================================================================
    // Local Parameters
    //==========================================================================

    localparam time CLK_PERIOD   = 10ns;    // 100 MHz
    localparam int  RESET_CYCLES = 5;

    //==========================================================================
    // Clock & Reset Signals
    //==========================================================================

    logic clk_i;
    logic rst_ni;

    //==========================================================================
    // Simulation Statistics
    //==========================================================================

    integer cycle_count;

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
        $display("============================================================");
        $display("           RISCV64 Processor Simulation Started");
        $display("============================================================");
        $display("Clock Period   : %0t", CLK_PERIOD);
        $display("Reset Released : %0t", $time);
        $display("============================================================");
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
    // End of Part 1
    //==========================================================================
    //==========================================================================
    // Device Under Test (DUT)
    //==========================================================================
    //
    // Top-Level SoC
    //
    //==========================================================================

    soc_top dut (

        .clk_i  (clk_i),
        .rst_ni (rst_ni)

    );

    //==========================================================================
    // Waveform Dump
    //==========================================================================

    initial begin

        $dumpfile("../waves/tb_soc_top.vcd");
        $dumpvars(0, tb_soc_top);

        $display("");
        $display("============================================================");
        $display("                 Waveform Generation Enabled");
        $display("============================================================");
        $display("Waveform File : ../waves/tb_soc_top.vcd");
        $display("============================================================");
        $display("");

    end

    //==========================================================================
    // DUT Information
    //==========================================================================

    initial begin

        $display("");
        $display("============================================================");
        $display("                  Device Under Test");
        $display("============================================================");
        $display("Top Module     : soc_top");
        $display("Clock Period   : %0t", CLK_PERIOD);
        $display("Reset Cycles   : %0d", RESET_CYCLES);
        $display("============================================================");
        $display("");

    end

    //==========================================================================
    // Execution Monitor
    //==========================================================================
    //
    // Displays the processor state every clock cycle.
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
            $display("PC          : 0x%016h", dut.u_fetch.pc_o);
            $display("Instruction : 0x%08h", dut.u_fetch.instr_o);

            //--------------------------------------------------------------
            // Decode Stage
            //--------------------------------------------------------------

            $display("");
            $display("DECODE");
            $display("------");

            $display("Opcode      : 0x%02h", dut.u_core.opcode);
            $display("RS1         : x%0d",  dut.u_core.rs1_addr);
            $display("RS2         : x%0d",  dut.u_core.rs2_addr);
            $display("RD          : x%0d",  dut.u_core.rd_addr);

            $display("Funct3      : 0x%01h", dut.u_core.funct3);
            $display("Funct7      : 0x%02h", dut.u_core.funct7);

            $display("Immediate   : 0x%016h", dut.u_core.immediate);

            //--------------------------------------------------------------
            // Register File
            //--------------------------------------------------------------

            $display("");
            $display("REGISTER FILE");
            $display("-------------");

            $display("RS1 Data    : 0x%016h", dut.u_core.rs1_data);
            $display("RS2 Data    : 0x%016h", dut.u_core.rs2_data);

            //--------------------------------------------------------------
            // Execute Stage
            //--------------------------------------------------------------

            $display("");
            $display("EXECUTE");
            $display("-------");

            $display("ALU Result  : 0x%016h", dut.u_core.alu_result);
            $display("Branch Taken: %0b",     dut.u_core.branch_taken);

            $display("Branch Addr : 0x%016h", dut.u_core.branch_target);
            $display("JALR Addr   : 0x%016h", dut.u_core.jalr_target);

            //--------------------------------------------------------------
            // Memory Stage
            //--------------------------------------------------------------

            $display("");
            $display("MEMORY");
            $display("------");

            $display("Address     : 0x%016h", dut.mem_addr);
            $display("Write Data  : 0x%016h", dut.mem_write_data);
            $display("Read Data   : 0x%016h", dut.mem_read_data);

            $display("Mem Read    : %0b", dut.mem_read);
            $display("Mem Write   : %0b", dut.mem_write);

            //--------------------------------------------------------------
            // Write Back
            //--------------------------------------------------------------

            $display("");
            $display("WRITE BACK");
            $display("----------");

            $display("WB Select   : %0d", dut.u_core.wb_sel);
            $display("WB Data     : 0x%016h", dut.u_core.write_back_data);

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
    // gets stuck in an infinite loop.
    //
    //==========================================================================

    localparam int MAX_CYCLES = 1000;

    always_ff @(posedge clk_i) begin

        if (rst_ni && (cycle_count >= MAX_CYCLES)) begin

            $display("");
            $display("============================================================");
            $display("                    WATCHDOG TIMEOUT");
            $display("============================================================");
            $display("Maximum Cycle Count : %0d", MAX_CYCLES);
            $display("Simulation Time     : %0t", $time);
            $display("Clock Period        : %0t", CLK_PERIOD);
            $display("Clock Cycles        : %0d", cycle_count);
            $display("");
            $display("Processor appears to be stuck.");
            $display("Simulation terminated by Watchdog Timer.");
            $display("============================================================");
            $display("");

            $finish;

        end

    end

    //==========================================================================
    // End of Part 3
    //==========================================================================
    //==========================================================================
    // Simulation Report
    //==========================================================================
    //
    // Prints a summary when the simulation terminates.
    //
    //==========================================================================

    final begin

        $display("");
        $display("");
        $display("============================================================");
        $display("               RISCV64 PROCESSOR SIMULATION REPORT");
        $display("============================================================");
        $display("");

        $display("Simulation Statistics");
        $display("---------------------");
        $display("Clock Period      : %0t", CLK_PERIOD);
        $display("Simulation Time   : %0t", $time);
        $display("Clock Cycles      : %0d", cycle_count);

        $display("");
        $display("Generated Files");
        $display("----------------");
        $display("Waveform File    : ../waves/tb_soc_top.vcd");

        $display("");

        if (cycle_count < MAX_CYCLES)
            $display("Simulation Status : COMPLETED");
        else
            $display("Simulation Status : TIMEOUT");

        $display("");
        $display("============================================================");
        $display("                End of Simulation");
        $display("============================================================");
        $display("");

    end

    //==========================================================================
    // Future Verification Environment
    //==========================================================================
    //
    // Planned Enhancements
    //
    //   - Transaction Class
    //   - Generator
    //   - Driver
    //   - Monitor
    //   - Scoreboard
    //   - Functional Coverage
    //   - Assertions (SystemVerilog Assertions)
    //   - Constrained Random Verification
    //   - Functional Coverage Collection
    //   - Reference Model
    //   - Regression Testing
    //   - Memory Model
    //   - Instruction Stream Generator
    //
    //==========================================================================

endmodule : tb_soc_top
