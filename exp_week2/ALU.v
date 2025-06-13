`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/16 14:25:15
// Design Name: 
// Module Name: sim_1
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

module ALU (
    input wire [7:0] alu_src1,
    input wire [7:0] alu_src2, 
    input wire [11:0] alu_op,
    output wire [7:0] alu_result
);

    reg [7:0] tmp_result;
    reg [3:0] tmp_op;
    reg [8:0] sum;
    integer counter, i;

    always @(*) begin
        case (alu_op)
            12'h001: tmp_result = alu_src1 + alu_src2;
            12'h002: tmp_result = alu_src1 - alu_src2;
            12'h004: tmp_result = alu_src1 & alu_src2;
            12'h008: tmp_result = (alu_src1 || alu_src2) ? 8'h01 : 8'h00;
            12'h010: tmp_result = alu_src1 << alu_src2[1:0];
            12'h020: tmp_result = alu_src1 >>> alu_src2[1:0];
            12'h040: begin
                tmp_result = alu_src1;
                counter = alu_src2[1:0];
                for (i = 0; i < counter ; i = i + 1) begin
                    tmp_result = {tmp_result[0], tmp_result[7:1]};
                end
            end
            12'h080: tmp_result = ($signed(alu_src1) < $signed(alu_src2)) ? 8'h01 : 8'h00;
            12'h100: tmp_result = alu_src1 < alu_src2 ? 8'h01 : 8'h00;
            12'h200: begin
                sum = alu_src1 + alu_src2;
                if(sum[8])
                    tmp_result = sum[8:1];
                else
                    tmp_result = sum[7:0];
            end
            12'h400: tmp_result = alu_src1 ^ alu_src2;
            12'h800: begin
                if(alu_src2[4]) begin
                    tmp_result[3:0] = {alu_src1[1:0], alu_src1[7:6]};
                    tmp_op = alu_src1[5:2];
                end else if(alu_src2[5]) begin
                    tmp_result[3:0] = {alu_src1[5:4], alu_src1[3:2]};
                    tmp_op = {alu_src1[7:6], alu_src1[1:0]};
                end else if(alu_src2[6]) begin
                    tmp_result[3:0] = {alu_src1[7:6], alu_src1[3:2]};
                    tmp_op = {alu_src1[5:4], alu_src1[1:0]};
                end else if(alu_src2[7]) begin
                    tmp_result[3:0] = {alu_src1[5:4], alu_src1[1:0]};
                    tmp_op = {alu_src1[7:6], alu_src1[3:2]};
                end

                tmp_result[7:4] = alu_src2[3:0]; 

                if(tmp_op[0]) begin
                    counter = tmp_op[3:1];
                    for (i = 0; i < counter ; i = i + 1) begin
                        tmp_result = {tmp_result[6:0], tmp_result[7]};
                    end
                end else begin 
                    counter = tmp_op[3:1];
                    for (i = 0; i < counter ; i = i + 1) begin
                        tmp_result = {tmp_result[0], tmp_result[7:1]};
                    end
                end
            end
            default: tmp_result = 8'h00;
        endcase
    end

    assign alu_result = tmp_result;

endmodule