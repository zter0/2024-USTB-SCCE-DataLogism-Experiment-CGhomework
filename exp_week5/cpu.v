module SimpleProcessor(
    input clk,
    input reset,
    input [7:0] switches,
    input [7:0] data_in,
    input button_start,
    input button_end,
    output [3:0] pos_high,
    output [3:0] pos_low,
    output [7:0] seg_high,
    output [7:0] seg_low
);

    reg [15:0] registers [3:0];
    reg [7:0] pc;
    reg [7:0] instruction;
    reg [15:0] memory [255:0];
    reg [7:0] Addr;
    integer i;

    parameter IDLE = 2'b00,
              INPUT_MODE = 2'b01,
              EXECUTE = 2'b10,
              DONE = 2'b11;

    reg [1:0] state, next_state;  

    function [15:0] array_multiplier(input [15:0] A, input [15:0] B);
        reg [31:0] product;
        integer j;
        begin
            product = 32'b0;
            for (j = 15; j >= 0; j = j - 1) begin
                if(B[j]) begin 
                    product = product + (A << j);
                end
            end
            array_multiplier = product[15:0];
        end
    endfunction

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (button_start) 
                    next_state = INPUT_MODE;
                else
                    next_state = IDLE;
            end

            INPUT_MODE: begin
                if (button_end) 
                    next_state = EXECUTE;
                else
                    next_state = INPUT_MODE;
            end

            EXECUTE: begin
                next_state = DONE;
            end

            DONE: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instruction <= 8'd0;
            pc <= 8'd0;
            registers[0] <= 8'd0;
            registers[1] <= 8'd0;
            registers[2] <= 8'd0;
            registers[3] <= 8'd0;
            for (i = 0; i < 256; i = i + 1) 
                memory[i] <= 16'd0;
        end else if (state == INPUT_MODE) begin
            instruction <= switches;
        end else if (state == EXECUTE) begin
            case (instruction[7:4])
                4'b0000: begin // Load Rx, Data
                     registers[instruction[3:2]] <= {8'b0000_0000, data_in};
                     memory[pc] <=  {8'b0000_0000, data_in};
                     Addr <= pc;
                end

                4'b0001: begin // Move Rx, Ry
                     registers[instruction[3:2]] <= registers[instruction[1:0]];
                     memory[pc] <= registers[instruction[1:0]];
                     Addr <= pc;
                end

                4'b0010: begin // Add Rx, Ry
                    registers[instruction[3:2]] <= registers[instruction[3:2]] + registers[instruction[1:0]];
                    memory[pc] <= registers[instruction[3:2]] + registers[instruction[1:0]];  // Store in memory
                    Addr <= pc;
                end

                4'b0011: begin // Sub Rx, Ry
                     registers[instruction[3:2]] <= registers[instruction[3:2]] - registers[instruction[1:0]];
                     memory[pc] <= registers[instruction[3:2]] - registers[instruction[1:0]];  // Store in memory
                     Addr <= pc;
                end

                4'b0100: begin // Mul Rx, Ry
                     registers[instruction[3:2]] <= array_multiplier(registers[instruction[3:2]], registers[instruction[1:0]]);
                     memory[pc] <= array_multiplier(registers[instruction[3:2]], registers[instruction[1:0]]);  // Store in memory
                     Addr <= pc;
                end

                4'b1111: begin
                    Addr <= data_in;
                end
 
                default: begin
                end
            endcase
        end else if (state == DONE && instruction[7:4] != 4'b1111) begin
            pc <= pc + 1;
        end
    end

    SevenSegmentDisplay display_inst(
        .clk(clk),
        .rst(reset),
        .data(memory[Addr]), 
        .pc(Addr),
        .pos_high(pos_high),
        .pos_low(pos_low),
        .seg_high(seg_high),
        .seg_low(seg_low)
    );

endmodule
