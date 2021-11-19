`timescale 1ns / 1ps
`include "control_signals.vh"

module MEM_WB_Register(
        input wire          clk,
        input wire          rst,
        input wire[11:0]    mem_reg_rd1,
        input wire[11:0]    mem_reg_rd2,
        input wire[11:0]    mem_reg_rd3,
        input wire[31:0]    mem_reg_rdata1,
        input wire[31:0]    mem_reg_rdata2,
        input wire[31:0]    mem_alu_output,
        input wire[31:0]    mem_mem_data_out,
        input wire[31:0]    mem_pc,
        input wire          mem_write_back1,
        input wire[2:0]     mem_wb_type1,
        input wire          mem_write_back2,
        input wire[2:0]     mem_wb_type2,
        input wire          mem_write_back3,
        input wire[2:0]     mem_wb_type3,
        
        output reg[11:0]    wb_reg_rd1,
        output reg[11:0]    wb_reg_rd2,
        output reg[11:0]    wb_reg_rd3,
        output reg[31:0]    wb_reg_rdata1,
        output reg[31:0]    wb_reg_rdata2,
        output reg[31:0]    wb_alu_output,
        output reg[31:0]    wb_mem_data_out,
        output reg[31:0]    wb_pc,
        output reg          wb_write_back1,
        output reg[2:0]     wb_wb_type1,
        output reg          wb_write_back2,
        output reg[2:0]     wb_wb_type2,
        output reg          wb_write_back3,
        output reg[2:0]     wb_wb_type3
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            wb_reg_rd1 <= 12'b0;
            wb_reg_rd2 <= 12'b0;
            wb_reg_rd3 <= 12'b0;
            wb_reg_rdata1 <= 32'b0;
            wb_reg_rdata2 <= 32'b0;
            wb_alu_output <= 32'b0;
            wb_mem_data_out <= 32'b0;
            wb_pc <= 32'b0;
            wb_write_back1 <= 1'b0;
            wb_wb_type1 <= `WB_ALU;
            wb_write_back2 <= 1'b0;
            wb_wb_type2 <= `WB_ALU;
            wb_write_back3 <= 1'b0;
            wb_wb_type3 <= `WB_ALU;
        end
        else begin
            wb_reg_rd1 <= mem_reg_rd1;
            wb_reg_rd2 <= mem_reg_rd2;
            wb_reg_rd3 <= mem_reg_rd3;
            wb_reg_rdata1 <= mem_reg_rdata1;
            wb_reg_rdata2 <= mem_reg_rdata2;
            wb_alu_output <= mem_alu_output;
            wb_mem_data_out <= mem_mem_data_out;
            wb_pc <= mem_pc;
            wb_write_back1 <= mem_write_back1;
            wb_wb_type1 <= mem_wb_type1;
            wb_write_back2 <= mem_write_back2;
            wb_wb_type2 <= mem_wb_type2;
            wb_write_back3 <= mem_write_back3;
            wb_wb_type3 <= mem_wb_type3;
        end
    end
    
endmodule
