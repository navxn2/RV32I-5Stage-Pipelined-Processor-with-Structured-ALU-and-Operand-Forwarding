`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 21:11:18
// Design Name: 
// Module Name: WRITEBACK_STAGE
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


    module WRITEBACK_STAGE(
    input [31:0] alu_result_wb,read_data_wb,
    input mem_to_reg_wb,
    output [31:0] write_back_data );
    
    assign write_back_data  = (mem_to_reg_wb == 1'b1 ) ? read_data_wb :alu_result_wb;
    
    endmodule
