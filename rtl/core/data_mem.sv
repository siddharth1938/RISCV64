//==============================================================================
// Project      : RISCV64 Processor
// Module       : Data Memory
// File         : data_mem.sv
//
// Description  :
//   64-bit Data Memory
//
// Features:
//   - Configurable memory depth
//   - Synchronous write
//   - Combinational read
//   - Memory initialized to zero
//==============================================================================

`timescale 1ns/1ps

module data_mem import riscv_pkg::*; (

    input  logic  clk_i,

    input  xlen_t addr_i,
    input  xlen_t write_data_i,

    input  logic  mem_read_i,
    input  logic  mem_write_i,

    output xlen_t read_data_o

);

    //==========================================================================
    // Data Memory
    //==========================================================================

    xlen_t mem [0:DMEM_DEPTH-1];

    //==========================================================================
    // Memory Initialization
    //==========================================================================

    integer i;

    initial begin

        for (i = 0; i < DMEM_DEPTH; i = i + 1)
            mem[i] = '0;

    end

    //==========================================================================
    // Memory Write
    //==========================================================================

    always_ff @(posedge clk_i) begin

        if (mem_write_i)
            mem[addr_i[DMEM_ADDR_BITS+2:3]] <= write_data_i;

    end

    //==========================================================================
    // Memory Read
    //==========================================================================

    always_comb begin

        read_data_o = '0;

        if (mem_read_i)
            read_data_o = mem[addr_i[DMEM_ADDR_BITS+2:3]];

    end

endmodule
