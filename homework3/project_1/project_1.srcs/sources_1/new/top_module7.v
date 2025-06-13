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
  input [4:0] a, b, c, d, e, f,
  output [7:0] w, x, y, z
);

  wire [31:0] tmp;
  assign tmp = {a, b, c, d, e, f, 2'b11};

  assign w = tmp[31:24];
  assign x = tmp[23:16];
  assign y = tmp[15:8];
  assign z = tmp[7:0];
  
endmodule