`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 20:58:48
// Design Name: 
// Module Name: MEM_WB_PIPELINE_REG
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
// This is the MEMORY- WRITEBACK PIPELINE REGISTER 

module MEM_WB_PIPELINE_REG(
    input clk, rst,
    input reg_write, mem_to_reg,
    input [31:0] read_data, alu_result,
    input [4:0] rd_mem,
    
    output reg [31:0] read_data_out, alu_result_out,
    output reg [4:0] rd_out,
    output reg reg_write_out, mem_to_reg_out 
);

always @(posedge clk) begin
    if (rst) begin 
        read_data_out   <= 32'b0;
        alu_result_out  <= 32'b0;
        rd_out          <= 5'b0;
        reg_write_out   <= 1'b0;
        mem_to_reg_out  <= 1'b0;
    end
    else begin
        read_data_out   <= read_data;   
        alu_result_out  <= alu_result;
        rd_out          <= rd_mem;      
        reg_write_out   <= reg_write;
        mem_to_reg_out  <= mem_to_reg;
    end
end

endmodule
