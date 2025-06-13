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

module sim_1;

  reg [7:0] alu_src1;
  reg [7:0] alu_src2;
  reg [11:0] alu_op;
  wire [7:0] alu_result;

  ALU alu(
    .alu_src1(alu_src1),
    .alu_src2(alu_src2),
    .alu_op(alu_op),
    .alu_result(alu_result)
  );
    
  initial begin
    alu_op = 12'b0000_0000_0001;
    alu_src1 = $random % 8'hFF;
    alu_src2 = {$random % 4'hF + 1, $random % 4'hF};
    forever begin
      #50
      alu_src1 = $random % 8'hFF;
      alu_src2 = {$random % 4'hF + 1, $random % 4'hF};
      alu_op = alu_op << 1;
    end
  end

endmodule