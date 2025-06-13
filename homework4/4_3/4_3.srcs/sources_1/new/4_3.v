`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/28 20:30:35
// Design Name: 
// Module Name: PalindromicSequenceDetector
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


module PalindromicSequenceDetector (
    input wire CLK,      // 时钟信号
    input wire IN,       // 数据输入
    output wire OUT      // 输出
);

    reg [4:0] shift_reg = 5'b00000; // 5位移位寄存器

    // 在时钟上升沿，移位寄存器更新
    always @(posedge CLK) begin
        // 在时钟上升沿，将前四位左移，并将当前输入IN移入最低位
        shift_reg <= {shift_reg[3:0], IN};
    end

    // 检查当前输入IN与shift_reg内容是否构成回文序列
    assign OUT = (shift_reg[3] == IN) && (shift_reg[2] == shift_reg[0]);

endmodule

