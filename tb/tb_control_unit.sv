//==============================================================================
// Project      : RISCV64 Processor
// Module       : Testbench - Control Unit
// File         : tb_control_unit.sv
//==============================================================================

`timescale 1ns/1ps

module tb_control_unit;

    import riscv_pkg::*;
    import riscv_opcode_pkg::*;
    import riscv_funct_pkg::*;
    import riscv_alu_pkg::*;

    //--------------------------------------------------------------------------
    // DUT Signals
    //--------------------------------------------------------------------------

    opcode_t opcode_i;
    funct3_t funct3_i;
    funct7_t funct7_i;

    alu_op_t alu_op_o;
    logic    reg_write_o;
    logic    alu_src_o;

    //--------------------------------------------------------------------------
    // DUT
    //--------------------------------------------------------------------------

    control_unit dut (

        .opcode_i(opcode_i),
        .funct3_i(funct3_i),
        .funct7_i(funct7_i),

        .alu_op_o(alu_op_o),
        .reg_write_o(reg_write_o),
        .alu_src_o(alu_src_o)

    );

    //--------------------------------------------------------------------------
    // Waveform
    //--------------------------------------------------------------------------

    initial begin
        $dumpfile("../waves/tb_control_unit.vcd");
        $dumpvars(0, tb_control_unit);
    end

    //--------------------------------------------------------------------------
    // Test Sequence
    //--------------------------------------------------------------------------

    initial begin

        $display("");
        $display("======================================================");
        $display("           CONTROL UNIT TEST");
        $display("======================================================");

        //----------------------------------------------------------
        // ADD
        //----------------------------------------------------------

        opcode_i = OPCODE_OP;
        funct3_i = F3_ADD_SUB;
        funct7_i = F7_ADD;

        #10;

        if (alu_op_o != ALU_ADD)
            $fatal(1,"ADD Decode Failed");

        if (!reg_write_o)
            $fatal(1,"ADD RegWrite Failed");

        if (alu_src_o)
            $fatal(1,"ADD ALUSrc Failed");

        //----------------------------------------------------------
        // SUB
        //----------------------------------------------------------

        funct7_i = F7_SUB;

        #10;

        if (alu_op_o != ALU_SUB)
            $fatal(1,"SUB Decode Failed");

        //----------------------------------------------------------
        // AND
        //----------------------------------------------------------

        funct3_i = F3_AND;
        funct7_i = F7_ADD;

        #10;

        if (alu_op_o != ALU_AND)
            $fatal(1,"AND Decode Failed");

        //----------------------------------------------------------
        // OR
        //----------------------------------------------------------

        funct3_i = F3_OR;

        #10;

        if (alu_op_o != ALU_OR)
            $fatal(1,"OR Decode Failed");

        //----------------------------------------------------------
        // XOR
        //----------------------------------------------------------

        funct3_i = F3_XOR;

        #10;

        if (alu_op_o != ALU_XOR)
            $fatal(1,"XOR Decode Failed");

        //----------------------------------------------------------
        // ADDI
        //----------------------------------------------------------

        opcode_i = OPCODE_OP_IMM;
        funct3_i = F3_ADD_SUB;

        #10;

        if (alu_op_o != ALU_ADD)
            $fatal(1,"ADDI Decode Failed");

        if (!alu_src_o)
            $fatal(1,"ADDI ALUSrc Failed");

        //----------------------------------------------------------
        // ANDI
        //----------------------------------------------------------

        funct3_i = F3_AND;

        #10;

        if (alu_op_o != ALU_AND)
            $fatal(1,"ANDI Decode Failed");

        //----------------------------------------------------------
        // ORI
        //----------------------------------------------------------

        funct3_i = F3_OR;

        #10;

        if (alu_op_o != ALU_OR)
            $fatal(1,"ORI Decode Failed");

        //----------------------------------------------------------
        // PASS
        //----------------------------------------------------------

        $display("");
        $display("======================================================");
        $display("      CONTROL UNIT TEST PASSED SUCCESSFULLY");
        $display("======================================================");

        $finish;

    end

endmodule : tb_control_unit
