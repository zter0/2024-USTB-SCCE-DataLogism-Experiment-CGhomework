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

// id ģ��
module id(
    input wire [15:0] fs_to_ds_bus,
    output wire [27:0] ds_to_es_bus,
    output wire [1:0] rx,
    output wire [1:0] ry,
    input wire [7:0] rx_value,
    input wire [7:0] ry_value 
);

    // ���� wire �Խ��ն����������������
    wire [3:0] onehot_output;

    // ʵ����������������ģ��
    binary_to_onehot decoder (
        .binary_in(fs_to_ds_bus[7:4]),  // ����Ϊ fs_to_ds_bus �� 7:4 λ
        .onehot_out(onehot_output)        // ����� onehot_output
    );

    // ������ֵ
    assign rx = fs_to_ds_bus[1:0];
    assign ry = fs_to_ds_bus[3:2];       

    // ʹ�� onehot_output ��Ϊ ds_to_es_bus[27:24] ��ֵ
    assign ds_to_es_bus[27:24] = onehot_output;
    assign ds_to_es_bus[23:16] = ry_value[7:0];
    assign ds_to_es_bus[15:8]  = rx_value[7:0];
    assign ds_to_es_bus[7:0]   = fs_to_ds_bus[15:8];

endmodule

// ������������ģ��
module binary_to_onehot (
    input wire [3:0] binary_in,  // 4 λ����
    output reg [3:0] onehot_out  // 4 λ���������
);

    always @(*) begin
        case (binary_in)
            4'b0001: onehot_out = 4'b1000;  // ��Ӧ������ 0001
            4'b0010: onehot_out = 4'b0100;  // ��Ӧ������ 0010
            4'b0011: onehot_out = 4'b0010;  // ��Ӧ������ 0100
            4'b0100: onehot_out = 4'b0001;  // ��Ӧ������ 1000
            default: onehot_out = 4'b0000;  // ��������ʱ��� 0000
        endcase
    end

endmodule