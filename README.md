Thinpad 模板工程
---------------

工程包含示例代码和所有引脚约束，可以直接编译。

代码中包含中文注释，编码为utf-8，在Windows版Vivado下可能出现乱码问题。  
请用别的代码编辑器打开文件，并将编码改为GBK。

### 测例编译工具

testcases文件夹中为汇编测例，在文件夹中加入.s汇编代码，并在linux（wsl）下运行./compile.sh <文件名>（注：文件名不要包含“.s”），可自动生成同名文件夹，并进行编译、将二进制文件反编译成汇编、转换成4M大小的bin文件操作，其中4M大小的bin文件命名为code_4M.bin，在tb.sv中修改路径即可加载。

### 模块/文件名称及功能

- thinpad_top.v：顶层模块，定义信号，连接各模块，包含一些选择器（用条件表达式实现）
- control_signals：定义部分控制信号（主要定义无法从变量名读出意义的信号）
- Decoder(decoder.sv)：解码指令，生成数据和控制信号
- RegFile(regfile.sv)：寄存器，读出部分为组合逻辑，写入部分为时序逻辑（与多周期示例代码相同）
- ALU(alu.sv)：运算器（与多周期示例代码相同）
- SRAMUARTController(sram_uart_controller.sv)：控制SRAM和UART读写
- 流水线寄存器
  - IF_ID_Register(IF_ID_reg.sv)
  - ID_EXE_Register(ID_EXE_reg.sv)
  - EXE_MEM_Register(EXE_MEM_reg.sv)
  - MEM_WB_Register(MEM_WB_reg.sv)

### 设计细节

#### 信号命名

- 储存在流水线寄存器中的数据应严格指明其所在阶段。当前该部分信号命名为“阶段名_变量名”，例如，对于信号branch，ID阶段中表示为id_branch，EXE阶段中表示为exe_branch
- 对于仅在一个阶段存在的临时变量，不使用上述规律命名

#### SRAM&UART控制器设计

- SRAMUARTController模块连接50MHz时钟，其他所有模块连接10MHz时钟（锁相环生成）。当前SRAM&UART控制器状态机设计保证5个50MHz时钟周期，且对应1个10MHz时钟周期内完成一次读/写状态循环，并且支持连续的10MHz时钟周期的读写，在需要读写的周期将mem_mem_write或mem_mem_read信号设置为高电平即可
- 若需要改变时钟，假设SRAMUARTController连接的时钟为10MHz时钟的n倍（n须为整数），请将SRAMUARTController中的“wait_cycle_num”变量设置为n-4，以保证n个时钟周期内完成一次读写
- 内存与UART地址映射与监控程序相同，详见监控程序文档
- UART读写实现要求在汇编中通过循环检测读写状态，详见实验1思考题4，在编写测例时需要注意
- 对于lb/sb指令，支持非对齐的地址，会通过改变be信号，并对数据进行移位来进行换算。例如，写入0x80000005地址，将换算为将寄存器低8位写入BaseRAM的0x00000地址的第1个字节（从0开始计数）。**该部分没有严格测试过，需要后续进一步测试观察**

#### SRAM结构冲突实现

- 若在一个时钟周期中需要读/写数据，则推迟IF阶段的读指令，具体实现方式为不将pc+4，并向IF/ID寄存器写入0x00000000作为下一条指令（add x0, x0, x0）



### 更新记录

#### 2021.11.8 基本流水线

- 完成流水线基础设计，包含对SRAM结构冲突的处理
- 不包含数据冲突和控制冲突处理
- 测试了各类型指令，测例中不包含数据冲突和控制冲突，详见测例文件testcases/pipeline.s
