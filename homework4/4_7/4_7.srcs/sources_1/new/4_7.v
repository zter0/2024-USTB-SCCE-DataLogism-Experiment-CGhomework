`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/30 18:41:38
// Design Name: 
// Module Name: top_module
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


module top_module (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else 
            if(ena) begin
                case (amount)
                    2'b10: q <= {q[63], q[63:1]};
                    2'b11: q <= {{8{q[63]}}, q[63:8]};
                    2'b00: q <= {q[62:0], 1'b0};
                    2'b01: q <= {q[55:0], 8'b00000000};
                    default: q <= q;
                endcase
            end
    end

endmodule