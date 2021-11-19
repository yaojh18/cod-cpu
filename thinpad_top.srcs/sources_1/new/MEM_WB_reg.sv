`timescale 1ns / 1ps
`include "control_signals.vh"

module MEM_WB_Register(
        input wire          clk,
        input wire          rst,
        input wire[11:0]    mem_reg_rd,
        input wire[31:0]    mem_alu_output,
        input wire[31:0]    mem_mem_data_out,
        input wire[31:0]    mem_pc,
        input wire          mem_write_back,
        input wire[1:0]     mem_wb_type,
        
        output reg[11:0]    wb_reg_rd,
        output reg[31:0]    wb_alu_output,
        output reg[31:0]    wb_mem_data_out,
        output reg[31:0]    wb_pc,
        output reg          wb_write_back,
        output reg[1:0]     wb_wb_type
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            wb_reg_rd <= 12'b0;
            wb_alu_output <= 32'b0;
            wb_mem_data_out <= 32'b0;
            wb_pc <= 32'b0;
            wb_write_back <= 1'b0;
            wb_wb_type <= `WB_ALU;
        end
        else begin
            wb_reg_rd <= mem_reg_rd;
            wb_alu_output <= mem_alu_output;
            wb_mem_data_out <= mem_mem_data_out;
            wb_pc <= mem_pc;
            wb_write_back <= mem_write_back;
            wb_wb_type <= mem_wb_type;
        end
    end
    
endmodule
