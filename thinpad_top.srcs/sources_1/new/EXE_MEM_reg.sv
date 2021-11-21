`timescale 1ns / 1ps
`include "control_signals.vh"

module EXE_MEM_Register(
        input wire          clk,
        input wire          rst,
        input wire[4:0]     exe_reg_rd,
        input wire[31:0]    exe_alu_output,
        input wire[31:0]    exe_mem_data_in,
        input wire[31:0]    exe_pc,
        input wire          exe_write_mem,
        input wire          exe_read_mem,
        input wire          exe_mem_byte,
        input wire          exe_write_back,
        input wire[1:0]     exe_wb_type,
        
        output reg[4:0]     mem_reg_rd,
        output reg[31:0]    mem_alu_output,
        output reg[31:0]    mem_mem_data_in,
        output reg[31:0]    mem_pc,
        output reg          mem_write_mem,
        output reg          mem_read_mem,
        output reg          mem_mem_byte,
        output reg          mem_write_back,
        output reg[1:0]     mem_wb_type
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            mem_reg_rd <= 5'b00000;
            mem_alu_output <= 32'h00000000;
            mem_mem_data_in <= 32'h00000000;
            mem_pc <= 32'h00000000;
            mem_write_mem <= 1'b0;
            mem_read_mem <= 1'b0;
            mem_mem_byte <= 1'b0;
            mem_write_back <= 1'b0;
            mem_wb_type <= `WB_ALU;
        end
        else begin
            mem_reg_rd <= exe_reg_rd;
            mem_alu_output <= exe_alu_output;
            mem_mem_data_in <= exe_mem_data_in;
            mem_pc <= exe_pc;
            mem_write_mem <= exe_write_mem;
            mem_read_mem <= exe_read_mem;
            mem_mem_byte <= exe_mem_byte;
            mem_write_back <= exe_write_back;
            mem_wb_type <= exe_wb_type;
        end
    end
    
endmodule
