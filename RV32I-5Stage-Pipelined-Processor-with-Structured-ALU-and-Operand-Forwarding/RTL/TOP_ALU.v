`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 16:46:14
// Design Name: 
// Module Name: TOP_ALU
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
/* This is the top module . For barrel shifter input b tells the amount of shift .
   The [1:0] of the control bus selects the respective operation inside the submodules
   The [3:2] of the control bus selects the instantiation .*/



module TOP_ALU(
input [31:0]a,b,
input [3:0] control,
output reg [31:0] alu_out,  
output  zero,neg,carry,overflow);

wire au_enable,lu_enable,bs_enable;
wire [31:0] au_out,lu_out,bs_out;

assign au_enable = (control[3:2] == 2'b00);
assign lu_enable = (control[3:2] == 2'b01);
assign bs_enable = (control[3:2] == 2'b10);

wire [31:0] gated_a_au = a & {32{ au_enable}};
wire [31:0] gated_a_lu = a & {32{ lu_enable}};
wire [31:0] gated_a_bs = a & {32{ bs_enable}};
wire [31:0] gated_b_au = b & {32{ au_enable}};
wire [31:0] gated_b_lu = b & {32{ lu_enable}};
wire [31:0] gated_b_bs = b & {32{ bs_enable}};

AU_ALU arithmatic_unit(gated_a_au,gated_b_au,control[0],au_out,neg,zero,carry,overflow);
LU_ALU logical_unit(gated_a_lu,gated_b_lu,control[1:0],lu_out);
BS_ALU barrel_shifter_unit(gated_a_bs,gated_b_bs[4:0],control[1:0],bs_out);

always @(*)begin
case (control[3:2]) 
2'b00 : alu_out = au_out;
2'b01 : alu_out = lu_out;
2'b10 : alu_out = bs_out;
default:  alu_out = 32'b0;
endcase
end

endmodule


