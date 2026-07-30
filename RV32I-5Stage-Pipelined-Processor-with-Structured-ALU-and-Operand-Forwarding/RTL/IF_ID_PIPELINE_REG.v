`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 21:41:34
// Design Name: 
// Module Name: IF_ID_PIPELINE_REG
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


module IF_ID_PIPELINE_REG(

    input clk,
    input rst,
    input [31:0] instr_in,
    input [31:0] pc_in,
    output reg [31:0] instr_out,
    output reg [31:0] pc_out
);

    always @(posedge clk) begin
        if (rst) begin
            instr_out <= 32'h00000013; // no operation
            pc_out    <= 32'b0;
        end
        else begin
           
            instr_out <= instr_in;
            pc_out <= pc_in;
        end
    end

endmodule

