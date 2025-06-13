module top_module(
    input  clk,
    input  areset,  // 异步复位到状态B
    input  in,
    output out
);

    // 定义状态编码
    parameter A = 1'b0;
    parameter B = 1'b1;

    reg current_state, next_state;
	reg out1 = 1;

	assign out = out1;

    // 状态转换逻辑
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= B;  // 异步复位到状态B
        end else begin
            current_state <= next_state;
        end
    end

    // 下一个状态和输出逻辑
    always @(*) begin
        case (current_state)
            A: begin
                if (in == 1) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
                out1 = 0;  // 状态A对应输出out=0
            end
            B: begin
                if (in == 1) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
                out1 = 1;  // 状态B对应输出out=1
            end
            default: begin
                next_state = B;
                out1 = 1;
            end
        endcase
    end

endmodule
