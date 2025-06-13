module top_module(
    input clk,
    input areset,        // 异步复位，复位后默认向左走
    input bump_left,     // 左侧碰撞信号
    input bump_right,    // 右侧碰撞信号
    input ground,        // 地面状态信号（1表示有地面，0表示无地面）
    output reg walk_left, // 向左行走状态输出
    output reg walk_right,// 向右行走状态输出
    output reg aaah       // 下落状态输出
);

    // 定义状态编码
    parameter LEFT = 2'b00;
    parameter RIGHT = 2'b01;
    parameter FALLING = 2'b10;

    reg [1:0] state, next_state;  // 2位状态变量
	reg div = 0;

    // 状态转移逻辑（同步时钟或异步复位）
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;  // 异步复位到向左走状态
        end else begin
            state <= next_state;
        end
    end

    // 下一个状态逻辑
    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground) begin
                    next_state = FALLING;  // 地面消失，进入下落状态
                end else if (bump_left) begin
                    next_state = RIGHT;    // 碰到左边障碍，切换到向右走状态
						  div = 1;
                end else begin
                    next_state = LEFT;     // 继续向左走
						  div = 0;
                end
            end
            RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;  // 地面消失，进入下落状态
                end else if (bump_right) begin
                    next_state = LEFT;     // 碰到右边障碍，切换到向左走状态
						  div = 0;
                end else begin
                    next_state = RIGHT;    // 继续向右走
						  div = 1;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state = (div == 0) ? LEFT : RIGHT;  // 地面恢复，恢复下落前的行走状态
                end else begin
                    next_state = FALLING;  // 继续下落
                end
            end
            default: begin
                next_state = LEFT;  // 默认状态为向左走
            end
        endcase
    end

    // 输出逻辑
    always @(*) begin
        case (state)
            LEFT: begin
                walk_left = 1;
                walk_right = 0;	
                aaah = 0;
            end
            RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
            end
            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;  // 进入下落状态时，输出“aaah”信号
            end
            default: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
            end
        endcase
    end

endmodule
