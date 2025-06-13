`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/19 15:56:40
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


module top_module(
    input p1a, p1b, p1c, p1d,
    output p1y,
    input p2a, p2b, p2c, p2d,
    output p2y
);
    wire tmp0, tmp1;
    
    assign tmp0 = p1a & p1b & p1c & p1d;
    assign p1y = !tmp0;

    assign tmp1 = p2a & p2b & p2c & p2d;
    assign p2y = !tmp1;

endmodule
