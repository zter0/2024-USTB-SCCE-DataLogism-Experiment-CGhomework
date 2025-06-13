`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/22 11:14:12
// Design Name: 
// Module Name: reaction_timer
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

/*
module breathing_led (
    input wire clk,         // 100MHzʱ������
    input wire rst_n,       // �͵�ƽ��λ
    output reg led      // ���������
);

    reg [31:0] cnt;         // ���ڼ�ʱ�ļ�����
    reg divclk = 0;
    reg [31:0] pwm_cnt;     // PWM������
    reg [16:0] brightness;  // ��ǰ����ֵ
    reg direction;          // ���ȱ仯����1��ʾ���ӣ�0��ʾ����

    // ����������ֵ�����Ȳ���
    parameter CNT_MAX = 10000000 / 2;      // ������������ 10MHz����ǰԼ10ms����һ������
    parameter BRIGHTNESS_MAX = 1000000;     // �������ֵ1M��Ҳ��pwm��ʱ�����ڣ�1ms��
    parameter BRIGHTNESS_STEP = BRIGHTNESS_MAX / 25;      // ÿ�θ������ӻ�������� 4%

    // ��ʱ��
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
        end else if (cnt < CNT_MAX - 1) begin
            cnt <= cnt + 1;
        end else begin
            divclk = ~divclk;
            cnt <= 0;
        end
    end

    // ���ȿ���
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            brightness <= 0;
            direction <= 1; // ��ʼΪ��������
        end else if (divclk) begin
            if (direction) begin
                if (brightness + BRIGHTNESS_STEP >= BRIGHTNESS_MAX) begin
                    brightness <= BRIGHTNESS_MAX;
                    direction <= 0; // �ﵽ������ȣ���ʼ����
                end else begin
                    brightness <= brightness + BRIGHTNESS_STEP;
                end
            end else begin
                if (brightness <= BRIGHTNESS_STEP) begin
                    brightness <= 0;
                    direction <= 1; // �ﵽ��С���ȣ���ʼ����
                end else begin
                    brightness <= brightness - BRIGHTNESS_STEP;
                end
            end
        end
    end

    // PWM����
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pwm_cnt <= 0;
            led <= 0;
        end else begin
            if(pwm_cnt < BRIGHTNESS_MAX - 1) begin // ÿ�����п����ж���ʱ��������
                pwm_cnt <= pwm_cnt + 1;
            end else begin
                pwm_cnt <= 0;
            end
        end
        
        if (pwm_cnt > brightness) begin
            led <= 1; // LED��
        end else begin
            led <= 0; // LED��
        end
    end

endmodule
*/

module breathing_led (
    input wire clk,         // 100MHzʱ������
    input wire rst_n,       // �͵�ƽ��λ
    output wire led          // ���������
);

    reg [31:0] cnt;         // ���ڼ�ʱ�ļ�����
    reg [31:0] pwm_cnt;     // PWM������
    reg [16:0] brightness;  // ��ǰ����ֵ
    reg direction;          // ���ȱ仯����1��ʾ���ӣ�0��ʾ����

    // ����������ֵ�����Ȳ���
    parameter CNT_MAX = 10000000;        // �����������ڣ���ǰԼ100ms����һ�����ȣ���ʱ��2.5s
    parameter BRIGHTNESS_MAX = 10000;    // �������ֵ��Ҳ��pwm��ʱ�����ڣ�100us��
    parameter BRIGHTNESS_STEP = BRIGHTNESS_MAX / 25; // ÿ�θ������ӻ�������� 4%

    // ���ȿ���
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            brightness <= 0;
            direction <= 1; // ��ʼΪ��������
        end else begin
            if (cnt < CNT_MAX - 1) begin
                cnt <= cnt + 1;
            end else begin
                cnt <= 0;
                if (direction) begin
                    if (brightness + BRIGHTNESS_STEP >= BRIGHTNESS_MAX) begin
                        brightness <= BRIGHTNESS_MAX;
                        direction <= 0; // �ﵽ������ȣ���ʼ����
                    end else begin
                        brightness <= brightness + BRIGHTNESS_STEP;
                    end
                end else begin
                    if (brightness <= BRIGHTNESS_STEP) begin
                        brightness <= 0;
                        direction <= 1; // �ﵽ��С���ȣ���ʼ����
                    end else begin
                        brightness <= brightness - BRIGHTNESS_STEP;
                    end
                end
            end
        end
    end

    // PWM����
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pwm_cnt <= 0;
        end else begin
            if (pwm_cnt < BRIGHTNESS_MAX - 1) begin
                pwm_cnt <= pwm_cnt + 1;
            end else begin
                pwm_cnt <= 0;
            end
        end
    end
    
    assign led = (pwm_cnt < brightness) ? 1 : 0;

endmodule
