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
  input x,
  input y,
  output z
);
  
  wire IA1_z, IA2_z, IB1_z, IB2_z;
  wire tmp1, tmp2;

  A IA1(
    .x(x),
    .y(y),
    .z(IA1_z)
  );

  B IB1(
    .x(x),
    .y(y),
    .z(IB1_z)
  );

  assign tmp1 = IA1_z | IB1_z;

  A IA2(
    .x(x),
    .y(y),
    .z(IA2_z)
  );

  B IB2(
    .x(x),
    .y(y),
    .z(IB2_z)
  );
  
  assign tmp2 = IA2_z & IB2_z;
  assign z = tmp1 ^ tmp2;

endmodule