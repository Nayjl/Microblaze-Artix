//-----------------------------------------------------------------
//                    SDRAM Controller (AXI4)
//                           V1.0
//                     Ultra-Embedded.com
//                     Copyright 2015-2019
//
//                 Email: admin@ultra-embedded.com
//
//                         License: GPL
// If you would like a version with a more permissive license for
// use in closed source commercial applications please contact me
// for details.
//-----------------------------------------------------------------
//
// This file is open source HDL; you can redistribute it and/or 
// modify it under the terms of the GNU General Public License as 
// published by the Free Software Foundation; either version 2 of 
// the License, or (at your option) any later version.
//
// This file is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public 
// License along with this file; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA
//-----------------------------------------------------------------

//-----------------------------------------------------------------
//                          Generated File
//-----------------------------------------------------------------

module sdram_axi
(
    // Inputs
     input           s_axi_aclk
    ,input           s_axi_aresetn
    ,input           s_axi_awvalid
    ,input  [ 31:0]  s_axi_awaddr
    ,input  [  3:0]  s_axi_awid
    ,input  [  7:0]  s_axi_awlen
    ,input  [  1:0]  s_axi_awburst
    ,input           s_axi_wvalid
    ,input  [ 31:0]  s_axi_wdata
    ,input  [  3:0]  s_axi_wstrb
    ,input           s_axi_wlast
    ,input           s_axi_bready
    ,input           s_axi_arvalid
    ,input  [ 31:0]  s_axi_araddr
    ,input  [  3:0]  s_axi_arid
    ,input  [  7:0]  s_axi_arlen
    ,input  [  1:0]  s_axi_arburst
    ,input           s_axi_rready

    // Outputs
    ,output          s_axi_awready
    ,output          s_axi_wready
    ,output          s_axi_bvalid
    ,output [  1:0]  s_axi_bresp
    ,output [  3:0]  s_axi_bid
    ,output          s_axi_arready
    ,output          s_axi_rvalid
    ,output [ 31:0]  s_axi_rdata
    ,output [  1:0]  s_axi_rresp
    ,output [  3:0]  s_axi_rid
    ,output          s_axi_rlast

    // SDRAM interface
    ,output          clk_o
    ,output          cke_o
    ,output          cs_o
    ,output          ras_o
    ,output          cas_o
    ,output          we_o
    ,output [  1:0]  dqm_o
    ,output [ 12:0]  addr_o
    ,output [  1:0]  ba_o
    ,inout  [15 : 0] data_io
);



//-----------------------------------------------------------------
// Key Params
//-----------------------------------------------------------------
parameter SDRAM_MHZ             = 50;
parameter SDRAM_ADDR_W          = 24;
parameter SDRAM_COL_W           = 9;
parameter SDRAM_READ_LATENCY    = 2;

//-----------------------------------------------------------------
// AXI Interface
//-----------------------------------------------------------------
wire [ 31:0]  ram_addr_w;
wire [  3:0]  ram_wr_w;
wire          ram_rd_w;
wire          ram_accept_w;
wire [ 31:0]  ram_write_data_w;
wire [ 31:0]  ram_read_data_w;
wire [  7:0]  ram_len_w;
wire          ram_ack_w;
wire          ram_error_w;

sdram_axi_pmem
u_axi
(
    .clk_i(s_axi_aclk),
    .rst_i(s_axi_aresetn),

    // AXI port
    .axi_awvalid_i(s_axi_awvalid),
    .axi_awaddr_i(s_axi_awaddr),
    .axi_awid_i(s_axi_awid),
    .axi_awlen_i(s_axi_awlen),
    .axi_awburst_i(s_axi_awburst),
    .axi_wvalid_i(s_axi_wvalid),
    .axi_wdata_i(s_axi_wdata),
    .axi_wstrb_i(s_axi_wstrb),
    .axi_wlast_i(s_axi_wlast),
    .axi_bready_i(s_axi_bready),
    .axi_arvalid_i(s_axi_arvalid),
    .axi_araddr_i(s_axi_araddr),
    .axi_arid_i(s_axi_arid),
    .axi_arlen_i(s_axi_arlen),
    .axi_arburst_i(s_axi_arburst),
    .axi_rready_i(s_axi_rready),
    .axi_awready_o(s_axi_awready),
    .axi_wready_o(s_axi_wready),
    .axi_bvalid_o(s_axi_bvalid),
    .axi_bresp_o(s_axi_bresp),
    .axi_bid_o(s_axi_bid),
    .axi_arready_o(s_axi_arready),
    .axi_rvalid_o(s_axi_rvalid),
    .axi_rdata_o(s_axi_rdata),
    .axi_rresp_o(s_axi_rresp),
    .axi_rid_o(s_axi_rid),
    .axi_rlast_o(s_axi_rlast),
    
    // RAM interface
    .ram_addr_o(ram_addr_w),
    .ram_accept_i(ram_accept_w),
    .ram_wr_o(ram_wr_w),
    .ram_rd_o(ram_rd_w),
    .ram_len_o(ram_len_w),
    .ram_write_data_o(ram_write_data_w),
    .ram_ack_i(ram_ack_w),
    .ram_error_i(ram_error_w),
    .ram_read_data_i(ram_read_data_w)
);

//-----------------------------------------------------------------
// SDRAM Controller
//-----------------------------------------------------------------
wire [15 : 0] sdram_data_output_o;
wire [15 : 0] sdram_data_input_i;
sdram_axi_core
#(
     .SDRAM_MHZ(SDRAM_MHZ)
    ,.SDRAM_ADDR_W(SDRAM_ADDR_W)
    ,.SDRAM_COL_W(SDRAM_COL_W)
    ,.SDRAM_READ_LATENCY(SDRAM_READ_LATENCY)
)
u_core
(
     .clk_i(s_axi_aclk)
    ,.rst_i(s_axi_aresetn)

    ,.inport_wr_i(ram_wr_w)
    ,.inport_rd_i(ram_rd_w)
    ,.inport_len_i(ram_len_w)
    ,.inport_addr_i(ram_addr_w)
    ,.inport_write_data_i(ram_write_data_w)
    ,.inport_accept_o(ram_accept_w)
    ,.inport_ack_o(ram_ack_w)
    ,.inport_error_o(ram_error_w)
    ,.inport_read_data_o(ram_read_data_w)

    ,.sdram_clk_o()
    ,.sdram_cke_o(cke_o)
    ,.sdram_cs_o(cs_o)
    ,.sdram_ras_o(ras_o)
    ,.sdram_cas_o(cas_o)
    ,.sdram_we_o(we_o)
    ,.sdram_dqm_o(dqm_o)
    ,.sdram_addr_o(addr_o)
    ,.sdram_ba_o(ba_o)
    ,.sdram_data_output_o(sdram_data_output_o)
    ,.sdram_data_out_en_o(sdram_data_out_en_o)
    ,.sdram_data_input_i(sdram_data_input_i)
);


ODDR2 
#(
    .DDR_ALIGNMENT("NONE"),
    .INIT(1'b0),
    .SRTYPE("SYNC")
)
u_clock_delay
(
    .Q(clk_o),
    .C0(s_axi_aclk),
    .C1(~s_axi_aclk),
    .CE(1'b1),
    .R(1'b0),
    .S(1'b0),
    .D0(1'b0),
    .D1(1'b1)
);

genvar i;
for (i=0; i < 16; i = i + 1) 
begin
  IOBUF 
  #(
    .DRIVE(12),
    .IOSTANDARD("LVTTL"),
    .SLEW("FAST")
  )
  u_data_buf
  (
    .O(sdram_data_input_i[i]),
    .IO(data_io[i]),
    .I(sdram_data_output_o[i]),
    .T(~sdram_data_out_en_o)
  );
end



endmodule
