
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 21:58:13
// Design Name: 
// Module Name: ID_EX_PIPELINE_REG
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: ID_EX_PIPELINE_REG
// Fix: Added rs1_addr_in/out and rs2_addr_out so forwarding_unit
//      receives register ADDRESSES instead of data values.
//////////////////////////////////////////////////////////////////////////////////

module ID_EX_PIPELINE_REG(
    input clk, rst,
    input [31:0] rs1_in, rs2_in, imm_in,
    input [4:0] rd_in,
    input [4:0] rs1_addr_in, rs2_addr_in,      // NEW: register addresses
    input [2:0] funct3_in,
    input [6:0] funct7_in,
    input ALUSrc_in, MemtoReg_in, RegWrite_in, 
    input MemRead_in, MemWrite_in,
    input [1:0] ALUOp_in,
    output reg [31:0] rs1_out, rs2_out, imm_out,
    output reg [4:0] rd_out,
    output reg [4:0] rs1_addr_out, rs2_addr_out, // NEW: register addresses
    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out,
    output reg ALUSrc_out, MemtoReg_out, RegWrite_out, 
    output reg MemRead_out, MemWrite_out,
    output reg [1:0] ALUOp_out
);

    always @(posedge clk) begin
        if (rst) begin
            rs1_out      <= 32'b0; 
            rs2_out      <= 32'b0;
            imm_out      <= 32'b0;
            rd_out       <= 5'b0;
            rs1_addr_out <= 5'b0;               // NEW
            rs2_addr_out <= 5'b0;               // NEW
            funct3_out   <= 3'b0; 
            funct7_out   <= 7'b0;
            ALUSrc_out   <= 0; 
            MemtoReg_out <= 0; 
            RegWrite_out <= 0;
            MemRead_out  <= 0;
            MemWrite_out <= 0;
            ALUOp_out    <= 2'b0;
        end else begin
            rs1_out      <= rs1_in; 
            rs2_out      <= rs2_in; 
            imm_out      <= imm_in;
            rd_out       <= rd_in;
            rs1_addr_out <= rs1_addr_in;        // NEW
            rs2_addr_out <= rs2_addr_in;        // NEW
            funct3_out   <= funct3_in; 
            funct7_out   <= funct7_in;
            ALUSrc_out   <= ALUSrc_in; 
            MemtoReg_out <= MemtoReg_in; 
            RegWrite_out <= RegWrite_in;
            MemRead_out  <= MemRead_in;
            MemWrite_out <= MemWrite_in;
            ALUOp_out    <= ALUOp_in;
        end
    end

endmodule