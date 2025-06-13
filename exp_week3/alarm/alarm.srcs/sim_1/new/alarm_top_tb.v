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

    // 输入信号
    reg rst;
    reg cle;
    reg clk;
    reg act; // B1
    reg [1:0] swc; // k1, k2

    // 输出信号
    wire [3:0] pos;  // seg pos
    wire [7:0] seg;  // seg msg
    wire led;         // flashing leds

    // 实例化待测试模块
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

    // 时钟生成：100MHz时钟
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz => 时钟周期 10ns
    end

    // 测试过程
    initial begin
        // 初始化信号
        rst = 1;
        cle = 0;
        act = 0;
        swc = 2'b00;

        // 复位阶段
        #500000000 rst = 0;  // 在20ns后释放复位

        // 随机按下act，并随机更改swc的值
        act = 1;  // 模拟按下按钮
        swc = 2'b10;  // k1 = 1, k2 = 0
        #500000000
        act = 0;  // 模拟释放按钮
        
        #3000000000; // 等待，观察波形
        
        swc = 2'b11;  // k1 = 1, k2 = 1
        act = 1;  // 再次模拟按下按钮
        #500000000
        act = 0;  // 模拟释放按钮
        
        #3000000000; // 等待，观察波形
        
        swc = 2'b01;  // k1 = 0, k2 = 1
        act = 1;  // 再次模拟按下按钮
        #500000000
        act = 0;  // 模拟释放按钮
        
        #3000000000; // 等待，观察波形
        
        swc = 2'b01;  // k1 = 0, k2 = 1
        act = 1;  // 再次模拟按下按钮
        #300000000
        act = 0;  // 模拟释放按钮
        
        // 按下cle清除时间
        #500000000; cle = 1;  // 激活清除信号
        #500000000 cle = 0; // 停止清除

        // 等待一段时间后结束仿真
        $finish;
    end

    // 监控输出，方便查看仿真过程
    initial begin
        $monitor("Time: %0t | rst: %b | cle: %b | act: %b | swc: %b | pos: %b | seg: %b | led: %b", 
                 $time, rst, cle, act, swc, pos, seg, led);
    end

endmodule
