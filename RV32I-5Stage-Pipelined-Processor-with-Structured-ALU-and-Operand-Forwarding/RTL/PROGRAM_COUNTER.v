`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 21:23:01
// Design Name: 
// Module Name: PROGRAM_COUNTER
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


module PROGRAM_COUNTER(
    input clk, rst,
    input [31:0] pc_in,
    output reg [31:0] pc_out
);
    always @(posedge clk) begin
        if (rst) 
            pc_out <= 32'b0;
        else 
            pc_out <= pc_in; 
    end
endmodule