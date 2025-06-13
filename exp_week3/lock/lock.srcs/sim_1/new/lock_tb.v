`timescale 1ns / 1ps

module lock_tb;

// 信号声明
    reg clk;
    reg rst;
    reg in;
    wire unlock;
    
    // 实例化密码锁模块
    lock uut (
        .clk(clk),
        .rst(rst),
        .in(in),
        .unlock(unlock)
    );
    
    // 时钟生成
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 每5ns翻转一次，产生10ns的时钟周期
    end
    
    // 测试过程
    initial begin
        // 初始化
        rst = 1;
        in = 0;
        #20; // 复位保持一段时间
    
        rst = 0; // 取消复位
    
        // 随机输入 0 和 1，持续一段时间观察解锁信号
        repeat (50) begin
            in = $random % 2; // 生成随机的0或1
            #10; // 每10ns改变一次输入信号
        end
    
        // 手动输入 "0010" 来检查解锁状态
        #10 in = 0;
        #10 in = 0;
        #10 in = 1;
        #10 in = 0;
    
        // 等待一段时间观察解锁信号
        #50;
    
        // 测试结束
        $finish;
    end
    
    // 监视输出
    initial begin
        $monitor("Time = %0t | in = %b | unlock = %b", $time, in, unlock);
    end

endmodule
