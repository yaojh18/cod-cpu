`timescale 1ns / 1ps

module IF_ID_Register(
        input wire          clk,
        input wire          rst,
        input wire          delay_rst,
        input wire          delay,
        input wire[31:0]    if_instruction,
        input wire[31:0]    if_pc,
        output reg[31:0]    id_instruction,
        output reg[31:0]    id_pc
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst | delay_rst) begin
            id_instruction <= 32'h13;      // add x0, x0, x0, ==nop
            id_pc <= 32'h0;
        end
        else if (!delay) begin 
            id_instruction <= if_instruction;
            id_pc <= if_pc;
        end
    end
    
endmodule
