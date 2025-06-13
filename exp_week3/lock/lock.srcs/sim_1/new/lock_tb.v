`timescale 1ns / 1ps

module lock_tb;

// �ź�����
    reg clk;
    reg rst;
    reg in;
    wire unlock;
    
    // ʵ����������ģ��
    lock uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .unlock(unlock)
    );
    
    // ʱ������
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // ÿ5ns��תһ�Σ�����10ns��ʱ������
    end
    
    // ���Թ���
    initial begin
        // ��ʼ��
        rst = 1;
        in = 0;
        #20; // ��λ����һ��ʱ��
    
        rst = 0; // ȡ����λ
    
        // ������� 0 �� 1������һ��ʱ��۲�����ź�
        repeat (50) begin
            in = $random % 2; // ���������0��1
            #10; // ÿ10ns�ı�һ�������ź�
        end
    
        // �ֶ����� "0010" ��������״̬
        #10 in = 0;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0;
    
        // �ȴ�һ��ʱ��۲�����ź�
        #50;
    
        // ���Խ���
        $finish;
    end
    
    // �������
    initial begin
        $monitor("Time = %0t | in = %b | unlock = %b", $time, in, unlock);
    end

endmodule
