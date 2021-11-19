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
`define WB_ALU      3'b000
`define WB_MEM      3'b001
`define WB_PC_PLUS  3'b010
`define WB_PC       3'b011
`define WB_REG1     3'b100
`define WB_REG2     3'b101

// branch compare type
`define BEQ         1'b0
`define BNE         1'b1

`define REG_MSTATUS 12'h300
`define REG_MTVEC 12'h305
`define REG_MSCRATCH 12'h340
`define REG_MEPC 12'h341
`define REG_MCAUSE 12'h342

