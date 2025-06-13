`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 16:50:53
// Design Name: 
// Module Name: rcadd32
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


module rcadd32 (
    input  wire [31:0] a,          // 32λ���� A
    input  wire [31:0] b,          // 32λ���� B
    input  wire cin,        // ��ʼ��λ����
    output wire [31:0] s,        // 32λ�ӷ����
    output wire cout        // ���Ľ�λ���
);

    wire [31:0] carry;             // ÿ��λ�Ľ�λ

    full_adder FA0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .s(s[0]),
        .cout(carry[0])
    );

    // ��1��31λ�ļӷ�������λ��λ
    genvar i;
    generate
        for (i = 1; i < 32; i = i + 1) begin : rc
            full_adder FA (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .s(s[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    // �������Ľ�λ
    assign cout = carry[31];

endmodule

// 1λȫ����ģ��
module full_adder (
    input  wire a,      // 1λ���� a
    input  wire b,      // 1λ���� b
    input  wire cin,    // ��λ����
    output wire s,    // 1λ�����
    output wire cout    // ��λ���
);

    assign s  = a ^ b ^ cin;     // ���
    assign cout = (a & b) | (a & cin) | (b & cin);  // ��λ���

endmodule
