`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 18:04:36
// Design Name: 
// Module Name: forwarding_unit
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


module forwarding_unit(
input [4:0] rs_ex1,rs_ex2,rd_mem,rd_wb,
input reg_write_mem,reg_write_wb,
output reg [1:0] forward_a,forward_b );

always @(*) begin
    
    if (reg_write_mem && (rd_mem != 5'b0) && (rd_mem == rs_ex1)) begin
        forward_a = 2'b10; 
    end 
    else if (reg_write_wb && (rd_wb != 5'b0) && (rd_wb == rs_ex1)) begin
        forward_a = 2'b01; 
    end 
    else begin
        forward_a = 2'b00;
    end

    if (reg_write_mem && (rd_mem != 5'b0) && (rd_mem == rs_ex2)) begin
        forward_b = 2'b10; 
    end 
    else if (reg_write_wb && (rd_wb != 5'b0) && (rd_wb == rs_ex2)) begin
        forward_b = 2'b01; 
    end 
    else begin
        forward_b = 2'b00; 
    end
end
endmodule
