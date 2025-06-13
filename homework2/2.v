`timescale 1ns/1ps

module top_module (
    input in,
    output out
);

    assign out = !in;
    
endmodule