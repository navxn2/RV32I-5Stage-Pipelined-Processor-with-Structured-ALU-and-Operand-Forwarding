`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 11:17:08
// Design Name: 
// Module Name: AU_ALU
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

/* This module  performs arithmatic operations , address and generation
    1. ADD
    2. SUBTRACT */ 
// If  cntrl == 0 then add else eubtract.
module AU_ALU(
input [31:0] a,b,
input cntrl,
output [31:0] out,
output n,z,c,v);

wire[31:0] b_mux = b^{32{cntrl}};
assign {c,out}= a+b_mux+cntrl;
assign n = out[31];
assign z = (out==32'b0);
assign v =(a[31] == b_mux[31]) && (out[31] != a[31]);
endmodule
