`timescale 1ns/1ps

module top_module (
    input in1, in2,
    output out
);
    
    assign out = in1 & (!in2);

endmodule