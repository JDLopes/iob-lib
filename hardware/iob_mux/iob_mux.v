`timescale 1ns / 1ps
`include "iob_lib.vh"

module iob_mux
  #(
    parameter DATA_W = 0,
    parameter N = 0
    )
   (
    `IOB_INPUT(data_i, N*DATA_W),
    `IOB_INPUT(sel_i, $clog2(1+N)),
    `IOB_OUTPUT(data_o, DATA_W)
    );

   `IOB_WIRE(data_int, N*DATA_W)
   assign data_int = data_i >> (sel_i*DATA_W);
   assign data_o = data_int[DATA_W-1:0];

endmodule