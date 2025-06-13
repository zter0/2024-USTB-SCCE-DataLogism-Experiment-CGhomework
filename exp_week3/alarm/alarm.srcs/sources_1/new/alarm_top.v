`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/04 16:01:11
// Design Name: 
// Module Name: alarm
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

/**
 *                    _ooOoo_
 *                   o8888888o
 *                   88" . "88
 *                   (| -_- |)
 *                    O\ = /O
 *                ____/`---'\____
 *              .   ' \\| |// `.
 *               / \\||| : |||// \
 *             / _||||| -:- |||||- \
 *               | | \\\ - /// | |
 *             | \_| ''\---/'' | |
 *              \ .-\__ `-` ___/-. /
 *           ___`. .' /--.--\ `. . __
 *        ."" '< `.___\_<|>_/___.' >'"".
 *       | | : `- \`.;`\ _ /`;.`/ - ` : | |
 *         \ \ `-. \_ __\ /__ _/ .-` / /
 * ======`-.____`-.___\_____/___.-`____.-'======
 *                    `=---='
 *
 * .............................................
 *          佛祖保佑             永无BUG
 */

module alarm_top(
    input wire         rst,
    input wire         cle,
    input wire         clk,
    input wire         act, // B1
    input wire [1:0]   swc, // k1, k2
    output reg [3:0]   pos, // seg pos
    output reg [7:0]   seg, // seg msg
    output reg         led // flashing les
);

    reg [3:0]  tme1 = 0, tme2 = 0;   // remember times of pushing B1
    reg [6:0]  tme = 0;
    wire       clk_bps;
    reg [14:0] counter_first = 0, counter_second = 0;
	reg [3:0]  speed;
    
    integer i; // get k1 & k2's condition
    always @(*) begin
        speed = 0;
        for(i = 0; i < 2; i = i + 1) begin
            if(swc[i] == 1)
                speed = speed + 1; 
        end
        speed = speed * 2;
        if(speed == 0)
            speed = 1;
    end // set speed
    
	always @(posedge clk or posedge rst) begin
        if (rst) 
            counter_first <= 14'b0;
        else 
            if (counter_first == 14'd9999) 
                counter_first <= 14'b0;
            else 
                counter_first <= counter_first +1;
    end
    

    always @(posedge clk or posedge rst) begin
        if (rst) 
            counter_second <= 14'b0;
        else        
            if (counter_second == (14'd9999 - tme * 100) / speed) 
                counter_second <= 14'b0;
            else 
                if (counter_first == 14'd9999) 
                    counter_second <= counter_second + 1;
    end

    assign clk_bps = (counter_second == (14'd9999 - tme * 100) / speed);
	// divide 
	
	reg [19:0] debounce_counter; // 去抖动计数器
    reg act_stable = 0;           // 稳定的按钮状态
    reg act_prev = 0;             // 上一个按钮状态
    reg alarm = 0;

    // 去抖动处理模块
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            debounce_counter <= 0;
            act_stable <= 0;
        end else begin
            // 如果按钮状态发生变化，则开始计时去抖
            if (act != act_stable) begin
                debounce_counter <= debounce_counter + 1;
                // 如果计数器达到阈值，确认状态变化
                if (debounce_counter == 20'd1000000) begin
                    debounce_counter <= 0;
                    act_stable <= act;
                end
            end else begin
                debounce_counter <= 0;
            end
        end
    end
    
    // 按钮开关状态切换逻辑
    
    always @(posedge clk) begin
        if(rst) begin 
            led <= 0;
            act_prev <= 0;
            alarm <= 0;
            tme1 <= 4'b0000;
            tme2 <= 4'b0000;
            tme <= 6'b000000;
        end
        else if(cle) begin
            tme1 <= 4'b0001;
            tme2 <= 4'b0000;
            tme <= 6'b000001;
        end
        else if (act_stable && !act_prev) begin
            alarm = ~alarm;
            if(alarm) begin
                tme1 = tme1 + 1;
                if (tme1 == 4'b1010) begin
                    tme1 = 4'b0000;
                    tme2 = tme2 + 1;
                end
                tme = tme2 * 10 + tme1;
            end
        end 
        
        act_prev <= act_stable;
        
        if (alarm && clk_bps)
            led <= ~led;
        else if(!alarm)
            led <= 0;
    end
    
    

    // clk_bps is too slow, make another divclk for 1kHz
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

	always @(posedge clk) begin
	   if(divclk) begin
            disp_bit <= ~disp_bit;
            if(disp_bit) begin    
                pos = 4'b0001;
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
                pos = 4'b0010;
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