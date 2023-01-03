`timescale 1ns / 1ps

module iob_reg_e_n
  #(
    parameter DATA_W = 0,
    parameter RST_VAL = 0
    )
   (
    input                   clk_i,
    input                   arst_i,
    input                   ce_i,
    input                   en_i,
    input [DATA_W-1:0]      data_i,
    output reg [DATA_W-1:0] data_o
    );

   wire [DATA_W-1:0]    data;
   assign data = en_i? data_i: data_o;

   iob_reg_n #(DATA_W, RST_VAL) reg0 (clk_i, arst_i, ce_i, data, data_o);

endmodule
