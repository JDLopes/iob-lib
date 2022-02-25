`timescale 1ns / 1ps

module sync
  #(
    parameter WIDTH = 0,
    parameter RST_VAL = 0
    )
  (
   input clk,
   input rst,
   input [WIDTH-1:0] signal_in,
   output reg [WIDTH-1:0] signal_out
   );
   

   reg [WIDTH-1:0]        sync_reg;

   always @(posedge clk, posedge rst) begin : sync
      if(rst) begin
         sync_reg <= RST_VAL;
         signal_out <= RST_VAL;
      end else begin
         sync_reg <= signal_in;
         signal_out <= sync_reg;
      end
   end
   
endmodule