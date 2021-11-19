`timescale 1ns / 1ps
module test();
 
    reg[4:0] d;
    reg we;
    reg oe;
    reg[4:0] r1;
    reg[4:0] r2;
    
    initial begin
        d = 5'b00011;
        we = 1'b0;
        oe = 1'b1;
        r1 = d & {5{we}};
        r2 = d & {5{oe}};
    end
endmodule
