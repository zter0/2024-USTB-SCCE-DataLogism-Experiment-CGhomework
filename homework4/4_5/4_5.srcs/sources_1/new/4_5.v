`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/30 17:52:07
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
    input enable,
    output [3:0] Q
);

    reg [3:0]q;
    
    always @(posedge clk) begin  
        if (reset) 
            q <= 4'b0001;  
        else if(enable) begin  
            if (q == 4'd12)
                q <= 4'd0001;  
            else
                q <= q + 1;  
        end  
    end  
    
    assign Q = q;

endmodule
