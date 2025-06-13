module SevenSegmentDisplay(
    input clk,
    input rst,
    input [15:0] data,
    input [7:0] pc,
    output reg [3:0] pos_high,
    output reg [3:0] pos_low,
    output reg [7:0] seg_high,
    output reg [7:0] seg_low
);

    reg [2:0] scan_pos;
    reg [31:0] scan_cnt;
    parameter SCAN_DELAY = 250000;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            scan_cnt <= 0;
            scan_pos <= 0;
        end else if (scan_cnt < SCAN_DELAY - 1) begin
            scan_cnt <= scan_cnt + 1;
        end else begin
            scan_cnt <= 0;
            if(scan_pos == 7)
                scan_pos <= 3'b000;
            else
                scan_pos <= scan_pos + 1;
        end
    end
    
    function [7:0] hex_to_8seg;
        input [3:0] hex;
        begin
            case (hex)
                4'h0: hex_to_8seg = 8'b0011_1111;
                4'h1: hex_to_8seg = 8'b0000_0110;
                4'h2: hex_to_8seg = 8'b0101_1011;
                4'h3: hex_to_8seg = 8'b0100_1111;
                4'h4: hex_to_8seg = 8'b0110_0110;
                4'h5: hex_to_8seg = 8'b0110_1101;
                4'h6: hex_to_8seg = 8'b0111_1101;
                4'h7: hex_to_8seg = 8'b0000_0111;
                4'h8: hex_to_8seg = 8'b0111_1111;
                4'h9: hex_to_8seg = 8'b0110_1111;
                default: hex_to_8seg = 8'b0000_0000;
            endcase
        end
    endfunction    

    always @(*) begin
        case (scan_pos)
            3'b000: begin
                pos_high = 4'b1000;
                pos_low = 4'b0000;
                seg_high =  hex_to_8seg(pc / 100 % 10);
                seg_low = hex_to_8seg(4'hA);
            end
            3'b001: begin
                pos_high = 4'b0100;
                pos_low = 4'b0000;
                seg_high = hex_to_8seg(pc / 10 % 10);
                seg_low = hex_to_8seg(4'hA);
            end
            3'b010: begin
                pos_high = 4'b0010;
                pos_low = 4'b0000;
                seg_high = hex_to_8seg(pc % 10);
                seg_low = hex_to_8seg(4'hA);
            end
            3'b011: begin
                pos_high = 4'b0001;
                pos_low = 4'b0000;
                seg_high = hex_to_8seg(data / 10000 % 10);
                seg_low = hex_to_8seg(4'hA);
            end
            3'b100: begin
                pos_high = 4'b0000;
                pos_low = 4'b1000;
                seg_low = hex_to_8seg(data / 1000 % 10);
                seg_high = hex_to_8seg(4'hA);
            end
            3'b101: begin
                pos_high = 4'b0000;
                pos_low = 4'b0100;
                seg_low = hex_to_8seg(data / 100 % 10);
                seg_high = hex_to_8seg(4'hA);
            end
            3'b110: begin
                pos_high = 4'b0000;
                pos_low = 4'b0010;
                seg_low = hex_to_8seg(data / 10 % 10);
                seg_high = hex_to_8seg(4'hA);
            end
            3'b111: begin
                pos_high = 4'b0000;
                pos_low = 4'b0001;
                seg_low = hex_to_8seg(data % 10);
                seg_high = hex_to_8seg(4'hA);
            end
        endcase
    end
endmodule
