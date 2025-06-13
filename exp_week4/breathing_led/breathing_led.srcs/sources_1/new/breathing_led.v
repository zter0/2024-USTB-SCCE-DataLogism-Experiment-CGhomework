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
    input wire clk,         // 100MHz时钟输入
    input wire rst_n,       // 低电平复位
    output reg led      // 呼吸灯输出
);

    reg [31:0] cnt;         // 用于计时的计数器
    reg divclk = 0;
    reg [31:0] pwm_cnt;     // PWM计数器
    reg [16:0] brightness;  // 当前亮度值
    reg direction;          // 亮度变化方向：1表示增加，0表示减少

    // 定义最大计数值及亮度步长
    parameter CNT_MAX = 10000000 / 2;      // 调节亮度周期 10MHz，当前约10ms更新一次亮度
    parameter BRIGHTNESS_MAX = 1000000;     // 最大亮度值1M，也是pwm的时钟周期（1ms）
    parameter BRIGHTNESS_STEP = BRIGHTNESS_MAX / 25;      // 每次更新增加或减少亮度 4%

    // 计时器
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

    // 亮度控制
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            brightness <= 0;
            direction <= 1; // 初始为亮度增加
        end else if (divclk) begin
            if (direction) begin
                if (brightness + BRIGHTNESS_STEP >= BRIGHTNESS_MAX) begin
                    brightness <= BRIGHTNESS_MAX;
                    direction <= 0; // 达到最大亮度，开始减少
                end else begin
                    brightness <= brightness + BRIGHTNESS_STEP;
                end
            end else begin
                if (brightness <= BRIGHTNESS_STEP) begin
                    brightness <= 0;
                    direction <= 1; // 达到最小亮度，开始增加
                end else begin
                    brightness <= brightness - BRIGHTNESS_STEP;
                end
            end
        end
    end

    // PWM控制
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pwm_cnt <= 0;
            led <= 0;
        end else begin
            if(pwm_cnt < BRIGHTNESS_MAX - 1) begin // 每周期中控制有多少时间是亮的
                pwm_cnt <= pwm_cnt + 1;
            end else begin
                pwm_cnt <= 0;
            end
        end
        
        if (pwm_cnt > brightness) begin
            led <= 1; // LED亮
        end else begin
            led <= 0; // LED灭
        end
    end

endmodule
*/

module breathing_led (
    input wire clk,         // 100MHz时钟输入
    input wire rst_n,       // 低电平复位
    output wire led          // 呼吸灯输出
);

    reg [31:0] cnt;         // 用于计时的计数器
    reg [31:0] pwm_cnt;     // PWM计数器
    reg [16:0] brightness;  // 当前亮度值
    reg direction;          // 亮度变化方向：1表示增加，0表示减少

    // 定义最大计数值及亮度步长
    parameter CNT_MAX = 10000000;        // 调节亮度周期，当前约100ms更新一次亮度，总时间2.5s
    parameter BRIGHTNESS_MAX = 10000;    // 最大亮度值，也是pwm的时钟周期（100us）
    parameter BRIGHTNESS_STEP = BRIGHTNESS_MAX / 25; // 每次更新增加或减少亮度 4%

    // 亮度控制
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cnt <= 0;
            brightness <= 0;
            direction <= 1; // 初始为亮度增加
        end else begin
            if (cnt < CNT_MAX - 1) begin
                cnt <= cnt + 1;
            end else begin
                cnt <= 0;
                if (direction) begin
                    if (brightness + BRIGHTNESS_STEP >= BRIGHTNESS_MAX) begin
                        brightness <= BRIGHTNESS_MAX;
                        direction <= 0; // 达到最大亮度，开始减少
                    end else begin
                        brightness <= brightness + BRIGHTNESS_STEP;
                    end
                end else begin
                    if (brightness <= BRIGHTNESS_STEP) begin
                        brightness <= 0;
                        direction <= 1; // 达到最小亮度，开始增加
                    end else begin
                        brightness <= brightness - BRIGHTNESS_STEP;
                    end
                end
            end
        end
    end

    // PWM控制
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
