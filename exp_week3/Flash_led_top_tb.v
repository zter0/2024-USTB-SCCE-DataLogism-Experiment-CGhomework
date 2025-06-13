`timescale 1ns / 1ps

module tb_flash_led_top;

    // �����ź�
    reg clk;
    reg rst;
    reg [7:0] switch;

    // ����ź�
    wire [15:0] led;
    wire CLK_BPS;
    
    // ʵ��������ģ��
    flash_led_top dut (
        .clk(clk),
        .rst(rst),
        .switch(switch),
        .led(led),
        .CLK_BPS(CLK_BPS)
    );

    // ʱ������
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // ����100MHzʱ��
    end

    // ���Թ���
    initial begin
        // ��ʼ���ź�
        rst = 1;
        switch = 8'b00000000; // ��ʼ�����뿪��Ϊ�͵�ƽ
        #50000;

        rst = 0; // �����λ

        // ���Բ�ͬ�Ĳ��뿪�����
        switch = 8'b00011111; // 5���ߵ�ƽ
        #1000000000; // �ȴ�һ��ʱ��۲� LED �仯

        switch = 8'b11111111; // 8���ߵ�ƽ
        #1000000000;

        switch = 8'b00000000; // 0���ߵ�ƽ
        #1000000000;

        switch = 8'b00000111; // 3���ߵ�ƽ
        #1000000000;

        switch = 8'b11111110; // 7���ߵ�ƽ
        #1000000000;

        // ������ɣ���������
        $finish;
    end

endmodule
