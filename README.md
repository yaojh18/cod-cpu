Thinkpad Template Project
---------------
This is five-stage pipeline CPU developed on RISC-V Instruction Set. TLB supported.

### Module/file name and function

- thinpad_top.v: top-level module, defining signals, connecting modules, including some selectors (implemented with conditional expressions)
- control_signals: define some control signals (mainly define signals whose meaning cannot be read from variable names)
- Decoder (decoder.sv): Decode instructions, generate data and control signals
- RegFile(regfile.sv): register, the read part is combinational logic, and the write part is sequential logic (same as the multi-cycle sample code)
- ALU(alu.sv): operator (same as multi-cycle example code)
- SRAMUARTController(sram_uart_controller.sv): Control SRAM and UART read and write
- Pipeline registers
  - IF_ID_Register(IF_ID_reg.sv)
  - ID_EXE_Register(ID_EXE_reg.sv)
  - EXE_MEM_Register(EXE_MEM_reg.sv)
  - MEM_WB_Register(MEM_WB_reg.sv)

### plan the details

#### Signal naming

- The data stored in the pipeline registers should strictly specify its stage. Currently this part of the signal is named "stage name_variable name", for example, for signal branch, it is represented as id_branch in the ID stage and exe_branch in the EXE stage
- For temporary variables that exist only in one phase, do not use the above rules for naming

#### SRAM&UART Controller Design

- The SRAMUARTController module is connected to a 50MHz clock, and all other modules are connected to a 10MHz clock (generated by a phase-locked loop). The current SRAM&UART controller state machine design guarantees five 50MHz clock cycles, and completes one read/write state cycle within one 10MHz clock cycle, and supports continuous reading and writing of 10MHz clock cycles. The mem_mem_read signal can be set to a high level
- If you need to change the clock, assuming that the clock connected to the SRAMUARTController is n times the 10MHz clock (n must be an integer), please set the "wait_cycle_num" variable in the SRAMUARTController to n-4 to ensure that one read and write is completed within n clock cycles
- The memory and UART address mapping is the same as the monitor program, see the monitor program documentation for details
- UART read and write implementation requires loop detection of read and write status in the assembly. For details, please refer to Experiment 1, Question 4, and pay attention when writing test examples.
- For lb/sb instructions, unaligned addresses are supported, which will be converted by changing the be signal and shifting the data. For example, writing to address 0x80000005 will translate into writing the lower 8 bits of the register to the first byte of address 0x00000 in BaseRAM (counting from 0). **This part has not been strictly tested, and needs to be further tested and observed**

#### SRAM structure conflict implementation

- If data needs to be read/written in one clock cycle, the read instruction in the IF stage is postponed. The specific implementation method is to not add pc+4, and write 0x00000000 to the IF/ID register as the next instruction (add x0, x0, x0)



### update record

#### 2021.11.8 Basic Pipeline

- Complete the basic design of the pipeline, including the handling of SRAM structure conflicts
- Does not contain data conflict and control conflict handling
- Tested various types of instructions, the test cases do not contain data conflicts and control conflicts, see the test case file testcases/pipeline.s for details

#### 2021.11.9 Completed control conflict

- Does not use branch prediction, assumes that the branch fails, and clears the input of the first two stages (pc, id_pc, id_instruction) if a successful branch is encountered
- Added the variable branch_delay_rst as the signal of branch success. The branch_delay_rst_reg register is used to manage this signal. The same operation is done to the pipeline register in the IF_ID stage.

#### 2021.11.14 Completed data conflict

- Implemented the read-after-write operation, mainly modified the content of the ID_EXE_REG.sv file, and added several data bypasses to obtain the data in the rd register and the rd register used in MEM and WB
- mem_exe_reg_rd, wb_exe_reg_rd, mem_exe_alu_output, wb_exe_alu_output are responsible for storing these data,
- When using, first judge whether rs1 or rs2 is equal to mem_exe_reg_rd, and then judge whether it is equal to wb_exe_reg_rd, and use different data according to different results
- Implemented the data conflict problem of Lw. The method is to judge whether the exe_id_wb_type of the previous step is `WB_MEM, if so, set load_use_1 and load_use_2 to 1 and add bubbles
- The subsequent incoming load_use_in is combined with wb_exe_reg_rd to determine which register needs to use mem_exe_out_data