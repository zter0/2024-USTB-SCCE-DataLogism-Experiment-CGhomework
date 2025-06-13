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
    input wire [1:0] A,  // ��λ����A
    input wire [1:0] B,  // ��λ����B
    output wire [1:0] Sum, // ����ĺ�
    output wire Cout  // �����λ
);

    wire carry1;  // ��һλ�Ľ�λ

    // ��һλ�İ����
    assign Sum[0] = A[0] ^ B[0];  // �����
    assign carry1 = A[0] & B[0];  // �����λ

    // �ڶ�λ�İ����
    assign Sum[1] = A[1] ^ B[1] ^ carry1;  // �ڶ�λ����ǰһλ�Ľ�λ
    assign Cout = (A[1] & B[1]) | (carry1 & (A[1] ^ B[1]));  // �����ܽ�λ

endmodule
