module flash_led_top(
    input  wire        clk,        // ϵͳʱ��
    input  wire        rst,        // ��λ�ź�
    input  wire [7:0]  switch,     // ���뿪������
    output wire [15:0] led         // LED ���
);
    
    reg [3:0] switch_count;
    wire clk_bps;                  // ��Ƶʱ���ź�
    wire dir;                      // �ƶ������ź�

    assign dir = (switch_count < 4) ? 1'b1 : 1'b0;

    // ����ߵ�ƽ�Ĳ��뿪������
    integer i;
    always @(*) begin
        switch_count = 0;
        for (i = 0; i < 8; i = i + 1) begin
            if (switch[i] == 1)
                switch_count = switch_count + 1;
        end
    end

    // ʵ����������ģ��
    counter counter_inst (
        .clk(clk),
        .rst(rst),
        .switch_count(switch_count),
        .clk_bps(clk_bps)
    );
    
    // ʵ������ˮ�ƿ���ģ��
    flash_led_ctl flash_led_ctl_inst (
        .clk(clk),
        .rst(rst),
        .dir(dir),
        .clk_bps(clk_bps),
        .led(led)
    );
    
endmodule
