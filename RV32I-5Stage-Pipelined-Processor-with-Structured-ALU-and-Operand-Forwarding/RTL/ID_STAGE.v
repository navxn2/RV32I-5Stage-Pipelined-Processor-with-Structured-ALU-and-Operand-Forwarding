`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 21:55:40
// Design Name: 
// Module Name: ID_STAGE
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
// Module Name: ID_STAGE
// Fix: Added rs1_addr_out and rs2_addr_out outputs so register
//      addresses flow to ID_EX pipeline register and forwarding unit.
//////////////////////////////////////////////////////////////////////////////////

module ID_STAGE(
    input clk, rst,
    input [31:0] instr_in,
    input [31:0] wb_data,
    input wb_reg_write,
    input [4:0] wb_rd_addr,
    output [31:0] rs1_data,
    output [31:0] rs2_data,
    output [31:0] imm_ext,
    output [4:0] rd_out,
    output [4:0] rs1_addr_out,   // NEW: rs1 register address
    output [4:0] rs2_addr_out,   // NEW: rs2 register address
    output [2:0] funct3_out,
    output [6:0] funct7_out,
    output ALUSrc,
    output MemtoReg,
    output RegWrite,
    output MemRead,
    output MemWrite,
    output [1:0] ALUOp
);

    CONTROL_UNIT CU (
        .opcode(instr_in[6:0]),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUOp(ALUOp)
    );

    REGISTER_FILE RF (
        .clk(clk),
        .rst(rst),
        .reg_write(wb_reg_write),
        .rs1_addr(instr_in[19:15]),
        .rs2_addr(instr_in[24:20]),
        .rd_addr(wb_rd_addr),
        .write_data(wb_data),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data)
    );

    IMM_GEN IG (
        .instr(instr_in),
        .imm_ext(imm_ext)
    );

    assign rd_out       = instr_in[11:7];
    assign rs1_addr_out = instr_in[19:15];   // NEW: rs1 address
    assign rs2_addr_out = instr_in[24:20];   // NEW: rs2 address
    assign funct3_out   = instr_in[14:12];
    assign funct7_out   = instr_in[31:25];

endmodule
