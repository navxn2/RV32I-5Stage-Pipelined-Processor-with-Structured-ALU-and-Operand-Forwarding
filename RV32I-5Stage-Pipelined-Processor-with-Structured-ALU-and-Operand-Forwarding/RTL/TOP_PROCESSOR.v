`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: TOP_PROCESSOR  (RISCV_WITH ALU_TOP)
// Fix: Forwarding unit now receives correct register ADDRESSES
//      via IDEX_rs1_addr / IDEX_rs2_addr instead of data[4:0]
//////////////////////////////////////////////////////////////////////////////////

module TOP_PROCESSOR(
    input clk,
    input rst
);

    wire [31:0] IF_instr, IF_pc;
    wire [31:0] IFID_instr, IFID_pc;

    wire [31:0] ID_rs1, ID_rs2, ID_imm;
    wire [4:0]  ID_rd;
    wire [4:0]  ID_rs1_addr, ID_rs2_addr;       // NEW
    wire [2:0]  ID_funct3;
    wire [6:0]  ID_funct7;
    wire ID_ALUSrc, ID_MemtoReg, ID_RegWrite, ID_MemRead, ID_MemWrite;
    wire [1:0]  ID_ALUOp;

    wire [31:0] IDEX_rs1, IDEX_rs2, IDEX_imm;
    wire [4:0]  IDEX_rd;
    wire [4:0]  IDEX_rs1_addr, IDEX_rs2_addr;   // NEW
    wire [2:0]  IDEX_funct3;
    wire [6:0]  IDEX_funct7;
    wire IDEX_ALUSrc, IDEX_MemtoReg, IDEX_RegWrite, IDEX_MemRead, IDEX_MemWrite;
    wire [1:0]  IDEX_ALUOp;

    wire [31:0] EX_alu_result, EX_rs2_data;
    wire [4:0]  EX_rd;
    wire EX_MemtoReg, EX_RegWrite, EX_MemRead, EX_MemWrite;

    wire [31:0] EXMEM_alu_result, EXMEM_rs2_data;
    wire [4:0]  EXMEM_rd;
    wire EXMEM_MemtoReg, EXMEM_RegWrite, EXMEM_MemRead, EXMEM_MemWrite;

    wire [31:0] MEM_read_data;
    wire [31:0] MEM_alu_result;
    wire [4:0]  MEM_rd;
    wire MEM_MemtoReg, MEM_RegWrite;

    wire [31:0] MEMWB_read_data, MEMWB_alu_result;
    wire [4:0]  MEMWB_rd;
    wire MEMWB_MemtoReg, MEMWB_RegWrite;

    wire [31:0] WB_data;
    wire [4:0]  WB_rd_addr;
    wire WB_reg_write;

    // ------------------------------------------------------------------
    // IF Stage
    // ------------------------------------------------------------------
    INSTRUCTION_FETCH_STAGE IF_Stage (
        .clk(clk),
        .rst(rst),
        .instr_out(IF_instr),
        .pc_out(IF_pc)
    );

    // ------------------------------------------------------------------
    // IF/ID Pipeline Register
    // ------------------------------------------------------------------
    IF_ID_PIPELINE_REG IFID_Reg (
        .clk(clk),
        .rst(rst),
        .instr_in(IF_instr),
        .pc_in(IF_pc),
        .instr_out(IFID_instr),
        .pc_out(IFID_pc)
    );

    // ------------------------------------------------------------------
    // ID Stage
    // ------------------------------------------------------------------
    ID_STAGE ID_Stage (
        .clk(clk),
        .rst(rst),
        .instr_in(IFID_instr),
        .wb_data(WB_data),
        .wb_reg_write(WB_reg_write),
        .wb_rd_addr(WB_rd_addr),
        .rs1_data(ID_rs1),
        .rs2_data(ID_rs2),
        .imm_ext(ID_imm),
        .rd_out(ID_rd),
        .rs1_addr_out(ID_rs1_addr),          // NEW
        .rs2_addr_out(ID_rs2_addr),          // NEW
        .funct3_out(ID_funct3),
        .funct7_out(ID_funct7),
        .ALUSrc(ID_ALUSrc),
        .MemtoReg(ID_MemtoReg),
        .RegWrite(ID_RegWrite),
        .MemRead(ID_MemRead),
        .MemWrite(ID_MemWrite),
        .ALUOp(ID_ALUOp)
    );

    // ------------------------------------------------------------------
    // ID/EX Pipeline Register
    // ------------------------------------------------------------------
    ID_EX_PIPELINE_REG IDEX_Reg (
        .clk(clk),
        .rst(rst),
        .rs1_in(ID_rs1),
        .rs2_in(ID_rs2),
        .imm_in(ID_imm),
        .rd_in(ID_rd),
        .rs1_addr_in(ID_rs1_addr),           // NEW
        .rs2_addr_in(ID_rs2_addr),           // NEW
        .funct3_in(ID_funct3),
        .funct7_in(ID_funct7),
        .ALUSrc_in(ID_ALUSrc),
        .MemtoReg_in(ID_MemtoReg),
        .RegWrite_in(ID_RegWrite),
        .MemRead_in(ID_MemRead),
        .MemWrite_in(ID_MemWrite),
        .ALUOp_in(ID_ALUOp),
        .rs1_out(IDEX_rs1),
        .rs2_out(IDEX_rs2),
        .imm_out(IDEX_imm),
        .rd_out(IDEX_rd),
        .rs1_addr_out(IDEX_rs1_addr),        // NEW
        .rs2_addr_out(IDEX_rs2_addr),        // NEW
        .funct3_out(IDEX_funct3),
        .funct7_out(IDEX_funct7),
        .ALUSrc_out(IDEX_ALUSrc),
        .MemtoReg_out(IDEX_MemtoReg),
        .RegWrite_out(IDEX_RegWrite),
        .MemRead_out(IDEX_MemRead),
        .MemWrite_out(IDEX_MemWrite),
        .ALUOp_out(IDEX_ALUOp)
    );

    // ------------------------------------------------------------------
    // EX Stage  - BUG FIX: use IDEX_rs1_addr / IDEX_rs2_addr
    // ------------------------------------------------------------------
    EXECUTION_STAGE EX_Stage (
        .rs1_ex(IDEX_rs1_addr),              // FIXED (was IDEX_rs1[4:0])
        .rs2_ex(IDEX_rs2_addr),              // FIXED (was IDEX_rs2[4:0])
        .rd_mem(EXMEM_rd),
        .rd_wb(MEMWB_rd),
        .reg_write_mem(EXMEM_RegWrite),
        .reg_write_wb(MEMWB_RegWrite),
        .reg_data_a(IDEX_rs1),
        .reg_data_b(IDEX_rs2),
        .mem_data(EXMEM_alu_result),
        .wb_data(WB_data),
        .imm_ex(IDEX_imm),
        .alu_src(IDEX_ALUSrc),
        .alu_control({IDEX_ALUOp, IDEX_funct3[1:0]}),
        .alu_result(EX_alu_result),
        .zero(),
        .neg(),
        .carry(),
        .overflow(),
        .forward_a(),
        .forward_b(),
        .alu_in_a(),
        .alu_in_b(),
        .final_alu_b(EX_rs2_data)
    );

    assign EX_rd       = IDEX_rd;
    assign EX_MemtoReg = IDEX_MemtoReg;
    assign EX_RegWrite = IDEX_RegWrite;
    assign EX_MemRead  = IDEX_MemRead;
    assign EX_MemWrite = IDEX_MemWrite;

    // ------------------------------------------------------------------
    // EX/MEM Pipeline Register
    // ------------------------------------------------------------------
    EX_MEM_PIPELINE_REG EXMEM_Reg (
        .clk(clk),
        .rst(rst),
        .alu_result(EX_alu_result),
        .reg_data_b(EX_rs2_data),
        .rd_ex(EX_rd),
        .reg_write(EX_RegWrite),
        .mem_to_reg(EX_MemtoReg),
        .mem_write(EX_MemWrite),
        .alu_result_out(EXMEM_alu_result),
        .reg_data_b_out(EXMEM_rs2_data),
        .rd_out(EXMEM_rd),
        .reg_write_out(EXMEM_RegWrite),
        .mem_to_reg_out(EXMEM_MemtoReg),
        .mem_write_out(EXMEM_MemWrite)
    );

    // ------------------------------------------------------------------
    // MEM Stage
    // ------------------------------------------------------------------
    MEMORY_STAGE MEM_Stage (
        .clk(clk),
        .write_mem_control(EXMEM_MemWrite),
        .alu_result(EXMEM_alu_result),
        .write_data(EXMEM_rs2_data),
        .read_data(MEM_read_data)
    );

    assign MEM_alu_result = EXMEM_alu_result;
    assign MEM_rd         = EXMEM_rd;
    assign MEM_MemtoReg   = EXMEM_MemtoReg;
    assign MEM_RegWrite   = EXMEM_RegWrite;

    // ------------------------------------------------------------------
    // MEM/WB Pipeline Register
    // ------------------------------------------------------------------
    MEM_WB_PIPELINE_REG MEMWB_Reg (
        .clk(clk),
        .rst(rst),
        .read_data(MEM_read_data),
        .alu_result(MEM_alu_result),
        .rd_mem(MEM_rd),
        .mem_to_reg(MEM_MemtoReg),
        .reg_write(MEM_RegWrite),
        .read_data_out(MEMWB_read_data),
        .alu_result_out(MEMWB_alu_result),
        .rd_out(MEMWB_rd),
        .mem_to_reg_out(MEMWB_MemtoReg),
        .reg_write_out(MEMWB_RegWrite)
    );

    // ------------------------------------------------------------------
    // WB Stage
    // ------------------------------------------------------------------
    WRITEBACK_STAGE WB_Stage (
        .alu_result_wb(MEMWB_alu_result),
        .read_data_wb(MEMWB_read_data),
        .mem_to_reg_wb(MEMWB_MemtoReg),
        .write_back_data(WB_data)
    );

    assign WB_rd_addr   = MEMWB_rd;
    assign WB_reg_write = MEMWB_RegWrite;

endmodule