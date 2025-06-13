`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/04 16:01:11
// Design Name: 
// Module Name: alarm
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

module counter (
    input wire       clk,
	input wire       rst,
	input wire [2:0] switch_count,
	input wire [6:0] tme,
	output wire      clk_bps
);

	reg [14:0] counter_first, counter_second;
	reg [3:0] speed;

	always @(*) begin
        speed = switch_count;
        if (speed == 0)
            speed = 1;        
    end

	always @(posedge clk or posedge rst) begin
        if (rst) 
            counter_first <= 14'b0;
        else 
            if (counter_first == 14'd9999) 
                counter_first <= 14'b0;
            else 
                counter_first <= counter_first +1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) 
            counter_second <= 14'b0;
        else        
            if (counter_second == (14'd9999 - tme * 10) / speed) 
                counter_second <= 14'b0;
            else 
                if (counter_first == 14'd9999) 
                    counter_second <= counter_second + 1;
    end

  assign clk_bps = (counter_second == (14'd9999 - tme * 10) / speed);
  
endmodule