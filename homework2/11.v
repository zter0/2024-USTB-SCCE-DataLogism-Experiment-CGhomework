`timescale 1ns/1ps

module swap(
    input wire         io_i1,
    input wire         io_i2,
    input wire         io_s,
    output reg         io_o1,
    output reg         io_o2
);

    always @(*) begin
        io_o1 = io_s ? io_i2 : io_i1;
        io_o2 = io_s ? io_i1 : io_i2;
    end

endmodule
