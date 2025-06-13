module flash_led_top(
    input  wire        clk,        // 系统时钟
    input  wire        rst,        // 复位信号
    input  wire [7:0]  switch,     // 拨码开关输入
    output wire [15:0] led         // LED 输出
);
    
    reg [3:0] switch_count;
    wire clk_bps;                  // 低频时钟信号
    wire dir;                      // 移动方向信号

    assign dir = (switch_count < 4) ? 1'b1 : 1'b0;

    // 计算高电平的拨码开关数量
    integer i;
    always @(*) begin
        switch_count = 0;
        for (i = 0; i < 8; i = i + 1) begin
            if (switch[i] == 1)
                switch_count = switch_count + 1;
        end
    end

    // 实例化计数器模块
    counter counter_inst (
        .clk(clk),
        .rst(rst),
        .switch_count(switch_count),
        .clk_bps(clk_bps)
    );
    
    // 实例化流水灯控制模块
    flash_led_ctl flash_led_ctl_inst (
        .clk(clk),
        .rst(rst),
        .dir(dir),
        .clk_bps(clk_bps),
        .led(led)
    );
    
endmodule
