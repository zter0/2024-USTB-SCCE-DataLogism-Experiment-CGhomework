`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/24 20:24:52
// Design Name: 
// Module Name: seg_controller
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


module seg_controller(
    input wire clk,
    input wire rst_n,
    input wire start_stop,
    input wire [3:0] button_raw,
    output reg [3:0] an_high,
    output reg [3:0] an_low,
    output reg [7:0] seg_high,
    output reg [7:0] seg_low
);

    // 时钟分频
    reg [2:0] scan_pos;
    reg [31:0] scan_cnt;
    parameter SCAN_DELAY = 250000; // 400Hz刷新间隔 (100MHz / 400)
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scan_cnt <= 0;
            scan_pos <= 0;
        end else if (scan_cnt < SCAN_DELAY - 1) begin
            scan_cnt <= scan_cnt + 1;
        end else begin
            scan_cnt <= 0;
            scan_pos <= scan_pos + 1;
        end
    end

    reg [31:0] tme_cnt;
    reg [7:0] tme = 8'b1001_1001;
    parameter TME_DELAY = 100000000; // 1Hz 刷新间隔

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tme <= 8'b1001_1001;
            tme_cnt <= 0;
        end else if (tme_cnt < TME_DELAY - 1) begin
            tme_cnt <= tme_cnt + 1;
        end else begin
            tme_cnt <= 0;
            if(start_stop)
                if(tme[3:0] > 0) begin
                    tme[3:0] <= tme[3:0] - 1'b1;
                end else if(tme[7:4] > 0) begin
                    tme[7:4] <= tme[7:4] - 1'b1;
                    tme[3:0] <= 4'b1001;
                end else begin
                    tme[7:0] <= 8'b0000_0000;
                end
        end
    end

    reg [3:0] counter[3:0];      // 4 个 4 位计数器输出
    wire [3:0] button;           // 消抖后的按键
    reg [3:0] button_prev;       // 用于存储按钮的前一个状态
    
     ButtonDebounce debounce (
        .clk(clk),
        .rst_n(rst_n),
        .button_raw(button_raw),
        .button(button)
    );
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            counter[0] <= 4'b0000;
            counter[1] <= 4'b0000;
            counter[2] <= 4'b0000;
            counter[3] <= 4'b0000;
            button_prev <= 4'b0000;
        end else begin
            for (integer i = 0; i < 4; i = i + 1) begin
                if (button[i] && ~button_prev[i]) begin
                    if (counter[i] == 4'd9)
                        counter[i] <= 4'd0;
                    else
                        counter[i] <= counter[i] + 4'd1;
                end
            end
            button_prev <= button; // 更新按钮状态
        end
    end

    // 解码器
    function [7:0] decode_7seg(input [3:0] value);
        case (value)
            4'h0: decode_7seg = 8'b0011_1111; // 0
            4'h1: decode_7seg = 8'b0000_0110; // 1
            4'h2: decode_7seg = 8'b0101_1011; // 2
            4'h3: decode_7seg = 8'b0100_1111; // 3
            4'h4: decode_7seg = 8'b0110_0110; // 4
            4'h5: decode_7seg = 8'b0110_1101; // 5
            4'h6: decode_7seg = 8'b0111_1101; // 6
            4'h7: decode_7seg = 8'b0000_0111; // 7
            4'h8: decode_7seg = 8'b0111_1111; // 8
            4'h9: decode_7seg = 8'b0110_1111; // 9
            default: decode_7seg = 8'b0000_0000; // 空白
        endcase
    endfunction

    always @(*) begin
        case (scan_pos)
            3'b000: begin
                an_high = 4'b1000;
                seg_high = 8'b0011_1101; //固定显示G
            end
            3'b001: begin
                an_high = 4'b0100;
                seg_high = 8'b0110_0100; //固定显示X
            end
            3'b010: begin
                an_high = 4'b0010;
                seg_high = decode_7seg(tme[7:4]);
            end
            3'b011: begin
                an_high = 4'b0001;
                seg_high = decode_7seg(tme[3:0]);
            end
            3'b100: begin
                an_low = 4'b1000;
                seg_low = decode_7seg(counter[3]);
            end
            3'b101: begin
                an_low = 4'b0100;
                seg_low = decode_7seg(counter[2]);
            end
            3'b110: begin
                an_low = 4'b0010;
                seg_low = decode_7seg(counter[1]);
            end
            3'b111: begin
                an_low = 4'b0001;
                seg_low = decode_7seg(counter[0]);
            end
        endcase
    end

endmodule
