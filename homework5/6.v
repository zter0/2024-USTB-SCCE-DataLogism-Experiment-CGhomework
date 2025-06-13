module top_module(
    input clk,
    input areset,         // 异步复位，复位后默认向左走
    input bump_left,      // 左侧碰撞信号
    input bump_right,     // 右侧碰撞信号
    input ground,         // 地面状态信号（1表示有地面，0表示无地面）
    input dig,            // 挖掘信号
    output reg walk_left,  // 向左行走状态输出
    output reg walk_right, // 向右行走状态输出
    output reg aaah,       // 下落状态输出
    output reg digging     // 挖掘状态输出
);

    // 定义状态编码
    parameter LEFT = 3'b000;
    parameter RIGHT = 3'b001;
    parameter FALLING = 3'b010;
    parameter DIG = 3'b011;
    parameter DIE = 3'b100;

    reg [2:0] state, next_state;  // 3位状态变量
    reg div;                      // 用于记录原来的行走方向
    reg [9:0] falling_time;       // 计数下落时间

    // 同步时钟或异步复位
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;        // 异步复位到向左走状态
            falling_time <= 0;    // 重置下落时间
            div <= 0;             // 重置方向为向左
        end else begin
            state <= next_state;
            if (state == FALLING) begin
                falling_time <= falling_time + 1;  // 仅在FALLING状态下计数
            end else begin
                falling_time <= 0;  // 其他状态下重置下落时间
            end

            // 更新 div 方向
            if (state == LEFT && bump_left) begin
                div <= 1;  // 遇到左边障碍，切换为向右
            end else if (state == RIGHT && bump_right) begin
                div <= 0;  // 遇到右边障碍，切换为向左
            end
        end
    end

    // 下一个状态逻辑
    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground) begin
                    next_state = FALLING;  // 地面消失，进入下落状态
                end else if (dig) begin
                    next_state = DIG;      // 地面存在且dig信号有效，进入挖掘状态
                end else if (bump_left) begin
                    next_state = RIGHT;    // 碰到左边障碍，切换到向右走状态
                end else begin
                    next_state = LEFT;     // 继续向左走
                end
            end
            RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;  // 地面消失，进入下落状态
                end else if (dig) begin
                    next_state = DIG;      // 地面存在且dig信号有效，进入挖掘状态
                end else if (bump_right) begin
                    next_state = LEFT;     // 碰到右边障碍，切换到向左走状态
                end else begin
                    next_state = RIGHT;    // 继续向右走
                end
            end
            DIG: begin
                if (!ground) begin
                    next_state = FALLING;  // 地面消失，进入下落状态
                end else begin
                    next_state = DIG;      // 继续挖掘
                end
            end
            FALLING: begin
                if (ground) begin
                    if (falling_time > 19) begin
                        next_state = DIE;  // 下落时间超过20，进入死亡状态
                    end else begin
                        next_state = (div == 0) ? LEFT : RIGHT;  // 地面恢复，恢复下落前的行走状态
                    end
                end else begin
                    next_state = FALLING;  // 继续下落
                end
            end
            DIE: begin
                next_state = DIE;          // 保持死亡状态
            end
            default: begin
                next_state = LEFT;         // 默认状态为向左走
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
                digging = 0;
            end
            RIGHT: begin
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
            end
            DIG: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end
            FALLING: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end
            DIE: begin
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
            default: begin
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        endcase
    end

endmodule
