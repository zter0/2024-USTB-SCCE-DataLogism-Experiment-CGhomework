`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/14 17:07:03
// Design Name: 
// Module Name: csadd32
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


module csadd32 (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire        cin,
    output wire [31:0] s,
    output wire        cout
);

    wire [31:0] s0, s1;
    wire [7:0] carry;

    carry_select_adder_4bit CSA0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(cin),
        .s(s[3:0]),
        .cout(carry[0])
    );

    carry_select_adder_4bit CSA1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(carry[0]),
        .s(s[7:4]),
        .cout(carry[1])
    );

    carry_select_adder_4bit CSA2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(carry[1]),
        .s(s[11:8]),
        .cout(carry[2])
    );

    carry_select_adder_4bit CSA3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(carry[2]),
        .s(s[15:12]),
        .cout(carry[3])
    );

    carry_select_adder_4bit CSA4 (
        .a(a[19:16]),
        .b(b[19:16]),
        .cin(carry[3]),
        .s(s[19:16]),
        .cout(carry[4])
    );

    carry_select_adder_4bit CSA5 (
        .a(a[23:20]),
        .b(b[23:20]),
        .cin(carry[4]),
        .s(s[23:20]),
        .cout(carry[5])
    );

    carry_select_adder_4bit CSA6 (
        .a(a[27:24]),
        .b(b[27:24]),
        .cin(carry[5]),
        .s(s[27:24]),
        .cout(carry[6])
    );

    carry_select_adder_4bit CSA7 (
        .a(a[31:28]),
        .b(b[31:28]),
        .cin(carry[6]),
        .s(s[31:28]),
        .cout(cout)
    );

endmodule

module carry_select_adder_4bit (
    input  wire [3:0] a,          
    input  wire [3:0] b,          
    input  wire       cin,        
    output wire [3:0] s,        
    output wire       cout
);

    wire [3:0] s0, s1; 
    wire       cout0, cout1; 

    ripple_carry_adder_4bit RCA0 (
        .a(a),
        .b(b),
        .cin(1'b0),
        .s(s0),
        .cout(cout0)
    );

    ripple_carry_adder_4bit RCA1 (
        .a(a),
        .b(b),
        .cin(1'b1),
        .s(s1),
        .cout(cout1)
    );

    assign s  = (cin) ? s1 : s0;
    assign cout = (cin) ? cout1 : cout0;

endmodule

module ripple_carry_adder_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire       cin,
    output wire [3:0] s,
    output wire       cout
);

    wire [3:0] carry;          

    full_adder FA0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .s(s[0]),
        .cout(carry[0])
    );

    genvar i;
    generate
        for (i = 1; i < 4; i = i + 1) begin : ripple_carry
            full_adder FA (
                .a(a[i]),
                .b(b[i]),
                .cin(carry[i-1]),
                .s(s[i]),
                .cout(carry[i])
            );
        end
    endgenerate

    assign cout = carry[3];

endmodule

module rcadd32 (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire cin,
    output wire [31:0] s,
    output wire cout
);

    wire [31:0] carry;

    full_adder FA0 (
        .a(a[0]),
        .b(b[0]),
        .cin(cin),
        .s(s[0]),
        .cout(carry[0])
    );

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

    assign cout = carry[31];

endmodule

module full_adder (
    input  wire a,
    input  wire b, 
    input  wire cin, 
    output wire s, 
    output wire cout
);

    assign #4 s  = a ^ b ^ cin;
    assign #2 cout = (cin == 1) | (cin == 0) ? (a & cin) | (b & cin) | (a & b) : 1'bx;

endmodule

module vadd32(
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire cin,
    output wire [32:0] s,
    output wire cout
);

    wire [32:0] sum;
    assign sum  = a + b + cin;
    assign cout = sum[32];
    assign s = sum[31:0];

endmodule