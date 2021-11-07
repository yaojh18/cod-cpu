`timescale 1ns / 1ps

module IF_ID_Register(
        input wire          clk,
        input wire          rst,
        input wire[31:0]    if_instruction,
        input wire[31:0]    if_pc,
        output reg[31:0]    id_instruction,
        output reg[31:0]    id_pc
    );
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            id_instruction = 32'h00000000;      // add x0, x0, x0, ==nop
            id_pc = 32'h00000000;
        end
        else begin
            id_instruction = if_instruction;
            id_pc = if_pc;
        end
    end
    
endmodule
