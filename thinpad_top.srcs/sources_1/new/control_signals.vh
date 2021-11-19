// alu_op
`define ALU_ZERO    4'b0000 
`define ALU_ADD     4'b0001
`define ALU_SUB     4'b0010
`define ALU_AND     4'b0011
`define ALU_OR      4'b0100
`define ALU_XOR     4'b0101
`define ALU_NOT     4'b0110
`define ALU_SLL     4'b0111
`define ALU_SRL     4'b1000
`define ALU_LTU     4'b1001
`define ALU_PACK    4'b1010
`define ALU_SBSET   4'b1011
`define ALU_CLZ     4'b1100

// write back type
`define WB_ALU      2'b00
`define WB_MEM      2'b01
`define WB_PC       2'b10

// branch compare type
`define BEQ         1'b0
`define BNE         1'b1

`define REG_MSTATUS 12'h300
`define REG_MTVEC 12'h305
`define REG_MSCRATCH 12'h340
`define REG_MEPC 12'h341
`define REG_MCAUSE 12'h342

