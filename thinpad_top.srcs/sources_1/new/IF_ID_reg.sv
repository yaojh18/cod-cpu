`timescale 1ns / 1ps

module IF_ID_Register(
        input wire          clk,
        input wire          rst,
        input wire          delay_rst,
        input wire[31:0]    if_instruction,
        input wire[31:0]    if_pc,
        output reg[31:0]    id_instruction,
        output reg[31:0]    id_pc
    );
    reg delay_rst_reg;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            id_instruction <= 32'h13;      // add x0, x0, x0, ==nop
            id_pc <= 32'h0;
            delay_rst_reg <= 1'b0;
        end
        else begin
            if (~delay_rst_reg & delay_rst) begin
                id_instruction <= 32'h13;      // add x0, x0, x0, ==nop
                id_pc <= 32'h0;
                delay_rst_reg <= 1'b1;
            end
            else begin
                if (delay_rst_reg & ~delay_rst)
                    delay_rst_reg = 1'b0;
                id_instruction <= if_instruction;
                id_pc <= if_pc;
            end
        end
    end
    
endmodule
