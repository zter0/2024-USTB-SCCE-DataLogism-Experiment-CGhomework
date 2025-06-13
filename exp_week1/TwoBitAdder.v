`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/07 18:51:09
// Design Name: 
// Module Name: TwoBitAdder
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

module TwoBitAdder(
    input wire [1:0] A,  // 两位输入A
    input wire [1:0] B,  // 两位输入B
    output wire [1:0] Sum, // 输出的和
    output wire Cout  // 输出进位
);

    wire carry1;  // 第一位的进位

    // 第一位的半加器
    assign Sum[0] = A[0] ^ B[0];  // 计算和
    assign carry1 = A[0] & B[0];  // 计算进位

    // 第二位的半加器
    assign Sum[1] = A[1] ^ B[1] ^ carry1;  // 第二位加上前一位的进位
    assign Cout = (A[1] & B[1]) | (carry1 & (A[1] ^ B[1]));  // 计算总进位

endmodule
