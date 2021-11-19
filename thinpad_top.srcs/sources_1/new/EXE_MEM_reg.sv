`timescale 1ns / 1ps
`include "control_signals.vh"

module EXE_MEM_Register(
        input wire          clk,
        input wire          rst,
        input wire[11:0]    exe_reg_rd1,
        input wire[11:0]    exe_reg_rd2,
        input wire[11:0]    exe_reg_rd3,
        input wire[31:0]    exe_reg_rdata1,
        input wire[31:0]    exe_reg_rdata2,
        input wire[31:0]    exe_alu_output,
        input wire[31:0]    exe_mem_data_in,
        input wire[31:0]    exe_pc,
        input wire          exe_write_mem,
        input wire          exe_read_mem,
        input wire          exe_mem_byte,
        input wire          exe_write_back1,
        input wire[1:0]     exe_wb_type1,
        input wire          exe_write_back2,
        input wire[1:0]     exe_wb_type2,
        input wire          exe_write_back3,
        input wire[1:0]     exe_wb_type3,
        
        output reg[11:0]    mem_reg_rd1,
        output reg[11:0]    mem_reg_rd2,
        output reg[11:0]    mem_reg_rd3,
        output reg[31:0]    mem_reg_rdata1,
        output reg[31:0]    mem_reg_rdata2,
        output reg[31:0]    mem_alu_output,
        output reg[31:0]    mem_mem_data_in,
        output reg[31:0]    mem_pc,
        output reg          mem_write_mem,
        output reg          mem_read_mem,
        output reg          mem_mem_byte,
        output reg          mem_write_back1,
        output reg[1:0]     mem_wb_type1,
        output reg          mem_write_back2,
        output reg[1:0]     mem_wb_type2,
        output reg          mem_write_back3,
        output reg[1:0]     mem_wb_type3
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            mem_reg_rd1 <= 12'b0;
            mem_reg_rd2 <= 12'b0;
            mem_reg_rd3 <= 12'b0;
            mem_reg_rdata1 <= 32'b0;
            mem_reg_rdata2 <= 32'b0;
            mem_alu_output <= 32'b0;
            mem_mem_data_in <= 32'b0;
            mem_pc <= 32'b0;
            mem_write_mem <= 1'b0;
            mem_read_mem <= 1'b0;
            mem_mem_byte <= 1'b0;
            mem_write_back1 <= 1'b0;
            mem_wb_type1 <= `WB_ALU;
            mem_write_back2 <= 1'b0;
            mem_wb_type2 <= `WB_ALU;
            mem_write_back3 <= 1'b0;
            mem_wb_type3 <= `WB_ALU;
        end
        else begin
            mem_reg_rd1 <= exe_reg_rd1;
            mem_reg_rd2 <= exe_reg_rd2;
            mem_reg_rd3 <= exe_reg_rd3;
            mem_reg_rdata1 <= exe_reg_rdata1;
            mem_reg_rdata2 <= exe_reg_rdata2;
            mem_alu_output <= exe_alu_output;
            mem_mem_data_in <= exe_mem_data_in;
            mem_pc <= exe_pc;
            mem_write_mem <= exe_write_mem;
            mem_read_mem <= exe_read_mem;
            mem_mem_byte <= exe_mem_byte;
            mem_write_back1 <= exe_write_back1;
            mem_wb_type1 <= exe_wb_type1;
            mem_write_back2 <= exe_write_back2;
            mem_wb_type2 <= exe_wb_type2;
            mem_write_back3 <= exe_write_back3;
            mem_wb_type3 <= exe_wb_type3;
        end
    end
    
endmodule
