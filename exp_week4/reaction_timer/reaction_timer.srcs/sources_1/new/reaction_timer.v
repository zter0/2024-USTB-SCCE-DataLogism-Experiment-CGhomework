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

module reaction_timer (
    input wire clk,        // 时钟信号
    input wire reset,      // 复位信号
    input wire btn_start_raw,  // 原始开始按钮
    input wire btn_stop_raw,   // 原始停止按钮
    output reg led,        // LED 灯
    output reg [3:0] pos,
    output reg [7:0] seg
);

    // 消抖后的按键信号
    wire btn_start;
    wire btn_stop;

    // 实例化消抖模块
    debounce debounce_start (
        .clk(clk),
        .btn_in(btn_start_raw),
        .btn_out(btn_start)
    );

    debounce debounce_stop (
        .clk(clk),
        .btn_in(btn_stop_raw),
        .btn_out(btn_stop)
    );

    // 原来的状态机代码部分（保持不变）
    parameter IDLE = 2'b00;
    parameter TIMING = 2'b01;
    parameter FINISHED = 2'b10;
    parameter INVALID = 2'b11;

    reg [1:0] current_state, next_state;

    reg [31:0] counter; // 计数器
    parameter CLK_FREQ = 100000000; // 假设时钟频率为 100MHz
    parameter TIME_UNIT = CLK_FREQ / 100; // 每 10 毫秒的计数值

    // 状态寄存器逻辑
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    reg [15:0] tme; // 计时结果，单位为 10 毫秒

    // 输出逻辑和计时器逻辑
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            led <= 0;
            counter <= 0;
            tme <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    led <= 0;
                    counter <= 0;
                    tme <= 0;
                end

                TIMING: begin
                    led <= 1; // LED 点亮
                    counter <= counter + 1;
                    if (counter == TIME_UNIT) begin
                        counter <= 0;
                        tme <= tme + 1; // 每 10 毫秒加 1
                    end
                end

                FINISHED: begin
                    led <= 0; // LED 熄灭
                    counter <= 0; // 停止计时
                end

                INVALID: begin
                    led <= 0;
                    tme <= 99;
                    counter <= 0;
                end
            endcase
        end
    end

    // 状态转移逻辑（保持不变）
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (btn_start) begin
                    next_state = TIMING;
                end else begin
                    next_state = IDLE;
                end
            end

            TIMING: begin
                if (btn_stop) begin
                    if(tme > 10) begin
                        next_state = FINISHED;
                    end else begin
                        next_state = INVALID;
                    end
                end else begin
                    next_state = TIMING;
                end
            end

            FINISHED: begin
                next_state = FINISHED; // 等待重新开始
            end

            INVALID: begin
                next_state = INVALID;
            end

            default: next_state = IDLE;
        endcase
    end
    
    // 分频实现数码管

    reg         disp_bit = 0;
    reg [18:0]  divclk_cnt = 0;
    reg         divclk = 0;

    always@(posedge clk) begin
        if(divclk_cnt == 16'd50000) begin
            divclk <= ~divclk;
            divclk_cnt <= 0;
        end
        else
            divclk_cnt <= divclk_cnt + 1'b1;
    end

    reg [3:0] tme1, tme2;

    always @(posedge clk) begin
	   if(divclk) begin
            disp_bit <= ~disp_bit;
            tme1 <= tme % 10;
            tme2 <= tme / 10;
            if(disp_bit) begin    
                pos = 4'b0010;
                case(tme1)
                    4'b0000:seg = 8'b0011_1111;
                    4'b0001:seg = 8'b0000_0110;
                    4'b0010:seg = 8'b0101_1011;
                    4'b0011:seg = 8'b0100_1111;
                    4'b0100:seg = 8'b0110_0110;
                    4'b0101:seg = 8'b0110_1101;
                    4'b0110:seg = 8'b0111_1101;
                    4'b0111:seg = 8'b0000_0111;
                    4'b1000:seg = 8'b0111_1111;
                    4'b1001:seg = 8'b0110_1111;
                    default:seg = 8'b0000_0000;
                endcase
            end
            else begin
                pos = 4'b0001;
                case(tme2)
                    4'b0000:seg = 8'b0011_1111;
                    4'b0001:seg = 8'b0000_0110;
                    4'b0010:seg = 8'b0101_1011;
                    4'b0011:seg = 8'b0100_1111;
                    4'b0100:seg = 8'b0110_0110;
                    4'b0101:seg = 8'b0110_1101;
                    4'b0110:seg = 8'b0111_1101;
                    4'b0111:seg = 8'b0000_0111;
                    4'b1000:seg = 8'b0111_1111;
                    4'b1001:seg = 8'b0110_1111;
                    default:seg = 8'b0000_0000;
                endcase	
            end
        end
	end

endmodule
