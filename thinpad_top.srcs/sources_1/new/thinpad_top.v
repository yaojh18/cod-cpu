`default_nettype none
`include "control_signals.vh"

module thinpad_top(
    input wire clk_50M,           //50MHz ʱ������
    input wire clk_11M0592,       //11.0592MHz ʱ�����루���ã��ɲ��ã�

    input wire clock_btn,         //BTN5�ֶ�ʱ�Ӱ�ť���أ���������·������ʱΪ1
    input wire reset_btn,         //BTN6�ֶ���λ��ť���أ���������·������ʱΪ1

    input  wire[3:0]  touch_btn,  //BTN1~BTN4����ť���أ�����ʱΪ1
    input  wire[31:0] dip_sw,     //32λ���뿪�أ�������ON��ʱΪ1
    output wire[15:0] leds,       //16λLED�����ʱ1����
    output wire[7:0]  dpy0,       //����ܵ�λ�źţ�����С���㣬���1����
    output wire[7:0]  dpy1,       //����ܸ�λ�źţ�����С���㣬���1����

    //CPLD���ڿ������ź�
    output wire uart_rdn,         //�������źţ�����Ч
    output wire uart_wrn,         //д�����źţ�����Ч
    input wire uart_dataready,    //��������׼����
    input wire uart_tbre,         //�������ݱ�־
    input wire uart_tsre,         //���ݷ�����ϱ�־

    //BaseRAM�ź�
    inout wire[31:0] base_ram_data,  //BaseRAM���ݣ���8λ��CPLD���ڿ���������
    output wire[19:0] base_ram_addr, //BaseRAM��ַ
    output wire[3:0] base_ram_be_n,  //BaseRAM�ֽ�ʹ�ܣ�����Ч�������ʹ���ֽ�ʹ�ܣ��뱣��Ϊ0
    output wire base_ram_ce_n,       //BaseRAMƬѡ������Ч
    output wire base_ram_oe_n,       //BaseRAM��ʹ�ܣ�����Ч
    output wire base_ram_we_n,       //BaseRAMдʹ�ܣ�����Ч

    //ExtRAM�ź�
    inout wire[31:0] ext_ram_data,  //ExtRAM����
    output wire[19:0] ext_ram_addr, //ExtRAM��ַ
    output wire[3:0] ext_ram_be_n,  //ExtRAM�ֽ�ʹ�ܣ�����Ч�������ʹ���ֽ�ʹ�ܣ��뱣��Ϊ0
    output wire ext_ram_ce_n,       //ExtRAMƬѡ������Ч
    output wire ext_ram_oe_n,       //ExtRAM��ʹ�ܣ�����Ч
    output wire ext_ram_we_n,       //ExtRAMдʹ�ܣ�����Ч

    //ֱ�������ź�
    output wire txd,  //ֱ�����ڷ��Ͷ�
    input  wire rxd,  //ֱ�����ڽ��ն�

    //Flash�洢���źţ��ο� JS28F640 оƬ�ֲ�
    output wire [22:0]flash_a,      //Flash��ַ��a0����8bitģʽ��Ч��16bitģʽ������
    inout  wire [15:0]flash_d,      //Flash����
    output wire flash_rp_n,         //Flash��λ�źţ�����Ч
    output wire flash_vpen,         //Flashд�����źţ��͵�ƽʱ���ܲ�������д
    output wire flash_ce_n,         //FlashƬѡ�źţ�����Ч
    output wire flash_oe_n,         //Flash��ʹ���źţ�����Ч
    output wire flash_we_n,         //Flashдʹ���źţ�����Ч
    output wire flash_byte_n,       //Flash 8bitģʽѡ�񣬵���Ч����ʹ��flash��16λģʽʱ����Ϊ1

    //USB �������źţ��ο� SL811 оƬ�ֲ�
    output wire sl811_a0,
    //inout  wire[7:0] sl811_d,     //USB�������������������dm9k_sd[7:0]����
    output wire sl811_wr_n,
    output wire sl811_rd_n,
    output wire sl811_cs_n,
    output wire sl811_rst_n,
    output wire sl811_dack_n,
    input  wire sl811_intrq,
    input  wire sl811_drq_n,

    //����������źţ��ο� DM9000A оƬ�ֲ�
    output wire dm9k_cmd,
    inout  wire[15:0] dm9k_sd,
    output wire dm9k_iow_n,
    output wire dm9k_ior_n,
    output wire dm9k_cs_n,
    output wire dm9k_pwrst_n,
    input  wire dm9k_int,

    //ͼ������ź�
    output wire[2:0] video_red,    //��ɫ���أ�3λ
    output wire[2:0] video_green,  //��ɫ���أ�3λ
    output wire[1:0] video_blue,   //��ɫ���أ�2λ
    output wire video_hsync,       //��ͬ����ˮƽͬ�����ź�
    output wire video_vsync,       //��ͬ������ֱͬ�����ź�
    output wire video_clk,         //����ʱ�����
    output wire video_de           //��������Ч�źţ���������������
);

// PLL��Ƶʾ��
wire locked, clk_10M, clk_20M;
pll_example clock_gen 
 (
  // Clock in ports
  .clk_in1(clk_50M),  // �ⲿʱ������
  // Clock out ports
  .clk_out1(clk_10M), // ʱ�����1��Ƶ����IP���ý���������
  .clk_out2(clk_20M), // ʱ�����2��Ƶ����IP���ý���������
  // Status and control signals
  .reset(reset_btn), // PLL��λ����
  .locked(locked)    // PLL����ָʾ�����"1"��ʾʱ���ȶ���
                     // �󼶵�·��λ�ź�Ӧ���������ɣ����£�
 );

reg reset_of_clk10M;
// �첽��λ��ͬ���ͷţ���locked�ź�תΪ�󼶵�·�ĸ�λreset_of_clk10M
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
wire             id_branch_comp;
wire             id_jump;
wire             id_write_mem;
wire             id_read_mem;
wire             id_mem_byte;
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
assign reset_exe_mem = reset_of_clk10M;
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
/* ================ forward part================= */
wire[4:0]     mem_exe_reg_rd;
assign mem_exe_reg_rd = mem_reg_rd;
wire[4:0]     wb_exe_reg_rd;
assign wb_exe_reg_rd = wb_reg_rd;
wire[31:0]     mem_exe_alu_output;
assign mem_exe_alu_output = mem_alu_output;
wire[31:0]     wb_exe_alu_output;
assign wb_exe_alu_output = wb_alu_output;

ID_EXE_Register id_exe_reg(
    .clk(clk_10M),
    .rst(reset_id_exe),
    .id_reg_rs1(id_reg_rs1),
    .id_reg_rs2(id_reg_rs2),
    .id_reg_rd(id_reg_rd),
    .mem_exe_reg_rd(mem_exe_reg_rd),
    .wb_exe_reg_rd(wb_exe_reg_rd),
    .mem_exe_alu_output(mem_exe_alu_output),
    .wb_exe_alu_output(wb_exe_alu_output),
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

// ��ʹ���ڴ桢����ʱ��������ʹ���ź�
//assign base_ram_ce_n = 1'b1;
//assign base_ram_oe_n = 1'b1;
//assign base_ram_we_n = 1'b1;

//assign ext_ram_ce_n = 1'b1;
//assign ext_ram_oe_n = 1'b1;
//assign ext_ram_we_n = 1'b1;

//assign uart_rdn = 1'b1;
//assign uart_wrn = 1'b1;

// ��������ӹ�ϵʾ��ͼ��dpy1ͬ��
// p=dpy0[0] // ---a---
// c=dpy0[1] // |     |
// d=dpy0[2] // f     b
// e=dpy0[3] // |     |
// b=dpy0[4] // ---g---
// a=dpy0[5] // |     |
// f=dpy0[6] // e     c
// g=dpy0[7] // |     |
//           // ---d---  p

// 7���������������ʾ����number��16������ʾ�����������
//wire[7:0] number;
//SEG7_LUT segL(.oSEG1(dpy0), .iDIG(number[3:0])); //dpy0�ǵ�λ�����
//SEG7_LUT segH(.oSEG1(dpy1), .iDIG(number[7:4])); //dpy1�Ǹ�λ�����

//reg[15:0] led_bits;
//assign leds = led_bits;

//always@(posedge clock_btn or posedge reset_btn) begin
//    if(reset_btn)begin //��λ���£�����LEDΪ��ʼֵ
//        led_bits <= 16'h1;
//    end
//    else begin //ÿ�ΰ���ʱ�Ӱ�ť��LEDѭ������
//        led_bits <= {led_bits[14:0],led_bits[15]};
//    end
//end

//ֱ�����ڽ��շ�����ʾ����ֱ�������յ��������ٷ��ͳ�ȥ
//wire [7:0] ext_uart_rx;
//reg  [7:0] ext_uart_buffer, ext_uart_tx;
//wire ext_uart_ready, ext_uart_clear, ext_uart_busy;
//reg ext_uart_start, ext_uart_avai;
    
//assign number = ext_uart_buffer;

//async_receiver #(.ClkFrequency(50000000),.Baud(9600)) //����ģ�飬9600�޼���λ
//    ext_uart_r(
//        .clk(clk_50M),                       //�ⲿʱ���ź�
//        .RxD(rxd),                           //�ⲿ�����ź�����
//        .RxD_data_ready(ext_uart_ready),  //���ݽ��յ���־
//        .RxD_clear(ext_uart_clear),       //������ձ�־
//        .RxD_data(ext_uart_rx)             //���յ���һ�ֽ�����
//    );

//assign ext_uart_clear = ext_uart_ready; //�յ����ݵ�ͬʱ�������־����Ϊ������ȡ��ext_uart_buffer��
//always @(posedge clk_50M) begin //���յ�������ext_uart_buffer
//    if(ext_uart_ready)begin
//        ext_uart_buffer <= ext_uart_rx;
//        ext_uart_avai <= 1;
//    end else if(!ext_uart_busy && ext_uart_avai)begin 
//        ext_uart_avai <= 0;
//    end
//end
//always @(posedge clk_50M) begin //��������ext_uart_buffer���ͳ�ȥ
//    if(!ext_uart_busy && ext_uart_avai)begin 
//        ext_uart_tx <= ext_uart_buffer;
//        ext_uart_start <= 1;
//    end else begin 
//        ext_uart_start <= 0;
//    end
//end

//async_transmitter #(.ClkFrequency(50000000),.Baud(9600)) //����ģ�飬9600�޼���λ
//    ext_uart_t(
//        .clk(clk_50M),                  //�ⲿʱ���ź�
//        .TxD(txd),                      //�����ź����
//        .TxD_busy(ext_uart_busy),       //������æ״ָ̬ʾ
//        .TxD_start(ext_uart_start),    //��ʼ�����ź�
//        .TxD_data(ext_uart_tx)        //�����͵�����
//    );

//ͼ�������ʾ���ֱ���800x600@75Hz������ʱ��Ϊ50MHz
//wire [11:0] hdata;
//assign video_red = hdata < 266 ? 3'b111 : 0; //��ɫ����
//assign video_green = hdata < 532 && hdata >= 266 ? 3'b111 : 0; //��ɫ����
//assign video_blue = hdata >= 532 ? 2'b11 : 0; //��ɫ����
//assign video_clk = clk_50M;
//vga #(12, 800, 856, 976, 1040, 600, 637, 643, 666, 1, 1) vga800x600at75 (
//    .clk(clk_50M), 
//    .hdata(hdata), //������
//    .vdata(),      //������
//    .hsync(video_hsync),
//    .vsync(video_vsync),
//    .data_enable(video_de)
//);
/* =========== Demo code end =========== */

endmodule
