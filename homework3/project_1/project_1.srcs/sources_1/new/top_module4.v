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
  input [7:0] a, b, c, d,
  output [7:0] min
);
  
  wire [7:0] tmp0, tmp1;

  assign tmp0 = a < b ? a : b;
  assign tmp1 = c < d ? c : d;
  assign min = tmp0 < tmp1 ? tmp0 : tmp1;

endmodule