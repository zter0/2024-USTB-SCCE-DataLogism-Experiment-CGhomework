`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/25 15:54:09
// Design Name: 
// Module Name: debounce
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


module ButtonDebounce (
    input clk,                 // ʱ���ź�
    input rst_n,               // �첽��λ�ź�
    input [3:0] button_raw,    // ԭʼ��ť�ź�
    output reg [3:0] button    // ������İ�ť�ź�
);
    reg [3:0] button_sync1, button_sync2; // ͬ���Ĵ���
    reg [15:0] counter[3:0];              // ÿ����ť������������
    reg [3:0] stable;                     // �ȶ��ź�

    parameter DEBOUNCE_TIME = 16'd50000;  // ��������ʱ��Ϊ 50000 ��ʱ������

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            button_sync1 <= 4'b0000;
            button_sync2 <= 4'b0000;
            stable <= 4'b0000;
            button <= 4'b0000;
            for (integer i = 0; i < 4; i = i + 1) begin
                counter[i] <= 16'd0;
            end
        end else begin
            // ͬ��ԭʼ��ť�ź�
            button_sync1 <= button_raw;
            button_sync2 <= button_sync1;

            // �����߼�
            for (integer i = 0; i < 4; i = i + 1) begin
                if (button_sync2[i] == stable[i]) begin
                    counter[i] <= 16'd0; // �ź��ȶ�ʱ����������
                end else begin
                    counter[i] <= counter[i] + 1; // �źŲ��ȶ�ʱ��ʼ��ʱ
                    if (counter[i] >= DEBOUNCE_TIME) begin
                        stable[i] <= button_sync2[i]; // �ﵽ����ʱ�������ȶ��ź�
                        counter[i] <= 16'd0; // ���������
                    end
                end
            end

            // ����������İ�ť�ź�
            button <= stable;
        end
    end
endmodule
