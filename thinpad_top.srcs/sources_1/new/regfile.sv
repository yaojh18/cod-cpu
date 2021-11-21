`default_nettype none
`timescale 1ns / 1ps

module RegFile(
    input wire          clk,
    input wire          rst,
    input wire          we,
    input wire[4:0]     waddr,
    input wire[31:0]    wdata,
    input wire          we_csr,
    input wire[11:0]    waddr_csr,
    input wire[31:0]    wdata_csr,
    
    input wire[4:0]     raddr1,
    input wire[4:0]     raddr2,
    output reg[31:0]    rdata1,
    output reg[31:0]    rdata2,
    input wire[11:0]    raddr_csr,
    output reg[31:0]    rdata_csr
    
    
    // add more registers if it's wirtable
    );
    reg[31:0] registers[0:31];
    reg[1:0]  status;
    reg[31:0] mtvec, mscratch, mepc, mcause, mstatus; // for exception
    reg[31:0] mie, mip, mtime, mtimecmp;              // for interruption
    reg[31:0] satp;                                   // for page table
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            registers[0] <= 32'h00000000;
            registers[1] <= 32'h00000000;
            registers[2] <= 32'h00000000;
            registers[3] <= 32'h00000000;
            registers[4] <= 32'h00000000;
            registers[5] <= 32'h00000000;
            registers[6] <= 32'h00000000;
            registers[7] <= 32'h00000000;
            registers[8] <= 32'h00000000;
            registers[9] <= 32'h00000000;
            registers[10] <= 32'h00000000;
            registers[11] <= 32'h00000000;
            registers[12] <= 32'h00000000;
            registers[13] <= 32'h00000000;
            registers[14] <= 32'h00000000;
            registers[15] <= 32'h00000000;
            registers[16] <= 32'h00000000;
            registers[17] <= 32'h00000000;
            registers[18] <= 32'h00000000;
            registers[19] <= 32'h00000000;
            registers[20] <= 32'h00000000;
            registers[21] <= 32'h00000000;
            registers[22] <= 32'h00000000;
            registers[23] <= 32'h00000000;
            registers[24] <= 32'h00000000;
            registers[25] <= 32'h00000000;
            registers[26] <= 32'h00000000;
            registers[27] <= 32'h00000000;
            registers[28] <= 32'h00000000;
            registers[29] <= 32'h00000000;
            registers[30] <= 32'h00000000;
            registers[31] <= 32'h00000000;
            mtvec         <= 32'b0;
            mscratch      <= 32'b0;
            mepc          <= 32'b0;
            mcause        <= 32'b0;
            mstatus       <= 32'b0;
            mie           <= 32'b0;
            mip           <= 32'b0;
            mtime         <= 32'b0;
            mtimecmp      <= 32'b0;
            status        <= 2'b11;
        end
        else if (we)
            registers[waddr] <= wdata;
        else if (we_csr)
            case (waddr_csr)
                `REG_MSTATUS:   mstatus <= wdata_csr;
                `REG_MTVEC:     mtvec <= wdata_csr;
                `REG_MSCRATCH:  mscratch <= wdata_csr;
                `REG_MEPC:      mepc <= wdata_csr;
                `REG_MCAUSE:    mcause <= wdata_csr;
                `REG_MIE:       mie <= wdata_csr;
                `REG_MIP:       mip <= wdata_csr;
                `REG_MTIME:     mtime <= wdata_csr;
                `REG_MTIMECMP:  mtimecmp <= wdata_csr;
                `REG_SATP:      satp <= wdata_csr;
            endcase
    end
    
    always @(*) begin
        if (raddr1 == 5'b0)
            rdata1 <= 32'b0;
        else if (raddr1 == waddr && we)
            rdata1 <= wdata;
        else
            rdata1 <= registers[raddr1];
    end
    
    always @(*) begin
        if (raddr2 == 5'b0)
            rdata2 <= 32'b0;
        else if (raddr2 == waddr && we)
            rdata2 <= wdata;
        else
            rdata2 <= registers[raddr2];
    end
    
    always @(*) begin
        if (raddr_csr == waddr_csr & we_csr)
            rdata_csr <= wdata_csr;
        else begin
            case (raddr_csr)
                `REG_MSTATUS:   rdata_csr <= mstatus;
                `REG_MTVEC:     rdata_csr <= mtvec;
                `REG_MSCRATCH:  rdata_csr <= mscratch;
                `REG_MEPC:      rdata_csr <= mepc;
                `REG_MCAUSE:    rdata_csr <= mcause;
                `REG_MIE:       rdata_csr <= mie;
                `REG_MIP:       rdata_csr <= mip;
                `REG_MTIME:     rdata_csr <= mtime;
                `REG_MTIMECMP:  rdata_csr <= mtimecmp;
                `REG_SATP:      rdata_csr <= satp;
            endcase
        end
    end
endmodule
