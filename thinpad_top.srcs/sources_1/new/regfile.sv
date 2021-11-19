`default_nettype none
`timescale 1ns / 1ps

module RegFile(
    input wire          clk,
    input wire          rst,
    input wire          we,
    input wire[11:0]    waddr,
    input wire[31:0]    wdata,
    
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
            registers[0] <= 32'b0;
            registers[1] <= 32'b0;
            registers[2] <= 32'b0;
            registers[3] <= 32'b0;
            registers[4] <= 32'b0;
            registers[5] <= 32'b0;
            registers[6] <= 32'b0;
            registers[7] <= 32'b0;
            registers[8] <= 32'b0;
            registers[9] <= 32'b0;
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
        else if (we)
            registers[waddr[4:0]] <= wdata;
    end
    
    always @(*) begin
        if (raddr1 == 12'b0)
            rdata1 <= 32'b0;
        else if (raddr1 == waddr && we)
            rdata1 <= wdata;
        else
            rdata1 <= registers[raddr1[4:0]];
    end
    
    always @(*) begin
        if (raddr2 == 12'b0)
            rdata2 <= 32'b0;
        else if (raddr2 == waddr && we)
            rdata2 <= wdata;
        else
            rdata2 <= registers[raddr2[4:0]];
    end
endmodule
