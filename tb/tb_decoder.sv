//==============================================================================
// Project      : RISCV64 Processor
// Module       : Testbench - Decoder
// File         : tb_decoder.sv
//
// Description  :
//   Testbench for verifying the Instruction Decoder.
//
//==============================================================================

`timescale 1ns/1ps

module tb_decoder;

    import riscv_pkg::*;

    //--------------------------------------------------------------------------
    // DUT Signals
    //--------------------------------------------------------------------------

    instr_t    instr_i;

    opcode_t   opcode_o;
    reg_addr_t rd_o;
    reg_addr_t rs1_o;
    reg_addr_t rs2_o;
    funct3_t   funct3_o;
    funct7_t   funct7_o;

    //--------------------------------------------------------------------------
    // DUT
    //--------------------------------------------------------------------------

    decoder u_decoder (

        .instr_i  (instr_i),

        .opcode_o (opcode_o),
        .rd_o     (rd_o),
        .rs1_o    (rs1_o),
        .rs2_o    (rs2_o),
        .funct3_o (funct3_o),
        .funct7_o (funct7_o)

    );

    //--------------------------------------------------------------------------
    // Waveform
    //--------------------------------------------------------------------------

    initial begin
        $dumpfile("../waves/tb_decoder.vcd");
        $dumpvars(0, tb_decoder);
    end

    //--------------------------------------------------------------------------
    // Test
    //--------------------------------------------------------------------------

    initial begin

        $display("");
        $display("========================================================");
        $display("             DECODER TESTBENCH");
        $display("========================================================");

        //--------------------------------------------------------------
        // ADD x5,x6,x7
        //--------------------------------------------------------------

        instr_i = 32'h007302B3;

        #10;

        $display("");
        $display("Instruction = %h", instr_i);
        $display("Opcode  = %b", opcode_o);
        $display("RD      = %0d", rd_o);
        $display("RS1     = %0d", rs1_o);
        $display("RS2     = %0d", rs2_o);
        $display("FUNCT3  = %b", funct3_o);
        $display("FUNCT7  = %b", funct7_o);

        //--------------------------------------------------------------
        // Finish
        //--------------------------------------------------------------

        $display("");
        $display("========================================================");
        $display("Decoder Test Completed Successfully");
        $display("========================================================");

        $finish;

    end

endmodule
