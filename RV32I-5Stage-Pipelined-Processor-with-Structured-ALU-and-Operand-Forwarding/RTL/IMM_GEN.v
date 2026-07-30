`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 21:51:16
// Design Name: 
// Module Name: IMM_GEN
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


module IMM_GEN(
    input [31:0] instr,
    output reg [31:0] imm_ext
);
    always @(*) begin
        case(instr[6:0])
            7'h13, 7'h03: // I-type (ALU Imm and Load)
                imm_ext = {{20{instr[31]}}, instr[31:20]};
            7'h23:        // S-type (Store)
                imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            7'h63:        // B-type (Branch)
                imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            default: 
                imm_ext = 32'b0;
        endcase
    end
endmodule
