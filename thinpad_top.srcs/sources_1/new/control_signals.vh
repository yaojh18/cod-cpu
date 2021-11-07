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
`define ALU_SRA     4'b1001
`define ALU_ROL     4'b1010

// write back type
`define WB_ALU      2'b00
`define WB_MEM      2'b01
`define WB_PC       2'b10

// branch compare type
`define BEQ         1'b0
`define BNE         1'b1
