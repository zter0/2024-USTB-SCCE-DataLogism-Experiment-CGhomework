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
    input clk,                 // 时钟信号
    input rst_n,               // 异步复位信号
    input [3:0] button_raw,    // 原始按钮信号
    output reg [3:0] button    // 消抖后的按钮信号
);
    reg [3:0] button_sync1, button_sync2; // 同步寄存器
    reg [15:0] counter[3:0];              // 每个按钮的消抖计数器
    reg [3:0] stable;                     // 稳定信号

    parameter DEBOUNCE_TIME = 16'd50000;  // 假设消抖时间为 50000 个时钟周期

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
            // 同步原始按钮信号
            button_sync1 <= button_raw;
            button_sync2 <= button_sync1;

            // 消抖逻辑
            for (integer i = 0; i < 4; i = i + 1) begin
                if (button_sync2[i] == stable[i]) begin
                    counter[i] <= 16'd0; // 信号稳定时计数器清零
                end else begin
                    counter[i] <= counter[i] + 1; // 信号不稳定时开始计时
                    if (counter[i] >= DEBOUNCE_TIME) begin
                        stable[i] <= button_sync2[i]; // 达到消抖时间后更新稳定信号
                        counter[i] <= 16'd0; // 清零计数器
                    end
                end
            end

            // 更新消抖后的按钮信号
            button <= stable;
        end
    end
endmodule
