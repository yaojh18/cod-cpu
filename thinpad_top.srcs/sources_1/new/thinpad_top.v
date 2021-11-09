`default_nettype none
`include "control_signals.vh"

module thinpad_top(
    input wire clk_50M,           //50MHz 时钟输入
    input wire clk_11M0592,       //11.0592MHz 时钟输入（备用，可不用）

    input wire clock_btn,         //BTN5手动时钟按钮开关，带消抖电路，按下时为1
    input wire reset_btn,         //BTN6手动复位按钮开关，带消抖电路，按下时为1

    input  wire[3:0]  touch_btn,  //BTN1~BTN4，按钮开关，按下时为1
    input  wire[31:0] dip_sw,     //32位拨码开关，拨到“ON”时为1
    output wire[15:0] leds,       //16位LED，输出时1点亮
    output wire[7:0]  dpy0,       //数码管低位信号，包括小数点，输出1点亮
    output wire[7:0]  dpy1,       //数码管高位信号，包括小数点，输出1点亮

    //CPLD串口控制器信号
    output wire uart_rdn,         //读串口信号，低有效
    output wire uart_wrn,         //写串口信号，低有效
    input wire uart_dataready,    //串口数据准备好
    input wire uart_tbre,         //发送数据标志
    input wire uart_tsre,         //数据发送完毕标志

    //BaseRAM信号
    inout wire[31:0] base_ram_data,  //BaseRAM数据，低8位与CPLD串口控制器共享
    output wire[19:0] base_ram_addr, //BaseRAM地址
    output wire[3:0] base_ram_be_n,  //BaseRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output wire base_ram_ce_n,       //BaseRAM片选，低有效
    output wire base_ram_oe_n,       //BaseRAM读使能，低有效
    output wire base_ram_we_n,       //BaseRAM写使能，低有效

    //ExtRAM信号
    inout wire[31:0] ext_ram_data,  //ExtRAM数据
    output wire[19:0] ext_ram_addr, //ExtRAM地址
    output wire[3:0] ext_ram_be_n,  //ExtRAM字节使能，低有效。如果不使用字节使能，请保持为0
    output wire ext_ram_ce_n,       //ExtRAM片选，低有效
    output wire ext_ram_oe_n,       //ExtRAM读使能，低有效
    output wire ext_ram_we_n,       //ExtRAM写使能，低有效

    //直连串口信号
    output wire txd,  //直连串口发送端
    input  wire rxd,  //直连串口接收端

    //Flash存储器信号，参考 JS28F640 芯片手册
    output wire [22:0]flash_a,      //Flash地址，a0仅在8bit模式有效，16bit模式无意义
    inout  wire [15:0]flash_d,      //Flash数据
    output wire flash_rp_n,         //Flash复位信号，低有效
    output wire flash_vpen,         //Flash写保护信号，低电平时不能擦除、烧写
    output wire flash_ce_n,         //Flash片选信号，低有效
    output wire flash_oe_n,         //Flash读使能信号，低有效
    output wire flash_we_n,         //Flash写使能信号，低有效
    output wire flash_byte_n,       //Flash 8bit模式选择，低有效。在使用flash的16位模式时请设为1

    //USB 控制器信号，参考 SL811 芯片手册
    output wire sl811_a0,
    //inout  wire[7:0] sl811_d,     //USB数据线与网络控制器的dm9k_sd[7:0]共享
    output wire sl811_wr_n,
    output wire sl811_rd_n,
    output wire sl811_cs_n,
    output wire sl811_rst_n,
    output wire sl811_dack_n,
    input  wire sl811_intrq,
    input  wire sl811_drq_n,

    //网络控制器信号，参考 DM9000A 芯片手册
    output wire dm9k_cmd,
    inout  wire[15:0] dm9k_sd,
    output wire dm9k_iow_n,
    output wire dm9k_ior_n,
    output wire dm9k_cs_n,
    output wire dm9k_pwrst_n,
    input  wire dm9k_int,

    //图像输出信号
    output wire[2:0] video_red,    //红色像素，3位
    output wire[2:0] video_green,  //绿色像素，3位
    output wire[1:0] video_blue,   //蓝色像素，2位
    output wire video_hsync,       //行同步（水平同步）信号
    output wire video_vsync,       //场同步（垂直同步）信号
    output wire video_clk,         //像素时钟输出
    output wire video_de           //行数据有效信号，用于区分消隐区
);

// PLL分频示例
wire locked, clk_10M, clk_20M;
pll_example clock_gen 
 (
  // Clock in ports
  .clk_in1(clk_50M),  // 外部时钟输入
  // Clock out ports
  .clk_out1(clk_10M), // 时钟输出1，频率在IP配置界面中设置
  .clk_out2(clk_20M), // 时钟输出2，频率在IP配置界面中设置
  // Status and control signals
  .reset(reset_btn), // PLL复位输入
  .locked(locked)    // PLL锁定指示输出，"1"表示时钟稳定，
                     // 后级电路复位信号应当由它生成（见下）
 );

reg reset_of_clk10M;
// 异步复位，同步释放，将locked信号转为后级电路的复位reset_of_clk10M
always@(posedge clk_10M or negedge locked) begin
    if(~locked) reset_of_clk10M <= 1'b1;
    else        reset_of_clk10M <= 1'b0;
end

/* ============ pc and next pc ============ */
reg[31:0] pc;
wire[31:0] pc_next;

/* ============ IF/ID register ============ */
wire reset_if_id;
assign reset_if_id = reset_of_clk10M;
wire[31:0] if_instruction;
wire[31:0] id_instruction;
wire[31:0] id_pc;

/* =========== Decoder =========== */
wire[4:0]        id_reg_rs1;
wire[4:0]        id_reg_rs2;
wire[4:0]        id_reg_rd;
wire[31:0]       id_imm;
wire[3:0]        id_alu_op;
wire             id_pc_select;
wire             id_imm_select;
wire             id_branch;
wire             id_branch_comp; // ？
wire             id_jump;
wire             id_write_mem;
wire             id_read_mem;
wire             id_mem_byte; // ？
wire             id_write_back;
wire[1:0]        id_wb_type;

/* =========== Register file =========== */
wire[31:0] id_reg_rdata1;
wire[31:0] id_reg_rdata2;
wire id_branch_choice;
// branch_comp: 0: beq, 1: bne
assign id_branch_choice = (id_branch_comp==`BNE) ? ~(id_reg_rdata1 == id_reg_rdata2) : (id_reg_rdata1 == id_reg_rdata2);

/* =========== ID/EXE register ========== */
wire          reset_id_exe;
assign reset_id_exe = reset_of_clk10M;
wire[4:0]     exe_reg_rs1;
wire[4:0]     exe_reg_rs2;
wire[4:0]     exe_reg_rd;
wire[31:0]    exe_imm;
wire[31:0]    exe_reg_rdata1;
wire[31:0]    exe_reg_rdata2;
wire[31:0]    exe_pc;
wire[3:0]     exe_alu_op;
wire          exe_pc_select;
wire          exe_imm_select;
wire          exe_branch;
wire          exe_branch_choice;
wire          exe_jump;
wire          exe_write_mem;
wire          exe_read_mem;
wire          exe_mem_byte;
wire          exe_write_back;
wire[1:0]     exe_wb_type;

/* =========== ALU ============*/
wire[31:0]      alu_input1;
wire[31:0]      alu_input2;
wire[31:0]      exe_alu_output;
wire[3:0]       exe_alu_flags;
assign alu_input1 = exe_pc_select ? exe_pc : exe_reg_rdata1;
assign alu_input2 = exe_imm_select ? exe_imm : exe_reg_rdata2;

/* =========== EXE/MEM register ============ */
wire          reset_exe_mem;
assign reset_exe_mem = reset_of_clk10M ;
wire[31:0]    exe_mem_data_in;
assign exe_mem_data_in = exe_reg_rdata2;
wire[4:0]     mem_reg_rs1;
wire[4:0]     mem_reg_rs2;
wire[4:0]     mem_reg_rd;
wire[31:0]    mem_alu_output;
wire[31:0]    mem_mem_data_in;
wire[31:0]    mem_pc;
wire          mem_write_mem;
wire          mem_read_mem;
wire          mem_mem_byte;
wire          mem_write_back;
wire[1:0]     mem_wb_type;

/* =========== SRAM UART =========== */
wire        mem_oe;
wire        mem_we;
wire[3:0]   mem_be;
wire[31:0]  mem_address;
wire[31:0]  mem_mem_data_out;
wire        mem_done;
assign mem_oe = ~mem_done;  // always enabled if not done, because always need to get instruction
assign mem_we = mem_write_mem & (~mem_done);
assign mem_be = mem_mem_byte ? 4'b0001 : 4'b1111;
assign mem_address = (mem_read_mem | mem_write_mem) ? mem_alu_output : pc;

/* =========== MEM/WB register ============ */
wire          reset_mem_wb;
assign reset_mem_wb = reset_of_clk10M;
wire[4:0]     wb_reg_rd;
wire[31:0]    wb_alu_output;
wire[31:0]    wb_mem_data_out;
wire[31:0]    wb_pc;
wire          wb_write_back;
wire[1:0]     wb_wb_type;

/* =========== Register file write back =========== */
wire[31:0]    reg_wdata;
assign reg_wdata = wb_wb_type==`WB_ALU ? wb_alu_output : (wb_wb_type==`WB_MEM ? wb_mem_data_out : wb_pc+4);

/* ================== IF module =================== */
wire branch_delay_rst;
reg branch_delay_rst_reg;
assign  branch_delay_rst = id_jump | (id_branch & id_branch_choice);
assign pc_next = (exe_jump | (exe_branch & exe_branch_choice)) ? exe_alu_output : ((mem_write_mem | mem_read_mem) ? pc : pc+4);
assign if_instruction = (mem_write_mem | mem_read_mem | pc == 0) ? 32'h13 : mem_mem_data_out;

always @(posedge clk_10M or posedge reset_of_clk10M) begin
    if(reset_of_clk10M) begin
        branch_delay_rst_reg <= 1'b0;
        pc <= 32'h80000000;
    end
    else
        if (~branch_delay_rst_reg & branch_delay_rst) begin
            branch_delay_rst_reg <= 1'b1;
            pc <= 32'h0;
        end
        else begin
            if (branch_delay_rst_reg & ~branch_delay_rst_reg)
                branch_delay_rst_reg <= 1'b0;
            pc <= pc_next;
        end
end
/* ================ IF module end ================= */

IF_ID_Register if_id_reg(
    .clk(clk_10M),
    .rst(reset_if_id),
    .delay_rst(branch_delay_rst),
    .if_instruction(if_instruction),
    .if_pc(pc),
    .id_instruction(id_instruction),
    .id_pc(id_pc)
);

Decoder decoder(
    .inst(id_instruction),
    .reg_rs1(id_reg_rs1),
    .reg_rs2(id_reg_rs2),
    .reg_rd(id_reg_rd),
    .imm(id_imm),
    .alu_op(id_alu_op),
    .pc_select(id_pc_select),
    .imm_select(id_imm_select),
    .branch(id_branch),
    .branch_comp(id_branch_comp),
    .jump(id_jump),
    .write_mem(id_write_mem),
    .read_mem(id_read_mem),
    .mem_byte(id_mem_byte),
    .write_back(id_write_back),
    .wb_type(id_wb_type)
);

RegFile reg_file(
    .clk(clk_10M),
    .rst(reset_of_clk10M),
    .we(wb_write_back),
    .waddr(wb_reg_rd),
    .wdata(reg_wdata),
    .raddr1(id_reg_rs1),
    .raddr2(id_reg_rs2),
    .rdata1(id_reg_rdata1),
    .rdata2(id_reg_rdata2)
);

ID_EXE_Register id_exe_reg(
    .clk(clk_10M),
    .rst(reset_id_exe),
    .id_reg_rs1(id_reg_rs1),
    .id_reg_rs2(id_reg_rs2),
    .id_reg_rd(id_reg_rd),
    .id_imm(id_imm),
    .id_reg_rdata1(id_reg_rdata1),
    .id_reg_rdata2(id_reg_rdata2),
    .id_pc(id_pc),
    .id_alu_op(id_alu_op),
    .id_pc_select(id_pc_select),
    .id_imm_select(id_imm_select),
    .id_branch(id_branch),
    .id_branch_choice(id_branch_choice),
    .id_jump(id_jump),
    .id_write_mem(id_write_mem),
    .id_read_mem(id_read_mem),
    .id_mem_byte(id_mem_byte),
    .id_write_back(id_write_back),
    .id_wb_type(id_wb_type),
    .exe_reg_rs1(exe_reg_rs1),
    .exe_reg_rs2(exe_reg_rs2),
    .exe_reg_rd(exe_reg_rd),
    .exe_imm(exe_imm),
    .exe_reg_rdata1(exe_reg_rdata1),
    .exe_reg_rdata2(exe_reg_rdata2),
    .exe_pc(exe_pc),
    .exe_alu_op(exe_alu_op),
    .exe_pc_select(exe_pc_select),
    .exe_imm_select(exe_imm_select),
    .exe_branch(exe_branch),
    .exe_branch_choice(exe_branch_choice),
    .exe_jump(exe_jump),
    .exe_write_mem(exe_write_mem),
    .exe_read_mem(exe_read_mem),
    .exe_mem_byte(exe_mem_byte),
    .exe_write_back(exe_write_back),
    .exe_wb_type(exe_wb_type)
);

ALU alu(
    .op(exe_alu_op),
    .a(alu_input1),
    .b(alu_input2),
    .r(exe_alu_output),
    .flags(exe_alu_flags)
);

EXE_MEM_Register exe_mem_reg(
    .clk(clk_10M),
    .rst(reset_exe_mem),
    .exe_reg_rs1(exe_reg_rs1),
    .exe_reg_rs2(exe_reg_rs2),
    .exe_reg_rd(exe_reg_rd),
    .exe_alu_output(exe_alu_output),
    .exe_mem_data_in(exe_mem_data_in),
    .exe_pc(exe_pc),
    .exe_write_mem(exe_write_mem),
    .exe_read_mem(exe_read_mem),
    .exe_mem_byte(exe_mem_byte),
    .exe_write_back(exe_write_back),
    .exe_wb_type(exe_wb_type),
    .mem_reg_rs1(mem_reg_rs1),
    .mem_reg_rs2(mem_reg_rs2),
    .mem_reg_rd(mem_reg_rd),
    .mem_alu_output(mem_alu_output),
    .mem_mem_data_in(mem_mem_data_in),
    .mem_pc(mem_pc),
    .mem_write_mem(mem_write_mem),
    .mem_read_mem(mem_read_mem),
    .mem_mem_byte(mem_mem_byte),
    .mem_write_back(mem_write_back),
    .mem_wb_type(mem_wb_type)
);

SRAMUARTController sram_uart_controller(
    .clk(clk_50M),
    .rst(reset_of_clk10M),
    
    .oe(mem_oe),
    .we(mem_we),
    .be(mem_be),
    
    .address(mem_address),
    .in_data(mem_mem_data_in),
    .out_data(mem_mem_data_out),
    .done(mem_done),
    
    .uart_rdn(uart_rdn),
    .uart_wrn(uart_wrn),
    .uart_dataready(uart_dataready),
    .uart_tbre(uart_tbre),
    .uart_tsre(uart_tsre),
    
    .base_ram_data_wire(base_ram_data),
    .base_ram_addr(base_ram_addr),
    .base_ram_be_n(base_ram_be_n),
    .base_ram_ce_n(base_ram_ce_n),
    .base_ram_oe_n(base_ram_oe_n),
    .base_ram_we_n(base_ram_we_n),
    
    .ext_ram_data_wire(ext_ram_data),
    .ext_ram_addr(ext_ram_addr),
    .ext_ram_be_n(ext_ram_be_n),
    .ext_ram_ce_n(ext_ram_ce_n),
    .ext_ram_oe_n(ext_ram_oe_n),
    .ext_ram_we_n(ext_ram_we_n)
);

MEM_WB_Register mem_wb_reg(
    .clk(clk_10M),
    .rst(reset_mem_wb),
    .mem_reg_rd(mem_reg_rd),
    .mem_alu_output(mem_alu_output),
    .mem_mem_data_out(mem_mem_data_out),
    .mem_pc(mem_pc),
    .mem_write_back(mem_write_back),
    .mem_wb_type(mem_wb_type),
    .wb_reg_rd(wb_reg_rd),
    .wb_alu_output(wb_alu_output),
    .wb_mem_data_out(wb_mem_data_out),
    .wb_pc(wb_pc),
    .wb_write_back(wb_write_back),
    .wb_wb_type(wb_wb_type)
);


/* =========== Demo code begin =========== */

//always@(posedge clk_10M or posedge reset_of_clk10M) begin
//    if(reset_of_clk10M)begin
//        // Your Code
//    end
//    else begin
//        // Your Code
//    end
//end

// 不使用内存、串口时，禁用其使能信号
//assign base_ram_ce_n = 1'b1;
//assign base_ram_oe_n = 1'b1;
//assign base_ram_we_n = 1'b1;

//assign ext_ram_ce_n = 1'b1;
//assign ext_ram_oe_n = 1'b1;
//assign ext_ram_we_n = 1'b1;

//assign uart_rdn = 1'b1;
//assign uart_wrn = 1'b1;

// 数码管连接关系示意图，dpy1同理
// p=dpy0[0] // ---a---
// c=dpy0[1] // |     |
// d=dpy0[2] // f     b
// e=dpy0[3] // |     |
// b=dpy0[4] // ---g---
// a=dpy0[5] // |     |
// f=dpy0[6] // e     c
// g=dpy0[7] // |     |
//           // ---d---  p

// 7段数码管译码器演示，将number用16进制显示在数码管上面
//wire[7:0] number;
//SEG7_LUT segL(.oSEG1(dpy0), .iDIG(number[3:0])); //dpy0是低位数码管
//SEG7_LUT segH(.oSEG1(dpy1), .iDIG(number[7:4])); //dpy1是高位数码管

//reg[15:0] led_bits;
//assign leds = led_bits;

//always@(posedge clock_btn or posedge reset_btn) begin
//    if(reset_btn)begin //复位按下，设置LED为初始值
//        led_bits <= 16'h1;
//    end
//    else begin //每次按下时钟按钮，LED循环左移
//        led_bits <= {led_bits[14:0],led_bits[15]};
//    end
//end

//直连串口接收发送演示，从直连串口收到的数据再发送出去
//wire [7:0] ext_uart_rx;
//reg  [7:0] ext_uart_buffer, ext_uart_tx;
//wire ext_uart_ready, ext_uart_clear, ext_uart_busy;
//reg ext_uart_start, ext_uart_avai;
    
//assign number = ext_uart_buffer;

//async_receiver #(.ClkFrequency(50000000),.Baud(9600)) //接收模块，9600无检验位
//    ext_uart_r(
//        .clk(clk_50M),                       //外部时钟信号
//        .RxD(rxd),                           //外部串行信号输入
//        .RxD_data_ready(ext_uart_ready),  //数据接收到标志
//        .RxD_clear(ext_uart_clear),       //清除接收标志
//        .RxD_data(ext_uart_rx)             //接收到的一字节数据
//    );

//assign ext_uart_clear = ext_uart_ready; //收到数据的同时，清除标志，因为数据已取到ext_uart_buffer中
//always @(posedge clk_50M) begin //接收到缓冲区ext_uart_buffer
//    if(ext_uart_ready)begin
//        ext_uart_buffer <= ext_uart_rx;
//        ext_uart_avai <= 1;
//    end else if(!ext_uart_busy && ext_uart_avai)begin 
//        ext_uart_avai <= 0;
//    end
//end
//always @(posedge clk_50M) begin //将缓冲区ext_uart_buffer发送出去
//    if(!ext_uart_busy && ext_uart_avai)begin 
//        ext_uart_tx <= ext_uart_buffer;
//        ext_uart_start <= 1;
//    end else begin 
//        ext_uart_start <= 0;
//    end
//end

//async_transmitter #(.ClkFrequency(50000000),.Baud(9600)) //发送模块，9600无检验位
//    ext_uart_t(
//        .clk(clk_50M),                  //外部时钟信号
//        .TxD(txd),                      //串行信号输出
//        .TxD_busy(ext_uart_busy),       //发送器忙状态指示
//        .TxD_start(ext_uart_start),    //开始发送信号
//        .TxD_data(ext_uart_tx)        //待发送的数据
//    );

//图像输出演示，分辨率800x600@75Hz，像素时钟为50MHz
//wire [11:0] hdata;
//assign video_red = hdata < 266 ? 3'b111 : 0; //红色竖条
//assign video_green = hdata < 532 && hdata >= 266 ? 3'b111 : 0; //绿色竖条
//assign video_blue = hdata >= 532 ? 2'b11 : 0; //蓝色竖条
//assign video_clk = clk_50M;
//vga #(12, 800, 856, 976, 1040, 600, 637, 643, 666, 1, 1) vga800x600at75 (
//    .clk(clk_50M), 
//    .hdata(hdata), //横坐标
//    .vdata(),      //纵坐标
//    .hsync(video_hsync),
//    .vsync(video_vsync),
//    .data_enable(video_de)
//);
/* =========== Demo code end =========== */

endmodule
