`timescale 1ns / 1ps


module SRAMUARTController(
        input wire clk,
        input wire rst,

        input wire oe,
        input wire we,
        input wire[3:0] be,
        input wire[31:0] address,
        input wire[31:0] in_data,
        output wire[31:0] out_data,
        output reg done,
        
        output reg uart_rdn,         //�������źţ�����Ч
        output reg uart_wrn,         //д�����źţ�����Ч
        input wire uart_dataready,    //��������׼����
        input wire uart_tbre,         //�������ݱ�־
        input wire uart_tsre,         //���ݷ�����ϱ�־ 
        
        inout wire[31:0] base_ram_data_wire,  //RAM���ݣ���8λ��CPLD���ڿ���������
        output wire[19:0] base_ram_addr, //RAM��ַ
        output wire[3:0] base_ram_be_n,  //RAM�ֽ�ʹ�ܣ�����Ч�������ʹ���ֽ�ʹ�ܣ��뱣��Ϊ0
        output wire base_ram_ce_n,       //RAMƬѡ������Ч
        output reg base_ram_oe_n,       //RAM��ʹ�ܣ�����Ч
        output reg base_ram_we_n,       //RAMдʹ�ܣ�����Ч
        
        inout wire[31:0] ext_ram_data_wire,  //RAM���ݣ���8λ��CPLD���ڿ���������
        output wire[19:0] ext_ram_addr, //RAM��ַ
        output wire[3:0] ext_ram_be_n,  //RAM�ֽ�ʹ�ܣ�����Ч�������ʹ���ֽ�ʹ�ܣ��뱣��Ϊ0
        output wire ext_ram_ce_n,       //RAMƬѡ������Ч
        output reg ext_ram_oe_n,       //RAM��ʹ�ܣ�����Ч
        output reg ext_ram_we_n       //RAMдʹ�ܣ�����Ч
    );
    
    wire use_uart;
    wire use_ext;
    wire check_uart_state;
    wire[7:0] uart_state;
    wire[1:0] byte_offset;
    wire[31:0] out_data_mask;
    reg uart_can_write;
    reg data_z;
    reg[31:0] ram_in_data;
    reg[31:0] ram_out_data;
    
    assign use_uart = (address == 32'h10000000);
    assign check_uart_state = (address == 32'h10000005);
    assign uart_state = {2'b00, uart_tsre, 4'b0000, uart_dataready};
    
    assign use_ext = (address >= 32'h80004000);
    assign base_ram_data_wire = data_z ? 32'bz : (ram_in_data << {byte_offset,3'b000});
    assign ext_ram_data_wire = data_z ? 32'bz : (ram_in_data << {byte_offset,3'b000});
    assign base_ram_addr = address[21:2];
    assign ext_ram_addr = address[21:2];
    assign byte_offset = address[1:0];
    assign base_ram_be_n = ~(be << byte_offset);
    assign ext_ram_be_n = ~(be << byte_offset);
    assign out_data_mask = {{8{be[3]}},{8{be[2]}},{8{be[1]}},{8{be[0]}}};
    assign { base_ram_ce_n, ext_ram_ce_n } = use_uart ? 2'b11 : use_ext ? 2'b10 : 2'b01;
    assign out_data = (ram_out_data >> {byte_offset,3'b000}) & out_data_mask;
    
    localparam STATE_IDLE = 4'b0000;
    localparam STATE_SRAM_READ_0 = 4'b0001;
    localparam STATE_SRAM_READ_1 = 4'b0010;
    localparam STATE_SRAM_WRITE_0 = 4'b0011;
    localparam STATE_SRAM_WRITE_1 = 4'b0100;
    localparam STATE_UART_READ_0 = 4'b0101;
    localparam STATE_UART_READ_1 = 4'b0110;
    localparam STATE_UART_WRITE_0 = 4'b1000;
    localparam STATE_UART_WRITE_1 = 4'b1001;
    localparam STATE_CHECK_UART_STATE_WAIT = 4'b1010;
    
    localparam wait_cycle_num = 1;
    localparam check_uart_state_wait_cycle_num = 2;
    integer cycle_counter;
    integer check_uart_state_wait_cycle_counter;
    
    reg[3:0] state;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= STATE_IDLE;
            base_ram_oe_n <= 1'b1;
            base_ram_we_n <= 1'b1;
            ext_ram_oe_n <= 1'b1;
            ext_ram_we_n <= 1'b1;
            uart_rdn <= 1'b1;
            uart_wrn <= 1'b1;
            data_z <= 1'b1;
            done <= 1'b0;
            cycle_counter <= 0;
            check_uart_state_wait_cycle_counter <= 0;
            uart_can_write <= 1'b1;
        end
        else begin
            case(state)
                STATE_IDLE: begin
                    cycle_counter <= 0;
                    check_uart_state_wait_cycle_counter <= 0;
                    if(uart_tsre) begin
                        uart_can_write <= 1'b1;
                    end
                    else begin
                        uart_can_write <= 1'b0;
                    end
                    if(we==1'b1 && !check_uart_state && !done) begin
                        // write, higher priority than read
                        data_z <= 1'b0;
                        ram_in_data <= in_data;
                        if(use_uart && uart_can_write) state<= STATE_UART_WRITE_0;
                        else state <= STATE_SRAM_WRITE_0;
                    end
                    else if(oe==1'b1 && !done) begin
                        data_z <= 1'b1;
                        if(check_uart_state) begin
                            ram_out_data <= {16'h0, uart_state, 8'h0};
                            state <= STATE_CHECK_UART_STATE_WAIT;
                        end
                        else if(use_uart && uart_dataready) state<= STATE_UART_READ_0;
                        else state <= STATE_SRAM_READ_0;
                    end
                    else if(oe==1'b0 && we==1'b0) begin
                        done <= 1'b0;
                        data_z <= 1'b1;
                    end
                    else data_z <= 1'b1;
                end
                
                STATE_CHECK_UART_STATE_WAIT: begin
                    if(check_uart_state_wait_cycle_counter==check_uart_state_wait_cycle_num) begin
                        state <= STATE_IDLE;
                        done <= 1'b1;
                    end
                    else check_uart_state_wait_cycle_counter <= check_uart_state_wait_cycle_counter + 1;
                end
                
                STATE_SRAM_READ_0: begin
                    if(cycle_counter==0) begin
                        if(use_ext) ext_ram_oe_n <= 1'b0;
                        else base_ram_oe_n <= 1'b0;
                    end
                    if(cycle_counter==wait_cycle_num) state <= STATE_SRAM_READ_1;
                    else cycle_counter <= cycle_counter + 1;
                end
                STATE_SRAM_READ_1: begin
                    if(use_ext) ram_out_data <= ext_ram_data_wire;
                    else ram_out_data <= base_ram_data_wire;
                    done <= 1'b1;
                    base_ram_oe_n <= 1'b1;
                    ext_ram_oe_n <= 1'b1;
                    state <= STATE_IDLE;
                    cycle_counter <= 0;
                end
                
                STATE_SRAM_WRITE_0: begin
                    if(cycle_counter==0) begin
                        data_z <= 1'b0;
                        if(use_ext) ext_ram_we_n <= 1'b0;
                        else base_ram_we_n <= 1'b0;
                    end
                    if(cycle_counter==wait_cycle_num) state <= STATE_SRAM_WRITE_1;
                    else cycle_counter <= cycle_counter + 1;
                end
                STATE_SRAM_WRITE_1: begin
                    base_ram_we_n <= 1'b1;
                    ext_ram_we_n <= 1'b1;
                    done <= 1'b1;
                    state <= STATE_IDLE;
                    cycle_counter <= 0;
                end
                
                STATE_UART_READ_0: begin
                    state <= STATE_UART_READ_1;
                    uart_rdn <= 1'b0;
                end
                STATE_UART_READ_1: begin
                    if(cycle_counter==wait_cycle_num) begin
                        uart_rdn <= 1'b1;
                        ram_out_data <= base_ram_data_wire;
                        done <= 1'b1;
                        state <= STATE_IDLE;
                        cycle_counter <= 0;
                    end
                    else cycle_counter <= cycle_counter + 1;
                end
                
                STATE_UART_WRITE_0: begin
                    if(cycle_counter==0) begin
                        data_z <= 1'b0;
                        uart_wrn <= 1'b0;
                    end
                    if(cycle_counter==wait_cycle_num) state <= STATE_UART_WRITE_1;
                    else cycle_counter <= cycle_counter + 1;
                end
                STATE_UART_WRITE_1: begin
                    uart_wrn <= 1'b1;
                    state <= STATE_IDLE;
                    cycle_counter <= 0;
                    done <= 1'b1;
                end
            endcase
        end
    end
endmodule
