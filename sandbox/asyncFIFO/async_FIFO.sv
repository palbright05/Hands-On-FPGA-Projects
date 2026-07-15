`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/14/2026 06:57:47 PM
// Design Name: 
// Module Name: async_fifo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Code your design here
module async_fifo # (
  parameter DATA_WIDTH = 4,
  parameter ADDR_WIDTH = 8
 )(
  // write signals
  input logic wr_clk,
  input logic wr_rstn,
  input logic wr_en,
  input logic [DATA_WIDTH-1:0] wr_data,

  // read signals
  input logic rd_clk,
  input logic rd_rstn,
  input logic rd_en,
  output logic [DATA_WIDTH-1:0] rd_data,

  // status signals
  output logic full,
  output logic empty
);

  logic [DATA_WIDTH-1:0] fifo [0:(2**ADDR_WIDTH)-1]; 
  logic [ADDR_WIDTH:0] wr_ptr_bin, rd_ptr_bin; 
  logic [ADDR_WIDTH:0] wr_ptr_gray, rd_ptr_gray; 

  always_ff @ (posedge wr_clk or negedge wr_rstn) begin

    if(!wr_rstn) begin
      wr_ptr_bin <= 0;
      wr_ptr_gray <= 0;
    end else begin
      if(wr_en && !full) begin
        wr_ptr_bin <= wr_ptr_bin + 1;
        wr_ptr_gray <= bin2gray(wr_ptr_bin + 1);
      end
    end
  end


  xpm_cdc_gray #(
      .DEST_SYNC_FF(2),          // DECIMAL; range: 2-10
      .INIT_SYNC_FF(0),          // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
      .REG_OUTPUT(0),            // DECIMAL; 0=disable registered output, 1=enable registered output
      .SIM_ASSERT_CHK(0),        // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .SIM_LOSSLESS_GRAY_CHK(0), // DECIMAL; 0=disable lossless check, 1=enable lossless check
      .WIDTH(ADDR_WIDTH+1)                  // DECIMAL; range: 2-32
   )
   xpm_cdc_gray_inst (
      .dest_out_bin(dest_out_bin), // WIDTH-bit output: Binary input bus (src_in_bin) synchronized to
                                   // destination clock domain. This output is combinatorial unless REG_OUTPUT
                                   // is set to 1.

  .dest_clk(rd_clk),         // 1-bit input: Destination clock.
  .src_clk(wr_clk),           // 1-bit input: Source clock.
  .src_in_bin(wr_ptr_bin)      // WIDTH-bit input: Binary input bus that will be synchronized to the
                               // destination clock domain.
   );


endmodule
