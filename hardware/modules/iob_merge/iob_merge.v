`timescale 1ns / 1ps

`include "iob_utils.vh"


module iob_merge #(
    parameter N_MASTERS = 2,
    parameter DATA_W    = 32,
    parameter ADDR_W    = 32
) (

    input clk_i,
    input arst_i,

    //masters interface
    input      [ N_MASTERS*`REQ_W-1:0] m_req_i,
    output reg [N_MASTERS*`RESP_W-1:0] m_resp_o,

    //slave interface
    output reg [ `REQ_W-1:0] s_req_o,
    input      [`RESP_W-1:0] s_resp_i
);


   localparam Nb = $clog2(N_MASTERS) + ($clog2(N_MASTERS) == 0);


   //
   //priority encoder: most significant bus has priority
   //
   reg [Nb-1:0] sel, sel_reg;

   //select enable
   reg sel_en;
   wire s_valid;
   wire s_ready;
   assign s_valid = s_req_o[`AVALID(0)];
   assign s_ready = s_resp_i[`READY(0)];
   always @(posedge clk_i, posedge arst_i)
      if (arst_i) sel_en <= 1'b1;
      else if (s_valid) sel_en <= 1'b0;
      else if (s_ready) sel_en <= ~s_valid;


   //select master
   integer k;
   wire m_valid;
   assign m_valid = m_req_i[`AVALID(k)];
   always @* begin
      sel = {Nb{1'b0}};
      for (k = 0; k < N_MASTERS; k = k + 1)
         if (~sel_en) sel = sel_reg;
         else if (m_valid) sel = k[Nb-1:0];
   end

   //
   //route master request to slave
   //  
   integer i;
   always @* begin
      s_req_o = {`REQ_W{1'b0}};
      for (i = 0; i < N_MASTERS; i = i + 1) if (i == sel) s_req_o = m_req_i[`REQ(i)];
   end

   //
   //route response from slave to previously selected master
   //

   //register master selection
   always @(posedge clk_i, posedge arst_i) begin
      if (arst_i) sel_reg <= {Nb{1'b0}};
      else sel_reg <= sel;
   end

   //route
   integer j;
   always @* begin
      for (j = 0; j < N_MASTERS; j = j + 1)
         if (j == sel_reg) m_resp_o[`RESP(j)] = s_resp_i;
         else m_resp_o[`RESP(j)] = {`RESP_W{1'b0}};
   end


endmodule
