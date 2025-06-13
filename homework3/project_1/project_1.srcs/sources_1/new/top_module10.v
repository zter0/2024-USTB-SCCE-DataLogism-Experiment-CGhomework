`timescale 1ns/1ps

module top_module (
    input clk,
    input d,
    output q
);

    reg tmpq;

    always @(posedge clk) begin
        tmpq <= d;
    end

    assign q = tmpq;
    
endmodule