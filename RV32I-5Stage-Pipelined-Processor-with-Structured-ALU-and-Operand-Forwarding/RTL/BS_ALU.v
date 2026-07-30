`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 12:20:12
// Design Name: 
// Module Name: BS_ALU
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

/* This is a barrel shifter . It divides the 32 bits in to 4 segments and shifts it .
    This enables us to control the timing by ourself and we will know the exact hardware this code will synthesize. */
module BS_ALU (
    input  [31:0] a,        
    input  [4:0]  shamt,    
    input  [1:0]  type,     
    output [31:0] out
);

    reg [31:0] stage0, stage1, stage2, stage3, stage4;
    wire fill_bit = (type == 2'b10) ? a[31] : 1'b0; 

    always @(*) begin
        
        if (shamt[4]) begin
            if (type == 2'b00) stage0 = {a[15:0], 16'b0};          
            else               stage0 = {{16{fill_bit}}, a[31:16]}; 
        end else stage0 = a;
        if (shamt[3]) begin
            if (type == 2'b00) stage1 = {stage0[23:0], 8'b0};           
            else               stage1 = {{8{fill_bit}}, stage0[31:8]};  
        end else stage1 = stage0;
        if (shamt[2]) begin
            if (type == 2'b00) stage2 = {stage1[27:0], 4'b0};           
            else               stage2 = {{4{fill_bit}}, stage1[31:4]};  
        end else stage2 = stage1;
        if (shamt[1]) begin
            if (type == 2'b00) stage3 = {stage2[29:0], 2'b0};     
            else               stage3 = {{2{fill_bit}}, stage2[31:2]};  
        end else stage3 = stage2;
        if (shamt[0]) begin
            if (type == 2'b00) stage4 = {stage3[30:0], 1'b0};          
            else               stage4 = {fill_bit, stage3[31:1]};     
        end else stage4 = stage3;
    end

    assign out = stage4;

endmodule
