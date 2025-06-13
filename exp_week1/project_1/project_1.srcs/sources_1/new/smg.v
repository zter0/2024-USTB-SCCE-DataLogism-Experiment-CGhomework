`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: ZTer
// 
// Create Date: 2024/09/23 17:41:06
// Design Name: 
// Module Name: connect
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

module segMsg(
    input wire act,
    input wire clk,
    output reg [3:0] pos,
    output reg [7:0] seg
    );
    
    reg [3:0] cnt;
    
    always @(posedge clk) begin
        if(act)
            cnt <= cnt + 1'b1;
    end

    reg          disp_bit = 0;
    reg [18:0]   divclk_cnt = 0;
    reg          divclk = 0;
    
    always@(posedge clk) begin
        if(divclk_cnt == 16'd50000) begin
            divclk <= ~divclk;
            divclk_cnt <= 0;
        end
        else
            divclk_cnt <= divclk_cnt + 1'b1;
    end

	always @(posedge clk) begin
	   if(divclk) begin
            disp_bit <= ~disp_bit;
            if(disp_bit) begin    
                pos = 4'b0001;
                case(cnt)
                    4'b0000:seg = 8'b0011_1111;
                    4'b0001:seg = 8'b0000_0110;
                    4'b0010:seg = 8'b0101_1011;
                    4'b0011:seg = 8'b0100_1111;
                    4'b0100:seg = 8'b0110_0110;
                    4'b0101:seg = 8'b0110_1101;
                    4'b0110:seg = 8'b0111_1101;
                    4'b0111:seg = 8'b0000_0111;
                    4'b1000:seg = 8'b0111_1111;
                    4'b1001:seg = 8'b0110_1111;
                    default:seg = 8'b0000_0000;
                endcase
            end
            else begin
                pos = 4'b0010;
                case(cnt - 1)
                    4'b0000:seg = 8'b0011_1111;
                    4'b0001:seg = 8'b0000_0110;
                    4'b0010:seg = 8'b0101_1011;
                    4'b0011:seg = 8'b0100_1111;
                    4'b0100:seg = 8'b0110_0110;
                    4'b0101:seg = 8'b0110_1101;
                    4'b0110:seg = 8'b0111_1101;
                    4'b0111:seg = 8'b0000_0111;
                    4'b1000:seg = 8'b0111_1111;
                    4'b1001:seg = 8'b0110_1111;
                    default:seg = 8'b0000_0000;
                endcase	
            end
        end
	end
endmodule