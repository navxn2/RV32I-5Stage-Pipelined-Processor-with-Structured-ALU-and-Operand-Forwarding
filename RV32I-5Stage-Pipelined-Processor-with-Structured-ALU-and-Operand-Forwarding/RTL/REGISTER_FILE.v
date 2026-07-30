`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 21:48:37
// Design Name: 
// Module Name: REGISTER_FILE
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


module REGISTER_FILE(
    input clk,
    input rst,
    input reg_write,           
    input [4:0] rs1_addr,      
    input [4:0] rs2_addr,      
    input [4:0] rd_addr,       
    input [31:0] write_data,   
    output [31:0] rs1_data,    
    output [31:0] rs2_data     
);

    reg [31:0] registers [31:0];
    integer i;

    
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
        end 
        else if (reg_write && (rd_addr != 5'b0)) begin
            
            registers[rd_addr] <= write_data;
        end
    end

   
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : registers[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : registers[rs2_addr];

endmodule
