`timescale 1ns / 1ps
module tb;

wire clk_50M, clk_11M0592;

reg clock_btn = 0;         //BTN5ÊÖ¶¯Ê±ÖÓ°´Å¥¿ª¹Ø£¬´øÏû¶¶µçÂ·£¬°´ÏÂÊ±Îª1
reg reset_btn = 0;         //BTN6ÊÖ¶¯¸´Î»°´Å¥¿ª¹Ø£¬´øÏû¶¶µçÂ·£¬°´ÏÂÊ±Îª1

reg[3:0]  touch_btn;  //BTN1~BTN4£¬°´Å¥¿ª¹Ø£¬°´ÏÂÊ±Îª1
reg[31:0] dip_sw;     //32Î»²¦Âë¿ª¹Ø£¬²¦µ½¡°ON¡±Ê±Îª1

wire[15:0] leds;       //16Î»LED£¬Êä³öÊ±1µãÁÁ
wire[7:0]  dpy0;       //ÊıÂë¹ÜµÍÎ»ĞÅºÅ£¬°üÀ¨Ğ¡Êıµã£¬Êä³ö1µãÁÁ
wire[7:0]  dpy1;       //ÊıÂë¹Ü¸ßÎ»ĞÅºÅ£¬°üÀ¨Ğ¡Êıµã£¬Êä³ö1µãÁÁ

wire txd;  //Ö±Á¬´®¿Ú·¢ËÍ¶Ë
wire rxd;  //Ö±Á¬´®¿Ú½ÓÊÕ¶Ë

wire[31:0] base_ram_data; //BaseRAMÊı¾İ£¬µÍ8Î»ÓëCPLD´®¿Ú¿ØÖÆÆ÷¹²Ïí
wire[19:0] base_ram_addr; //BaseRAMµØÖ·
wire[3:0] base_ram_be_n;  //BaseRAM×Ö½ÚÊ¹ÄÜ£¬µÍÓĞĞ§¡£Èç¹û²»Ê¹ÓÃ×Ö½ÚÊ¹ÄÜ£¬Çë±£³ÖÎª0
wire base_ram_ce_n;       //BaseRAMÆ¬Ñ¡£¬µÍÓĞĞ§
wire base_ram_oe_n;       //BaseRAM¶ÁÊ¹ÄÜ£¬µÍÓĞĞ§
wire base_ram_we_n;       //BaseRAMĞ´Ê¹ÄÜ£¬µÍÓĞĞ§

wire[31:0] ext_ram_data; //ExtRAMÊı¾İ
wire[19:0] ext_ram_addr; //ExtRAMµØÖ·
wire[3:0] ext_ram_be_n;  //ExtRAM×Ö½ÚÊ¹ÄÜ£¬µÍÓĞĞ§¡£Èç¹û²»Ê¹ÓÃ×Ö½ÚÊ¹ÄÜ£¬Çë±£³ÖÎª0
wire ext_ram_ce_n;       //ExtRAMÆ¬Ñ¡£¬µÍÓĞĞ§
wire ext_ram_oe_n;       //ExtRAM¶ÁÊ¹ÄÜ£¬µÍÓĞĞ§
wire ext_ram_we_n;       //ExtRAMĞ´Ê¹ÄÜ£¬µÍÓĞĞ§

wire [22:0]flash_a;      //FlashµØÖ·£¬a0½öÔÚ8bitÄ£Ê½ÓĞĞ§£¬16bitÄ£Ê½ÎŞÒâÒå
wire [15:0]flash_d;      //FlashÊı¾İ
wire flash_rp_n;         //Flash¸´Î»ĞÅºÅ£¬µÍÓĞĞ§
wire flash_vpen;         //FlashĞ´±£»¤ĞÅºÅ£¬µÍµçÆ½Ê±²»ÄÜ²Á³ı¡¢ÉÕĞ´
wire flash_ce_n;         //FlashÆ¬Ñ¡ĞÅºÅ£¬µÍÓĞĞ§
wire flash_oe_n;         //Flash¶ÁÊ¹ÄÜĞÅºÅ£¬µÍÓĞĞ§
wire flash_we_n;         //FlashĞ´Ê¹ÄÜĞÅºÅ£¬µÍÓĞĞ§
wire flash_byte_n;       //Flash 8bitÄ£Ê½Ñ¡Ôñ£¬µÍÓĞĞ§¡£ÔÚÊ¹ÓÃflashµÄ16Î»Ä£Ê½Ê±ÇëÉèÎª1

wire uart_rdn;           //¶Á´®¿ÚĞÅºÅ£¬µÍÓĞĞ§
wire uart_wrn;           //Ğ´´®¿ÚĞÅºÅ£¬µÍÓĞĞ§
wire uart_dataready;     //´®¿ÚÊı¾İ×¼±¸ºÃ
wire uart_tbre;          //·¢ËÍÊı¾İ±êÖ¾
wire uart_tsre;          //Êı¾İ·¢ËÍÍê±Ï±êÖ¾

//WindowsĞèÒª×¢ÒâÂ·¾¶·Ö¸ô·ûµÄ×ªÒå£¬ÀıÈç"D:\\foo\\bar.bin"
parameter BASE_RAM_INIT_FILE = "E:\\pipeline\\testcases\\branch\\code_4M.bin"; //BaseRAM³õÊ¼»¯ÎÄ¼ş£¬ÇëĞŞ¸ÄÎªÊµ¼ÊµÄ¾ø¶ÔÂ·¾¶
parameter EXT_RAM_INIT_FILE = "/tmp/eram.bin";    //ExtRAM³õÊ¼»¯ÎÄ¼ş£¬ÇëĞŞ¸ÄÎªÊµ¼ÊµÄ¾ø¶ÔÂ·¾¶
parameter FLASH_INIT_FILE = "/tmp/kernel.elf";    //Flash³õÊ¼»¯ÎÄ¼ş£¬ÇëĞŞ¸ÄÎªÊµ¼ÊµÄ¾ø¶ÔÂ·¾¶

assign rxd = 1'b1; //idle state

initial begin 
    //ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ô¶ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ğ£ï¿½ï¿½ï¿½ï¿½ç£º
//    dip_sw = 32'h2;
    touch_btn = 0;
    reset_btn = 1;
    #100;
    reset_btn = 0;
//    for (integer i = 0; i < 20; i = i+1) begin
//        #100; //ï¿½È´ï¿½100ns
//        clock_btn = 1; //ï¿½ï¿½ï¿½ï¿½ï¿½Ö¹ï¿½Ê±ï¿½Ó°ï¿½Å¥
//        #100; //ï¿½È´ï¿½100ns
//        clock_btn = 0; //ï¿½É¿ï¿½ï¿½Ö¹ï¿½Ê±ï¿½Ó°ï¿½Å¥
//    end
//    // Ä£ï¿½ï¿½PCÍ¨ï¿½ï¿½ï¿½ï¿½ï¿½Ú·ï¿½ï¿½ï¿½ï¿½Ö·ï¿½
//    cpld.pc_send_byte(8'h32);
//    #10000;
//    cpld.pc_send_byte(8'h33);
end

// ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½ï¿½Ã»ï¿½ï¿½ï¿½ï¿½
thinpad_top dut(
    .clk_50M(clk_50M),
    .clk_11M0592(clk_11M0592),
    .clock_btn(clock_btn),
    .reset_btn(reset_btn),
    .touch_btn(touch_btn),
    .dip_sw(dip_sw),
    .leds(leds),
    .dpy1(dpy1),
    .dpy0(dpy0),
    .txd(txd),
    .rxd(rxd),
    .uart_rdn(uart_rdn),
    .uart_wrn(uart_wrn),
    .uart_dataready(uart_dataready),
    .uart_tbre(uart_tbre),
    .uart_tsre(uart_tsre),
    .base_ram_data(base_ram_data),
    .base_ram_addr(base_ram_addr),
    .base_ram_ce_n(base_ram_ce_n),
    .base_ram_oe_n(base_ram_oe_n),
    .base_ram_we_n(base_ram_we_n),
    .base_ram_be_n(base_ram_be_n),
    .ext_ram_data(ext_ram_data),
    .ext_ram_addr(ext_ram_addr),
    .ext_ram_ce_n(ext_ram_ce_n),
    .ext_ram_oe_n(ext_ram_oe_n),
    .ext_ram_we_n(ext_ram_we_n),
    .ext_ram_be_n(ext_ram_be_n),
    .flash_d(flash_d),
    .flash_a(flash_a),
    .flash_rp_n(flash_rp_n),
    .flash_vpen(flash_vpen),
    .flash_oe_n(flash_oe_n),
    .flash_ce_n(flash_ce_n),
    .flash_byte_n(flash_byte_n),
    .flash_we_n(flash_we_n)
);
// Ê±ï¿½ï¿½Ô´
clock osc(
    .clk_11M0592(clk_11M0592),
    .clk_50M    (clk_50M)
);
// CPLD ï¿½ï¿½ï¿½Ú·ï¿½ï¿½ï¿½Ä£ï¿½ï¿½
cpld_model cpld(
    .clk_uart(clk_11M0592),
    .uart_rdn(uart_rdn),
    .uart_wrn(uart_wrn),
    .uart_dataready(uart_dataready),
    .uart_tbre(uart_tbre),
    .uart_tsre(uart_tsre),
    .data(base_ram_data[7:0])
);
// BaseRAM ï¿½ï¿½ï¿½ï¿½Ä£ï¿½ï¿½
sram_model base1(/*autoinst*/
            .DataIO(base_ram_data[15:0]),
            .Address(base_ram_addr[19:0]),
            .OE_n(base_ram_oe_n),
            .CE_n(base_ram_ce_n),
            .WE_n(base_ram_we_n),
            .LB_n(base_ram_be_n[0]),
            .UB_n(base_ram_be_n[1]));
sram_model base2(/*autoinst*/
            .DataIO(base_ram_data[31:16]),
            .Address(base_ram_addr[19:0]),
            .OE_n(base_ram_oe_n),
            .CE_n(base_ram_ce_n),
            .WE_n(base_ram_we_n),
            .LB_n(base_ram_be_n[2]),
            .UB_n(base_ram_be_n[3]));
// ExtRAM ï¿½ï¿½ï¿½ï¿½Ä£ï¿½ï¿½
sram_model ext1(/*autoinst*/
            .DataIO(ext_ram_data[15:0]),
            .Address(ext_ram_addr[19:0]),
            .OE_n(ext_ram_oe_n),
            .CE_n(ext_ram_ce_n),
            .WE_n(ext_ram_we_n),
            .LB_n(ext_ram_be_n[0]),
            .UB_n(ext_ram_be_n[1]));
sram_model ext2(/*autoinst*/
            .DataIO(ext_ram_data[31:16]),
            .Address(ext_ram_addr[19:0]),
            .OE_n(ext_ram_oe_n),
            .CE_n(ext_ram_ce_n),
            .WE_n(ext_ram_we_n),
            .LB_n(ext_ram_be_n[2]),
            .UB_n(ext_ram_be_n[3]));
// Flash ï¿½ï¿½ï¿½ï¿½Ä£ï¿½ï¿½
x28fxxxp30 #(.FILENAME_MEM(FLASH_INIT_FILE)) flash(
    .A(flash_a[1+:22]), 
    .DQ(flash_d), 
    .W_N(flash_we_n),    // Write Enable 
    .G_N(flash_oe_n),    // Output Enable
    .E_N(flash_ce_n),    // Chip Enable
    .L_N(1'b0),    // Latch Enable
    .K(1'b0),      // Clock
    .WP_N(flash_vpen),   // Write Protect
    .RP_N(flash_rp_n),   // Reset/Power-Down
    .VDD('d3300), 
    .VDDQ('d3300), 
    .VPP('d1800), 
    .Info(1'b1));

initial begin 
    wait(flash_byte_n == 1'b0);
    $display("8-bit Flash interface is not supported in simulation!");
    $display("Please tie flash_byte_n to high");
    $stop;
end

// ï¿½ï¿½ï¿½Ä¼ï¿½ï¿½ï¿½ï¿½ï¿½ BaseRAM
initial begin 
    reg [31:0] tmp_array[0:1048575];
    integer n_File_ID, n_Init_Size;
    n_File_ID = $fopen(BASE_RAM_INIT_FILE, "rb");
    if(!n_File_ID)begin 
        n_Init_Size = 0;
        $display("Failed to open BaseRAM init file");
    end else begin
        n_Init_Size = $fread(tmp_array, n_File_ID);
        n_Init_Size /= 4;
        $fclose(n_File_ID);
    end
    $display("BaseRAM Init Size(words): %d",n_Init_Size);
    for (integer i = 0; i < n_Init_Size; i++) begin
        base1.mem_array0[i] = tmp_array[i][24+:8];
        base1.mem_array1[i] = tmp_array[i][16+:8];
        base2.mem_array0[i] = tmp_array[i][8+:8];
        base2.mem_array1[i] = tmp_array[i][0+:8];
    end
end

// ï¿½ï¿½ï¿½Ä¼ï¿½ï¿½ï¿½ï¿½ï¿½ ExtRAM
initial begin 
    reg [31:0] tmp_array[0:1048575];
    integer n_File_ID, n_Init_Size;
    n_File_ID = $fopen(EXT_RAM_INIT_FILE, "rb");
    if(!n_File_ID)begin 
        n_Init_Size = 0;
        $display("Failed to open ExtRAM init file");
    end else begin
        n_Init_Size = $fread(tmp_array, n_File_ID);
        n_Init_Size /= 4;
        $fclose(n_File_ID);
    end
    $display("ExtRAM Init Size(words): %d",n_Init_Size);
    for (integer i = 0; i < n_Init_Size; i++) begin
        ext1.mem_array0[i] = tmp_array[i][24+:8];
        ext1.mem_array1[i] = tmp_array[i][16+:8];
        ext2.mem_array0[i] = tmp_array[i][8+:8];
        ext2.mem_array1[i] = tmp_array[i][0+:8];
    end
end
endmodule
