`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/28 20:30:35
// Design Name: 
// Module Name: PalindromicSequenceDetector
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


module PalindromicSequenceDetector (
    input wire CLK,      // ʱ���ź�
    input wire IN,       // ��������
    output wire OUT      // ���
);

    reg [4:0] shift_reg = 5'b00000; // 5λ��λ�Ĵ���

    // ��ʱ�������أ���λ�Ĵ�������
    always @(posedge CLK) begin
        // ��ʱ�������أ���ǰ��λ���ƣ�������ǰ����IN�������λ
        shift_reg <= {shift_reg[3:0], IN};
    end

    // ��鵱ǰ����IN��shift_reg�����Ƿ񹹳ɻ�������
    assign OUT = (shift_reg[3] == IN) && (shift_reg[2] == shift_reg[0]);

endmodule

