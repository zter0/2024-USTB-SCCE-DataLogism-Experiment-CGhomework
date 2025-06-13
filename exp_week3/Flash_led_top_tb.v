`timescale 1ns / 1ps

module tb_flash_led_top;

    // 输入信号
    reg clk;
    reg rst;
    reg [7:0] switch;

    // 输出信号
    wire [15:0] led;
    wire CLK_BPS;
    
    // 实例化顶层模块
    flash_led_top dut (
        .clk(clk),
        .rst(rst),
        .switch(switch),
        .led(led),
        .CLK_BPS(CLK_BPS)
    );

    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 生成100MHz时钟
    end

    // 测试过程
    initial begin
        // 初始化信号
        rst = 1;
        switch = 8'b00000000; // 初始化拨码开关为低电平
        #50000;

        rst = 0; // 解除复位

        // 测试不同的拨码开关组合
        switch = 8'b00011111; // 5个高电平
        #1000000000; // 等待一段时间观察 LED 变化

        switch = 8'b11111111; // 8个高电平
        #1000000000;

        switch = 8'b00000000; // 0个高电平
        #1000000000;

        switch = 8'b00000111; // 3个高电平
        #1000000000;

        switch = 8'b11111110; // 7个高电平
        #1000000000;

        // 测试完成，结束仿真
        $finish;
    end

endmodule
