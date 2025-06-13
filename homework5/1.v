module mealy (
    input wire clk,
    input wire areset,
    input wire in,
    output reg out
);

    // Define state encoding
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01
    } state_t;

    state_t current_state, next_state;

    // State transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A; // Reset to state A
        end else begin
            current_state <= next_state;
        end
    end

    // Next state and output logic
    always @(*) begin
        case (current_state)
            A: begin
                if (in == 0) begin
                    next_state = A;
                    out = 0;
                end else begin
                    next_state = B;
                    out = 0;
                end
            end
            B: begin
                if (in == 0) begin
                    next_state = A;
                    out = 0;
                end else begin
                    next_state = B;
                    out = 1;
                end
            end
            default: begin
                next_state = A;
                out = 0;
            end
        endcase
    end

endmodule
