`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.05.2026 19:15:38
// Design Name: 
// Module Name: EXECUTION_STAGE
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

/* This is the execution stage . The b input to the alu can be immediate of from reg .
alu_src if it is 0 then register/forwarded data or else immediate data.
This module also handles forwarding from mem-ex pipeline register and mem_wb pipeline register .*/

module EXECUTION_STAGE(
    input [4:0] rs1_ex, rs2_ex,
    input [4:0] rd_mem, rd_wb,
    input reg_write_mem, reg_write_wb,
    input [31:0] reg_data_a, reg_data_b, mem_data, wb_data, imm_ex,
    input alu_src,
    input [3:0] alu_control, 
    output [31:0] alu_result, 
    output zero, neg, carry, overflow,
    output [1:0] forward_a, forward_b,
    output reg [31:0] alu_in_a, alu_in_b, final_alu_b
);

    forwarding_unit fwd_unit (
        .rs_ex1(rs1_ex),
        .rs_ex2(rs2_ex),
        .rd_mem(rd_mem),
        .rd_wb(rd_wb),
        .reg_write_mem(reg_write_mem),
        .reg_write_wb(reg_write_wb),
        .forward_a(forward_a),
        .forward_b(forward_b)
    );

    always @(*) begin
        case(forward_a)
            2'b10:   alu_in_a = mem_data;
            2'b01:   alu_in_a = wb_data;
            default: alu_in_a = reg_data_a;
        endcase

        case(forward_b)
            2'b10:   alu_in_b = mem_data;
            2'b01:   alu_in_b = wb_data;
            default: alu_in_b = reg_data_b;
        endcase

        if(alu_src) begin
            final_alu_b = imm_ex;
        end else begin
            final_alu_b = alu_in_b; 
        end
    end

    TOP_ALU alu_inst (
        .a(alu_in_a),
        .b(final_alu_b),
        .control(alu_control),
        .alu_out(alu_result),
        .zero(zero),
        .neg(neg),
        .carry(carry),
        .overflow(overflow)
    );

endmodule
