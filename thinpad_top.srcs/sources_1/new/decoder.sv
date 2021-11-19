`default_nettype none
`timescale 1ns / 1ps
`include "control_signals.vh"

module Decoder(
    input wire[31:0]        inst,           // instruction
    output reg[11:0]        reg_rs1,
    output wire[11:0]       reg_rs2,
    output wire[11:0]       reg_rd,
    output reg[31:0]        imm,
    output reg[3:0]         alu_op,
    output reg              pc_select,      // 1:select pc as alu_input1, 0:select reg data
    output reg              imm_select,     // 1:select imm as alu_input2, 0:select reg data
    output reg              branch,         // conditioned branching, 1:pc=branch addr, 0:pc=pc+4
    output reg              branch_comp,    // branch compare type
    output reg              jump,           // unconditioned branching
    output reg              write_mem,
    output reg              read_mem,       // also control write back data type
    output reg              mem_byte,       // 1: lb/sb, 0: lw/sw
    output reg              write_back,     // 1: write back, 0: don't write back
    output reg[1:0]         wb_type         // choose what data to write back
    );
    
    wire sign;
    wire[19:0] sign_ext20;
    wire[10:0] sign_ext11;
    assign sign = inst[31];
    assign sign_ext20 = {20{sign}};
    assign sign_ext11 = {11{sign}};
    assign reg_rd = inst[11:7];
    assign reg_rs2 = inst[24:20];
    
    always @(*) begin
        reg_rs1 = inst[19:15];
        imm = 32'h0;
        alu_op = `ALU_ZERO;
        pc_select = 1'b0;
        imm_select = 1'b0;
        branch = 1'b0;
        branch_comp = `BEQ;
        jump = 1'b0;
        write_mem = 1'b0;
        read_mem = 1'b0;
        mem_byte = 1'b0;
        write_back = 1'b0;
        wb_type = `WB_ALU;
        case(inst[6:0])
            7'b0110011: begin //R-type
                write_back = 1'b1;
                case({inst[31:25], inst[14:12]})
                    10'b0000000_000: alu_op = `ALU_ADD;
                    10'b0000000_111: alu_op = `ALU_AND;
                    10'b0000000_110: alu_op = `ALU_OR;
                    10'b0000000_100: alu_op = `ALU_XOR;
                    10'b0000000_011: alu_op = `ALU_LTU;
                    10'b0000100_100: alu_op = `ALU_PACK;
                    10'b0010100_001: alu_op = `ALU_SBSET;
                endcase
            end
            7'b0010011: begin //I-type
                write_back = 1'b1;
                case(inst[14:12])
                    3'b000: begin
                        imm = {sign_ext20, inst[31:20]};
                        imm_select = 1'b1;
                        alu_op = `ALU_ADD;   //ADDI
                    end
                    3'b111: begin
                        imm = {sign_ext20, inst[31:20]};
                        imm_select = 1'b1;
                        alu_op = `ALU_AND;   // ANDI
                    end
                    3'b110: begin
                        imm = {sign_ext20, inst[31:20]};
                        imm_select = 1'b1;
                        alu_op = `ALU_OR;    // ORI
                    end
                    3'b001: begin
                        case (inst[31:25])
                            7'b0000000: begin
                                imm = {27'b0, inst[24:20]};
                                imm_select = 1'b1;
                                alu_op = `ALU_SLL;  // SLLI
                            end
                            7'b0110000: begin
                                if (inst[24:20] == 5'b00000) begin
                                    imm = 32'b0;
                                    imm_select = 1'b1;
                                    alu_op = `ALU_CLZ;  // CLZ
                                end
                                else alu_op = `ALU_ZERO;  // ERROR
                            end
                            default: alu_op = `ALU_ZERO;  // ERROR
                        endcase
                    end
                    3'b101: begin
                        if (inst[31:25] == 7'b0) begin
                            imm = {sign_ext20, inst[31:20]};
                            imm_select = 1'b1;
                            alu_op = `ALU_SRL;  // SRLI
                        end
                        else alu_op = `ALU_ZERO;  // ERROR
                    end
                endcase
            end
            7'b0000011: begin //Load
                imm = {sign_ext20, inst[31:20]};
                alu_op = `ALU_ADD;
                imm_select = 1'b1;
                read_mem = 1'b1;
                write_back = 1'b1;
                wb_type = `WB_MEM;
                case(inst[14:12])
                    3'b000: mem_byte = 1'b1;    // LB
                    3'b010: mem_byte = 1'b0;    // LW
                endcase
            end
            7'b0100011: begin //Save
                imm = {sign_ext20, inst[31:25], inst[11:7]};
                alu_op = `ALU_ADD;
                imm_select = 1'b1;
                write_mem = 1'b1;
                case(inst[14:12])
                    3'b000: mem_byte = 1'b1;    // SB
                    3'b010: mem_byte = 1'b0;    // SW
                endcase
            end
            7'b1100011: begin //B-type
                imm = {
                    sign_ext20,
                    inst[7],inst[30:25],inst[11:8],1'b0
                };
                alu_op = `ALU_ADD;
                pc_select = 1'b1;
                imm_select = 1'b1;
                branch = 1'b1;
                case(inst[14:12])
                    3'b000: branch_comp = `BEQ;  // BEQ
                    3'b001: branch_comp = `BNE;  // BNE
                endcase
            end
            7'b1101111: begin //jal
                imm = {sign_ext11,inst[31],inst[19:12],inst[20],inst[30:21],1'b0};
                pc_select = 1'b1;
                imm_select = 1'b1;
                jump = 1'b1;
                write_back = 1'b1;
                wb_type = `WB_PC;
                alu_op = `ALU_ADD;
            end
            7'b1100111: begin //jalr
                imm = {sign_ext20,inst[31:20]};
                imm_select = 1'b1;
                jump = 1'b1;
                write_back = 1'b1;
                wb_type = `WB_PC;
                alu_op = `ALU_ADD;
            end
            7'b0110111: begin //lui
                reg_rs1 = 5'b00000;     // rd = 0 + imm
                imm = {inst[31:12], 12'h0};
                imm_select = 1'b1;
                write_back = 1'b1;
                alu_op = `ALU_ADD;
            end
            7'b0010111: begin //auipc
                imm = {inst[31:12], 12'h0};
                pc_select = 1'b1;
                imm_select = 1'b1;
                write_back = 1'b1;
                alu_op = `ALU_ADD;
            end
        endcase 
    end
endmodule
