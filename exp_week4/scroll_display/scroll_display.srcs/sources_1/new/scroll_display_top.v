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

module scroll_display (
    input wire clk,         // ʱ���źţ�����100MHz
    input wire rst_n,       // �͵�ƽ��λ
    output reg [7:0] seg,   // ����ܶ������
    output reg [3:0] an     // �����λѡ�źţ���4λ��
);

    reg [39:0] char_map = 40'b1110_0010_0000_0010_0011_0100_0010_0110_0010_1001; // U202342629

    reg [31:0] scroll_cnt;
    parameter SCROLL_DELAY = 33333333;
    wire [3:0] new_char = char_map[39:36];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scroll_cnt <= 0;
            char_map <= 40'b1110_0010_0000_0010_0011_0100_0010_0110_0010_1001;
        end else if (scroll_cnt < SCROLL_DELAY - 1) begin
            scroll_cnt <= scroll_cnt + 1;
        end else begin
            scroll_cnt <= 0;
            char_map <= {char_map[35:0], new_char};
        end
    end

    reg [1:0] scan_pos;
    reg [31:0] scan_cnt;
    parameter SCAN_DELAY = 526315; // 190Hzˢ�¼�� (100MHz / 190)

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

    // ������
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
            4'hE: decode_7seg = 8'b0011_1110; // U
            default: decode_7seg = 8'b0000_0000; // �հ�
        endcase
    endfunction

    always @(*) begin
        case (scan_pos)
            2'b00: begin
                an = 4'b1000;
                seg = decode_7seg(char_map[39:36]);
            end
            2'b01: begin
                an = 4'b0100;
                seg = decode_7seg(char_map[35:32]);
            end
            2'b10: begin
                an = 4'b0010;
                seg = decode_7seg(char_map[31:28]);
            end
            2'b11: begin
                an = 4'b0001;
                seg = decode_7seg(char_map[27:24]);
            end
        endcase
    end

endmodule
