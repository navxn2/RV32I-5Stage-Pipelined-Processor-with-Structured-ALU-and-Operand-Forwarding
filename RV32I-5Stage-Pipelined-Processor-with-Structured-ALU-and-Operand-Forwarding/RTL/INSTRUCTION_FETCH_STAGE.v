`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 21:19:39
// Design Name: 
// Module Name: INSTRUCTION_FETCH_STAGE
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


module INSTRUCTION_FETCH_STAGE(

    input clk,
    input rst,
    output [31:0] instr_out,
    output [31:0] pc_out
);

    wire [31:0] pc_next;

    assign pc_next = pc_out + 32'd4;
    PROGRAM_COUNTER pc_reg (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_next),
        .pc_out(pc_out)
    );

    INSTRUCTION_MEMORY imem (
        .addr(pc_out),
        .instr(instr_out)
    );

endmodule


