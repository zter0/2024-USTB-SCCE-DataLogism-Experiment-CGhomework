module top_module(
    input      clk,
    input      areset,         // 异步复位，复位后默认向左走
    input      bump_left,      // 左侧碰撞信号
    input      bump_right,     // 右侧碰撞信号
    output reg walk_left, // 向左行走状态输出
    output reg walk_right // 向右行走状态输出
);

    // 定义状态编码
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;

    reg state, next_state;

    // 状态转移逻辑（同步时钟或异步复位）
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;   // 异步复位到向左走状态
        end else begin
            state <= next_state;
        end
    end

    // 下一个状态逻辑
    always @(*) begin
        case (state)
            LEFT: begin
                if (bump_left) begin
                    next_state = RIGHT;  // 碰到左边障碍，切换到向右走状态
                end else begin
                    next_state = LEFT;   // 继续向左走
                end
            end
            RIGHT: begin
                if (bump_right) begin
                    next_state = LEFT;   // 碰到右边障碍，切换到向左走状态
                end else begin
                    next_state = RIGHT;  // 继续向右走
                end
            end
            default: begin
                next_state = LEFT;       // 默认状态为向左走
            end
        endcase
    end

    // 输出逻辑
    always @(*) begin
        case (state)
            LEFT: begin
                walk_left = 1;
                walk_right = 0;
            end
            RIGHT: begin
                walk_left = 0;
                walk_right = 1;
            end
            default: begin
                walk_left = 1;
                walk_right = 0;
            end
        endcase
    end

endmodule
