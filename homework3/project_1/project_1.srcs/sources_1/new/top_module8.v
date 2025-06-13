`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/19 16:11:18
// Design Name: 
// Module Name: top_module
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

module top_module (
  input [7:0] in,
  output [7:0] out
);

  genvar i;
  generate
    for (i = 0; i < 8; i = i + 1) begin : bit_reverse
      assign out[i] = in[7-i];
    end
  endgenerate
  
endmodule
