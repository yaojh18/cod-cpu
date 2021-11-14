// Copyright 1986-2019 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2019.2 (win64) Build 2708876 Wed Nov  6 21:40:23 MST 2019
<<<<<<< HEAD
// Date        : Tue Nov  9 19:07:33 2021
// Host        : LAPTOP-OK9N2T0V running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               E:/pipeline/thinpad_top.srcs/sources_1/ip/pll_example/pll_example_stub.v
=======
// Date        : Sat Nov 13 02:27:44 2021
// Host        : LAPTOP-511H9MLC running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               D:/jizu_test/rv_7/cod21-grp08/thinpad_top.srcs/sources_1/ip/pll_example/pll_example_stub.v
>>>>>>> 285842b6a86a3ca1f11b0dee4a3825b2dd613634
// Design      : pll_example
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg676-2L
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module pll_example(clk_out1, clk_out2, reset, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_out1,clk_out2,reset,locked,clk_in1" */;
  output clk_out1;
  output clk_out2;
  input reset;
  output locked;
  input clk_in1;
endmodule
