`timescale 1ns/1ps

module top_module (
    input a,
    input b,
    input c,
    input d,
    output out,
    output out_n
);

    wire e, f;

    assign e = a & b;
    assign f = c & d;

    assign out = e | f;
    assign out_n = !out;
    
endmodule