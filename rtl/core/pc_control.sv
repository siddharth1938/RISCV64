//==============================================================================
// Project      : RISCV64 Processor
// Module       : PC Control Unit
// File         : pc_control.sv
//
// Description  :
//   Determines the next Program Counter source.
//
//   Responsibilities:
//     - Select sequential execution (PC + 4)
//     - Select branch target
//     - Select JAL target
//     - Select JALR target
//     - Generate Program Counter load enable
//
//------------------------------------------------------------------------------
// Author       : Siddhartha Chinta
// Organization : Personal Learning Project
//
// Target ISA   : RV64I
// Language     : SystemVerilog
//==============================================================================

`timescale 1ns/1ps

module pc_control (

    //--------------------------------------------------------------------------
    // Control Inputs
    //--------------------------------------------------------------------------

    input  logic branch_i,
    input  logic jump_i,
    input  logic jalr_i,

    input  logic branch_taken_i,

    //--------------------------------------------------------------------------
    // Outputs
    //--------------------------------------------------------------------------

    output logic       load_pc_o,
    output logic [1:0] pc_sel_o

);

    //==========================================================================
    // PC Control Logic
    //==========================================================================

    always_comb begin

        //--------------------------------------------------------------
        // Default : Sequential Execution
        //--------------------------------------------------------------

        load_pc_o = 1'b1;
        pc_sel_o  = 2'b00;

        //--------------------------------------------------------------
        // Branch
        //--------------------------------------------------------------

        if (branch_i && branch_taken_i)

            pc_sel_o = 2'b01;

        //--------------------------------------------------------------
        // JAL
        //--------------------------------------------------------------

        else if (jump_i)

            pc_sel_o = 2'b10;

        //--------------------------------------------------------------
        // JALR
        //--------------------------------------------------------------

        else if (jalr_i)

            pc_sel_o = 2'b11;

    end

endmodule : pc_control
