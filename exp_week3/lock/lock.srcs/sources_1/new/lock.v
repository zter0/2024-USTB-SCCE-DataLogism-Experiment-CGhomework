`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/05 16:54:41
// Design Name: 
// Module Name: lock
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


module lock (
    input clk,      // 时钟信号
    input rst,      // 复位信号
    input in,       // 输入信号
    output reg unlock // 解锁信号
);

    parameter IDLE = 3'b000;
    parameter S0 = 3'b001;
    parameter S00 = 3'b010;
    parameter S001 = 3'b011;
    parameter S0010 = 3'b100;
    
    reg [2:0] state, next_state;
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end
    
    always @(*) begin
        unlock = 1'b0;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = S0;
                else
                    next_state = IDLE;
            end
            S0: begin
                if (in == 1'b0)
                    next_state = S00;
                else
                    next_state = IDLE;
            end
            S00: begin
                if (in == 1'b1)
                    next_state = S001;
                else
                    next_state = S00;
            end
            S001: begin
                if (in == 1'b0)
                    next_state = S0010;
                else
                    next_state = IDLE;
            end
            S0010: begin
                unlock = 1'b1;
                next_state = S0010;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule


