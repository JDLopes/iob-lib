`timescale 1 ns / 1 ps
`include "iob_lib.vh"

module iob_regfile_w_rp
  #(
    parameter ADDR_W = 0,
    parameter DATA_W = 0,
    parameter ADDR_W_INT = (ADDR_W==0)? 1: ADDR_W,
    parameter DATA_W_INT = (DATA_W==0)? 1: DATA_W
    )
   (
    input                                  clk_i,
    input                                  arst_i,
    input                                  cke_i,

    input                                  rst_i,

    // Write Port
    input                                  we_i,
    input [ADDR_W_INT-1:0]                 waddr_i,
    input [DATA_W_INT-1:0]                 wdata_i,

    // Read Port
    output [((2**ADDR_W)*DATA_W_INT)-1 :0] rdata_o
    );

   wire [DATA_W_INT-1:0]                   wdata [(2**ADDR_W)-1:0];

   genvar                                  i;
   generate
      for (i=0; i < (2**ADDR_W); i=i+1) begin: register_file
         assign wdata[i] =  (we_i & (waddr_i==i))? wdata_i: rdata_o[((i+1)*DATA_W_INT)-1 : i*DATA_W_INT];
         iob_reg_r #(DATA_W_INT, 1) iob_reg0
             (
              .clk_i(clk_i),
              .arst_i(arst_i),
              .cke_i(cke_i),
              .rst_i(rst_i),
              .data_i(wdata[i]),
              .data_o(rdata_o[((i+1)*DATA_W_INT)-1 : i*DATA_W_INT])
              );
      end
   endgenerate

endmodule
