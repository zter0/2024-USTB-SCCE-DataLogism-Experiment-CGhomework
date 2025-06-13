module debounce (
    input wire clk,       // 时钟信号
    input wire btn_in,    // 原始按键信号
    output reg btn_out    // 消抖后的按键信号
);
    reg [19:0] counter;
    reg stable_state;
    reg btn_last;

    always @(posedge clk) begin
        if (btn_in != btn_last) begin
            counter <= 0;
        end else if (counter < 20'd1000000) begin
            counter <= counter + 1; 
        end

        if (counter == 20'd1000000) begin
            stable_state <= btn_in;
        end

        btn_last <= btn_in;
        btn_out <= stable_state;
    end
endmodule
