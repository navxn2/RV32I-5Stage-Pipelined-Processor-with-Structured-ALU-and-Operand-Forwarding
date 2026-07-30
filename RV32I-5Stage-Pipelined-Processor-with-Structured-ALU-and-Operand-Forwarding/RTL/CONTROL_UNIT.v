`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 21:54:12
// Design Name: 
// Module Name: CONTROL_UNIT
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


module CONTROL_UNIT(
    input [6:0] opcode,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg [1:0] ALUOp
);
    always @(*) begin
        case(opcode)
            7'h33: begin // R-type (ADD, SUB, etc.)
                ALUSrc = 0; MemtoReg = 0; RegWrite = 1; MemRead = 0; MemWrite = 0; ALUOp = 2'b10;
            end
            7'h13: begin // I-type (ADDI, etc.)
                ALUSrc = 1; MemtoReg = 0; RegWrite = 1; MemRead = 0; MemWrite = 0; ALUOp = 2'b00;
            end
            7'h03: begin // Load (LW)
                ALUSrc = 1; MemtoReg = 1; RegWrite = 1; MemRead = 1; MemWrite = 0; ALUOp = 2'b00;
            end
            7'h23: begin // Store (SW)
                ALUSrc = 1; MemtoReg = 0; RegWrite = 0; MemRead = 0; MemWrite = 1; ALUOp = 2'b00;
            end
            7'h63: begin // Branch (BEQ)
                ALUSrc = 0; MemtoReg = 0; RegWrite = 0; MemRead = 0; MemWrite = 0; ALUOp = 2'b01;
            end
            default: begin
                ALUSrc = 0; MemtoReg = 0; RegWrite = 0; MemRead = 0; MemWrite = 0; ALUOp = 2'b00;
            end
        endcase
    end
endmodule
