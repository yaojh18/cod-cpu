`timescale 1ns / 1ps
`include "control_signals.vh"

module ID_EXE_Register(
        input wire          clk,
        input wire          rst,
        input wire          delay_rst,
        
        input wire[11:0]    mem_exe_reg_rd,
        input wire[11:0]    wb_exe_reg_rd,
        input wire[31:0]    mem_exe_reg_data,
        input wire[31:0]    wb_exe_reg_data,
        
        input wire[11:0]    id_reg_rs1,
        input wire[11:0]    id_reg_rs2,
        input wire[11:0]    id_reg_rd,
        input wire[31:0]    id_imm,
        input wire[31:0]    id_reg_rdata1,
        input wire[31:0]    id_reg_rdata2,
        input wire[31:0]    id_pc,
        input wire[3:0]     id_alu_op,
        input wire          id_pc_select,
        input wire          id_imm_select,
        input wire          id_branch,
        input wire          id_branch_comp,
        input wire          id_jump,
        input wire          id_write_mem,
        input wire          id_read_mem,
        input wire          id_mem_byte,
        input wire          id_write_back,
        input wire[1:0]     id_wb_type,
               
        output reg[11:0]    exe_reg_rd,
        output reg[31:0]    exe_imm,
        output reg[31:0]    exe_reg_rdata1,
        output reg[31:0]    exe_reg_rdata2,
        output reg[31:0]    exe_pc,
        output reg[3:0]     exe_alu_op,
        output reg          exe_pc_select,
        output reg          exe_imm_select,
        output reg          exe_branch,
        output reg          exe_branch_comp,
        output reg          exe_jump,
        output reg          exe_write_mem,
        output reg          exe_read_mem,
        output reg          exe_mem_byte,
        output reg          exe_write_back,
        output reg[1:0]     exe_wb_type
    );
    wire[1:0] reg_rs1_conflict;
    wire[1:0] reg_rs2_conflict;
    assign reg_rs1_conflict = (mem_exe_reg_rd != 12'b0 && mem_exe_reg_rd == id_reg_rs1)? 2'b10: ((wb_exe_reg_rd != 12'b0 && wb_exe_reg_rd == id_reg_rs1)? 2'b01: 2'b00);
    assign reg_rs2_conflict = (mem_exe_reg_rd != 12'b0 && mem_exe_reg_rd == id_reg_rs2)? 2'b10: ((wb_exe_reg_rd != 12'b0 && wb_exe_reg_rd == id_reg_rs2)? 2'b01: 2'b00);
    
    always @(posedge clk or posedge rst) begin
        if(rst | delay_rst) begin
            exe_reg_rd <= 12'b0;
            exe_imm <= 32'b0;
            exe_reg_rdata1 <= 32'b0;
            exe_reg_rdata2 <= 32'b0;
            exe_pc <= 32'b0;
            exe_alu_op <= `ALU_ADD;
            exe_pc_select <= 1'b0;
            exe_imm_select <= 1'b1;
            exe_branch <= 1'b0;
            exe_branch_comp <= 1'b0;
            exe_jump <= 1'b0;
            exe_write_mem <= 1'b0;
            exe_read_mem <= 1'b0;
            exe_mem_byte <= 1'b0;
            exe_write_back <= 1'b1;
            exe_wb_type <= `WB_ALU;
        end
        else begin
            if(reg_rs1_conflict == 2'b10)
                exe_reg_rdata1 <= mem_exe_reg_data;
            else if(reg_rs1_conflict == 2'b01)
                exe_reg_rdata1 <= wb_exe_reg_data;
            else
                exe_reg_rdata1 <= id_reg_rdata1;
            if(reg_rs2_conflict == 2'b10)
                exe_reg_rdata2 <= mem_exe_reg_data;
            else if(reg_rs2_conflict == 2'b01)
                exe_reg_rdata2 <= wb_exe_reg_data;
            else
                exe_reg_rdata2 <= id_reg_rdata2;
            exe_reg_rd <= id_reg_rd;
            exe_imm <= id_imm;
            exe_pc <= id_pc;
            exe_alu_op <= id_alu_op;
            exe_pc_select <= id_pc_select;
            exe_imm_select <= id_imm_select;
            exe_branch <= id_branch;
            exe_branch_comp <= id_branch_comp;
            exe_jump <= id_jump;
            exe_write_mem <= id_write_mem;
            exe_read_mem <= id_read_mem;
            exe_mem_byte <= id_mem_byte;
            exe_write_back <= id_write_back;
            exe_wb_type <= id_wb_type;
        end
    end
endmodule
