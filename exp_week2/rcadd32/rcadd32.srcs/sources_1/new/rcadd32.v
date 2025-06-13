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
    input  wire [31:0] a,          // 32位输入 A
    input  wire [31:0] b,          // 32位输入 B
    input  wire cin,        // 初始进位输入
    output wire [31:0] s,        // 32位加法结果
    output wire cout        // 最后的进位输出
);

    wire [31:0] carry;             // 每个位的进位

    full_adder FA0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .s(s[0]),
        .cout(carry[0])
    );

    // 第1到31位的加法器，逐位进位
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

    // 最后输出的进位
    assign cout = carry[31];

endmodule

// 1位全加器模块
module full_adder (
    input  wire a,      // 1位输入 a
    input  wire b,      // 1位输入 b
    input  wire cin,    // 进位输入
    output wire s,    // 1位和输出
    output wire cout    // 进位输出
);

    assign s  = a ^ b ^ cin;     // 求和
    assign cout = (a & b) | (a & cin) | (b & cin);  // 进位输出

endmodule
