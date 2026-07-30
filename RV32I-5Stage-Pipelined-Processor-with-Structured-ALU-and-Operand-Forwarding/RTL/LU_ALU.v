`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 12:07:40
// Design Name: 
// Module Name: LU_ALU
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
/* This module does 3 logical operations 
   1. AND
   2. OR
   3. XOR
   4. PASSING THE INPUT A AS THE SAME */

module LU_ALU(
input [31:0]a,b,
input [1:0] sel,
output [31:0] out);

assign out = (sel==2'b00)?(a&b):(sel==2'b01 )? (a|b) :(sel==2'b10)?  (a^b):a;
endmodule
