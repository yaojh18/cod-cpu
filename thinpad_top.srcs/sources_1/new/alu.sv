`default_nettype none
`timescale 1ns / 1ps
`include "control_signals.vh"

module ALU(
    input wire[3:0]        op,
    input wire[31:0]       a,
    input wire[31:0]       b,
    output wire[31:0]      r,
    output wire[3:0]       flags
    );
    
    reg zf,cf,sf,vf;
    reg[31:0] result;
    reg[15:0] a16;
    reg[7:0] a8;
    reg[3:0] a4;
    
    assign flags = {zf,cf,sf,vf};
    assign r = result;
    
    always @(*) begin
        zf = 0;
        cf = 0;
        sf = 0;
        vf = 0;
        case (op)
            `ALU_ADD:begin
                result = a + b;
                if (result < a)
                    cf = 1'b1;
                else
                    cf = 1'b0;
                if ((result[31] != a[31]) && (a[31] == b[31]))
                    vf = 1'b1;
                else
                    vf = 1'b0;
            end
            `ALU_SUB : begin
                result = a - b;
                if (result > a)
                    cf = 1'b1;
                else
                    cf = 1'b0;
                if ((result[31] != a[31]) && (a[31] == b[31]))
                    vf = 1'b1;
                else
                    vf = 1'b0;
            end
           `ALU_AND : begin
                result = a & b;
            end
            `ALU_OR  : begin
                result = a | b;
            end
            `ALU_XOR : begin
                result = a ^ b;
            end
            `ALU_NOT : begin
                result = ~a;
            end
            `ALU_SLL : begin
                result = a << b;
            end
            `ALU_SRL : begin
                result = a >> b;
            end
            `ALU_LTU : begin
                result = a < b;
            end 
            `ALU_NOT_AND: begin
                result = a & (~b);
            end
            `ALU_STATUS: begin
                result = {19'b0, a[1:0], 9'b0, b[1:0]};
            end
            `ALU_PACK : begin
                result = {b[15:0], a[15:0]};
            end 
            `ALU_SBSET : begin
                result = a | (32'b1 << (b & 32'b11111));
            end
            `ALU_CLZ : begin
                result = 0;
                if (a & 32'hffff0000)
                    a16 = a[31:16];
                else begin
                    a16 = a[15:0];
                    result = result + 16;
                end
                if (a16 & 16'hff00)
                    a8 = a16[15:8];
                else begin 
                    a8 = a16[7:0];
                    result = result + 8;
                end
                if (a8 & 8'hf0)
                    a4 = a8[7:4];
                else begin
                    a4 = a8[3:0];
                    result = result + 4;
                end
                case (a4)
                    4'b0000: result = result + 4;
                    4'b0001: result = result + 3;
                    4'b0010: result = result + 2;
                    4'b0011: result = result + 2;
                    4'b0100: result = result + 1;
                    4'b0101: result = result + 1;
                    4'b0110: result = result + 1;
                    4'b0111: result = result + 1;
                endcase
            end
            default:
                result = 0;
        endcase
        
        zf = result == 0? 1'b1: 1'b0;
        if (result[31] == 1'b1) 
            sf = 1'b1;
        else
            sf = 1'b0;
    end

endmodule


