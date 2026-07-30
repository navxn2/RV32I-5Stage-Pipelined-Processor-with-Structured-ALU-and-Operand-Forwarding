`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 20:32:00
// Design Name: 
// Module Name: EX_MEM_PIPELINE_REG
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
// This  is the pipeline register between Execution stage and Memory stage 

module EX_MEM_PIPELINE_REG(
    input clk, rst,
    input [31:0] alu_result, reg_data_b,
    input [4:0] rd_ex,
    input reg_write, mem_to_reg, mem_write,
    output reg [31:0] alu_result_out, reg_data_b_out,
    output reg [4:0] rd_out,
    output reg reg_write_out, mem_to_reg_out, mem_write_out
);

always @(posedge clk) begin 
    if(rst) begin
        alu_result_out <= 0;
        reg_data_b_out <= 0;
        rd_out         <= 0;
        reg_write_out  <= 0;
        mem_to_reg_out <= 0;
        mem_write_out  <= 0;
    end
    else begin
        alu_result_out <= alu_result;
        reg_data_b_out <= reg_data_b;
        rd_out         <= rd_ex;
        reg_write_out  <= reg_write;
        mem_to_reg_out <= mem_to_reg;
        mem_write_out  <= mem_write;
    end
end

endmodule
