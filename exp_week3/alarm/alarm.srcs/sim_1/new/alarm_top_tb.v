`timescale 1s / 1ms
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 20:38:21
// Design Name: 
// Module Name: alarm_top_tb
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


`timescale 1ns / 1ps

module tb_alarm_top;

    // �����ź�
    reg rst;
    reg cle;
    reg clk;
    reg act; // B1
    reg [1:0] swc; // k1, k2

    // ����ź�
    wire [3:0] pos;  // seg pos
    wire [7:0] seg;  // seg msg
    wire led;         // flashing leds

    // ʵ����������ģ��
    alarm_top dut (
        .rst(rst),
        .cle(cle),
        .clk(clk),
        .act(act),
        .swc(swc),
        .pos(pos),
        .seg(seg),
        .led(led)
    );

    // ʱ�����ɣ�100MHzʱ��
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz => ʱ������ 10ns
    end

    // ���Թ���
    initial begin
        // ��ʼ���ź�
        rst = 1;
        cle = 0;
        act = 0;
        swc = 2'b00;

        // ��λ�׶�
        #500000000 rst = 0;  // ��20ns���ͷŸ�λ

        // �������act�����������swc��ֵ
        act = 1;  // ģ�ⰴ�°�ť
        swc = 2'b10;  // k1 = 1, k2 = 0
        #500000000
        act = 0;  // ģ���ͷŰ�ť
        
        #3000000000; // �ȴ����۲첨��
        
        swc = 2'b11;  // k1 = 1, k2 = 1
        act = 1;  // �ٴ�ģ�ⰴ�°�ť
        #500000000
        act = 0;  // ģ���ͷŰ�ť
        
        #3000000000; // �ȴ����۲첨��
        
        swc = 2'b01;  // k1 = 0, k2 = 1
        act = 1;  // �ٴ�ģ�ⰴ�°�ť
        #500000000
        act = 0;  // ģ���ͷŰ�ť
        
        #3000000000; // �ȴ����۲첨��
        
        swc = 2'b01;  // k1 = 0, k2 = 1
        act = 1;  // �ٴ�ģ�ⰴ�°�ť
        #300000000
        act = 0;  // ģ���ͷŰ�ť
        
        // ����cle���ʱ��
        #500000000; cle = 1;  // ��������ź�
        #500000000 cle = 0; // ֹͣ���

        // �ȴ�һ��ʱ����������
        $finish;
    end

    // ������������鿴�������
    initial begin
        $monitor("Time: %0t | rst: %b | cle: %b | act: %b | swc: %b | pos: %b | seg: %b | led: %b", 
                 $time, rst, cle, act, swc, pos, seg, led);
    end

endmodule
