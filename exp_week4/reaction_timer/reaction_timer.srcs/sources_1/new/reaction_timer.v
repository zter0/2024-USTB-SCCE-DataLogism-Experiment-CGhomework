`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/22 11:14:12
// Design Name: 
// Module Name: reaction_timer
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

module reaction_timer (
    input wire clk,        // ʱ���ź�
    input wire reset,      // ��λ�ź�
    input wire btn_start_raw,  // ԭʼ��ʼ��ť
    input wire btn_stop_raw,   // ԭʼֹͣ��ť
    output reg led,        // LED ��
    output reg [3:0] pos,
    output reg [7:0] seg
);

    // ������İ����ź�
    wire btn_start;
    wire btn_stop;

    // ʵ��������ģ��
    debounce debounce_start (
        .clk(clk),
        .btn_in(btn_start_raw),
        .btn_out(btn_start)
    );

    debounce debounce_stop (
        .clk(clk),
        .btn_in(btn_stop_raw),
        .btn_out(btn_stop)
    );

    // ԭ����״̬�����벿�֣����ֲ��䣩
    parameter IDLE = 2'b00;
    parameter TIMING = 2'b01;
    parameter FINISHED = 2'b10;
    parameter INVALID = 2'b11;

    reg [1:0] current_state, next_state;

    reg [31:0] counter; // ������
    parameter CLK_FREQ = 100000000; // ����ʱ��Ƶ��Ϊ 100MHz
    parameter TIME_UNIT = CLK_FREQ / 100; // ÿ 10 ����ļ���ֵ

    // ״̬�Ĵ����߼�
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    reg [15:0] tme; // ��ʱ�������λΪ 10 ����

    // ����߼��ͼ�ʱ���߼�
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            led <= 0;
            counter <= 0;
            tme <= 0;
        end else begin
            case (current_state)
                IDLE: begin
                    led <= 0;
                    counter <= 0;
                    tme <= 0;
                end

                TIMING: begin
                    led <= 1; // LED ����
                    counter <= counter + 1;
                    if (counter == TIME_UNIT) begin
                        counter <= 0;
                        tme <= tme + 1; // ÿ 10 ����� 1
                    end
                end

                FINISHED: begin
                    led <= 0; // LED Ϩ��
                    counter <= 0; // ֹͣ��ʱ
                end

                INVALID: begin
                    led <= 0;
                    tme <= 99;
                    counter <= 0;
                end
            endcase
        end
    end

    // ״̬ת���߼������ֲ��䣩
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (btn_start) begin
                    next_state = TIMING;
                end else begin
                    next_state = IDLE;
                end
            end

            TIMING: begin
                if (btn_stop) begin
                    if(tme > 10) begin
                        next_state = FINISHED;
                    end else begin
                        next_state = INVALID;
                    end
                end else begin
                    next_state = TIMING;
                end
            end

            FINISHED: begin
                next_state = FINISHED; // �ȴ����¿�ʼ
            end

            INVALID: begin
                next_state = INVALID;
            end

            default: next_state = IDLE;
        endcase
    end
    
    // ��Ƶʵ�������

    reg         disp_bit = 0;
    reg [18:0]  divclk_cnt = 0;
    reg         divclk = 0;

    always@(posedge clk) begin
        if(divclk_cnt == 16'd50000) begin
            divclk <= ~divclk;
            divclk_cnt <= 0;
        end
        else
            divclk_cnt <= divclk_cnt + 1'b1;
    end

    reg [3:0] tme1, tme2;

    always @(posedge clk) begin
	   if(divclk) begin
            disp_bit <= ~disp_bit;
            tme1 <= tme % 10;
            tme2 <= tme / 10;
            if(disp_bit) begin    
                pos = 4'b0010;
                case(tme1)
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
                pos = 4'b0001;
                case(tme2)
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
