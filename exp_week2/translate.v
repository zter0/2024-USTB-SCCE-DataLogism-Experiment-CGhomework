`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/13 16:49:17
// Design Name: 
// Module Name: translate
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

// id 模块
module id(
    input wire [15:0] fs_to_ds_bus,
    output wire [27:0] ds_to_es_bus,
    output wire [1:0] rx,
    output wire [1:0] ry,
    input wire [7:0] rx_value,
    input wire [7:0] ry_value 
);

    // 定义 wire 以接收独热码译码器的输出
    wire [3:0] onehot_output;

    // 实例化独热码译码器模块
    binary_to_onehot decoder (
        .binary_in(fs_to_ds_bus[7:4]),  // 输入为 fs_to_ds_bus 的 7:4 位
        .onehot_out(onehot_output)        // 输出到 onehot_output
    );

    // 连续赋值
    assign rx = fs_to_ds_bus[1:0];
    assign ry = fs_to_ds_bus[3:2];       

    // 使用 onehot_output 作为 ds_to_es_bus[27:24] 的值
    assign ds_to_es_bus[27:24] = onehot_output;
    assign ds_to_es_bus[23:16] = ry_value[7:0];
    assign ds_to_es_bus[15:8]  = rx_value[7:0];
    assign ds_to_es_bus[7:0]   = fs_to_ds_bus[15:8];

endmodule

// 独热码译码器模块
module binary_to_onehot (
    input wire [3:0] binary_in,  // 4 位输入
    output reg [3:0] onehot_out  // 4 位独热码输出
);

    always @(*) begin
        case (binary_in)
            4'b0001: onehot_out = 4'b1000;  // 对应独热码 0001
            4'b0010: onehot_out = 4'b0100;  // 对应独热码 0010
            4'b0011: onehot_out = 4'b0010;  // 对应独热码 0100
            4'b0100: onehot_out = 4'b0001;  // 对应独热码 1000
            default: onehot_out = 4'b0000;  // 其他输入时输出 0000
        endcase
    end

endmodule