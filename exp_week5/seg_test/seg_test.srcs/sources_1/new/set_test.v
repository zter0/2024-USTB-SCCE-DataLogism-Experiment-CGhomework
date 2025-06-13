module SevenSegmentDisplay(
    input clk,
    input rst,
    input [15:0] data,    // Data to display
    input [7:0] pc,
    output reg [3:0] pos_high,
    output reg [3:0] pos_low,
    output reg [7:0] seg_high,
    output reg [7:0] seg_low
);

    // Hexadecimal to 7-segment mapping function
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
    
    reg [3:0] digit; // Current digit being processed
    reg [63:0] seg_out; // Outputs for 8 seven-segment displays
    // Clock divider and scan logic for multiplexing the display
    reg [2:0] scan_pos;
    reg [31:0] scan_cnt;
    parameter SCAN_DELAY = 250000;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            digit = 0;
            scan_cnt = 0;
            scan_pos = 0;
            seg_out = 0;
        end else if (scan_cnt < SCAN_DELAY - 1) begin
            scan_cnt = scan_cnt + 1;
        end else begin
            scan_cnt = 0;
            scan_pos = scan_pos + 1;
            case (scan_pos)
                3'd0: digit = data % 10;
                3'd1: digit = data / 10 % 10;
                3'd2: digit = data / 100 % 10;
                3'd3: digit = data / 1000 % 10;
                3'd4: digit = data / 10000 % 10;
                3'd5: digit = pc % 10;
                3'd6: digit = pc / 10 % 10;
                3'd7: digit = pc / 100 % 10;
                default: digit = 4'hA;
            endcase
            seg_out[scan_pos * 8 +: 8] = hex_to_8seg(digit);
        end
    end

    always @(*) begin
        case (scan_pos)
            3'b000: begin
                pos_high = 4'b1000;
                seg_high = seg_out[63:56];
            end
            3'b001: begin
                pos_high = 4'b0100;
                seg_high = seg_out[55:48];
            end
            3'b010: begin
                pos_high = 4'b0010;
                seg_high = seg_out[47:40];
            end
            3'b011: begin
                pos_high = 4'b0001;
                seg_high = seg_out[39:32];
            end
            3'b100: begin
                pos_low = 4'b1000;
                seg_low = seg_out[31:24];
            end
            3'b101: begin
                pos_low = 4'b0100;
                seg_low = seg_out[23:16];
            end
            3'b110: begin
                pos_low = 4'b0010;
                seg_low = seg_out[15:8];
            end
            3'b111: begin
                pos_low = 4'b0001;
                seg_low = seg_out[7:0];
            end
        endcase
    end
endmodule
