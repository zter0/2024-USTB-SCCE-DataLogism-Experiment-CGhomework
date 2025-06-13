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


module top_module (  
    input clk,
    input reset,
    output reg [3:0] q
);  
  
    always @(posedge clk) begin  
        if (reset)
            q <= 4'b0001;  
        else begin  
            if (q == 4'd9) 
                q <= 4'd0;  
            else
                q <= q + 1;  
        end  
    end  
  
endmodule
