`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/30 17:58:57
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
    input reset,
    output [3:0] q
);

    reg [3:0] Q;
    
    always @(posedge clk) begin  
        if (reset) 
            Q <= 4'b0000;  
        else begin  
            if (Q == 4'd15)  
                Q <= 4'd0;  
            else
                Q <= Q + 1;   
        end  
    end  
    
    assign q = Q;
    
endmodule
