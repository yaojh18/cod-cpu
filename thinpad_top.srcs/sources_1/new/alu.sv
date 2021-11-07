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
            
            `ALU_SRA : begin
                result = $signed(a)>>>b;    
            end
            
            `ALU_ROL : begin
                result = (a << b) | (a >> (32-b)); 
            end 
            
            default :
                result = 0;
        endcase
        
        zf = result == 0? 1'b1: 1'b0;
        if (result[31] == 1'b1) 
            sf = 1'b1;
        else
            sf = 1'b0;
    end

endmodule


