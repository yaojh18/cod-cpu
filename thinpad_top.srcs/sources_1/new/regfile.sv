`default_nettype none
`timescale 1ns / 1ps

module RegFile(
    input wire          clk,
    input wire          rst,
    input wire          we1,
    input wire[11:0]    waddr1,
    input wire[31:0]    wdata1,
    input wire          we2,
    input wire[11:0]    waddr2,
    input wire[31:0]    wdata2,
    input wire          we3,
    input wire[11:0]    waddr3,
    input wire[31:0]    wdata3,
    
    input wire[11:0]    raddr1,
    input wire[11:0]    raddr2,
    output reg[31:0]    rdata1,
    output reg[31:0]    rdata2
    
    // add more registers if it's wirtable
    );
    reg[31:0] registers[0:31];
    reg[31:0] mtvec, mscratch, mepc, mcause, mstatus; // for exception
    reg[31:0] mie, mip, mtime, mtimecmp;              // for interruption
    reg[31:0] satp;                                   // for page table
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            registers[0]  <= 32'b0;
            registers[1]  <= 32'b0;
            registers[2]  <= 32'b0;
            registers[3]  <= 32'b0;
            registers[4]  <= 32'b0;
            registers[5]  <= 32'b0;
            registers[6]  <= 32'b0;
            registers[7]  <= 32'b0;
            registers[8]  <= 32'b0;
            registers[9]  <= 32'b0;
            registers[10] <= 32'b0;
            registers[11] <= 32'b0;
            registers[12] <= 32'b0;
            registers[13] <= 32'b0;
            registers[14] <= 32'b0;
            registers[15] <= 32'b0;
            registers[16] <= 32'b0;
            registers[17] <= 32'b0;
            registers[18] <= 32'b0;
            registers[19] <= 32'b0;
            registers[20] <= 32'b0;
            registers[21] <= 32'b0;
            registers[22] <= 32'b0;
            registers[23] <= 32'b0;
            registers[24] <= 32'b0;
            registers[25] <= 32'b0;
            registers[26] <= 32'b0;
            registers[27] <= 32'b0;
            registers[28] <= 32'b0;
            registers[29] <= 32'b0;
            registers[30] <= 32'b0;
            registers[31] <= 32'b0;
            mtvec         <= 32'b0;
            mscratch      <= 32'b0;
            mepc          <= 32'b0;
            mcause        <= 32'b0;
            mstatus       <= 32'b0;
            mie           <= 32'b0;
            mip           <= 32'b0;
            mtime         <= 32'b0;
            mtimecmp      <= 32'b0;
        end
        else if (we1) begin
            if (waddr1[11:5] == 7'b0)
                registers[waddr1[4:0]] <= wdata1;
            else begin
                case (waddr1)
                    `REG_MSTATUS: mstatus <= wdata1;
                    `REG_MTVEC: mtvec <= wdata1;
                    `REG_MSCRATCH: mscratch <= wdata1;
                    `REG_MEPC: mepc <= wdata1;
                    `REG_MCAUSE: mcause <= wdata1;
                endcase
            end
        end
        else if (we2) begin
            case (waddr2)
                `REG_MSTATUS: mstatus <= wdata2;
                `REG_MTVEC: mtvec <= wdata2;
                `REG_MSCRATCH: mscratch <= wdata2;
                `REG_MEPC: mepc <= wdata2;
                `REG_MCAUSE: mcause <= wdata2;
            endcase
        end
        else if (we3) begin
            case (waddr3)
                `REG_MSTATUS: mstatus <= wdata3;
                `REG_MTVEC: mtvec <= wdata3;
                `REG_MSCRATCH: mscratch <= wdata3;
                `REG_MEPC: mepc <= wdata3;
                `REG_MCAUSE: mcause <= wdata3;
            endcase
        end
    end
    
    always @(*) begin
        if (raddr1 == 12'b0)
            rdata1 <= 32'b0;
        else if (raddr1 == waddr1 && we1)
            rdata1 <= wdata1;
        else if (raddr1 == waddr2 && we2)
            rdata1 <= wdata2;
        else if (raddr1 == waddr3 && we3)
            rdata1 <= wdata3;
        else begin
            if (raddr1[11:5] == 7'b0)
                rdata1 <= registers[raddr1[4:0]];
            else begin
                case (raddr1)
                    `REG_MSTATUS: rdata1 <= mstatus;
                    `REG_MTVEC: rdata1 <= mtvec;
                    `REG_MSCRATCH: rdata1 <= mscratch;
                    `REG_MEPC: rdata1 <= mepc;
                    `REG_MCAUSE: rdata1 <= mcause;
                endcase
            end
        end
    end
    
    always @(*) begin
        if (raddr2 == 12'b0)
            rdata2 <= 32'b0;
        else if (raddr2 == waddr1 && we1)
            rdata2 <= wdata1;
        else if (raddr2 == waddr2 && we2)
            rdata2 <= wdata2;
        else if (raddr2 == waddr3 && we3)
            rdata2 <= wdata3;
        else begin
            if (raddr2[11:5] == 7'b0)
                rdata2 <= registers[raddr2[4:0]];
            else begin
                case (raddr2)
                    `REG_MSTATUS: rdata2 <= mstatus;
                    `REG_MTVEC: rdata2 <= mtvec;
                    `REG_MSCRATCH: rdata2 <= mscratch;
                    `REG_MEPC: rdata2 <= mepc;
                    `REG_MCAUSE: rdata2 <= mcause;
                endcase
            end
        end
    end
endmodule
