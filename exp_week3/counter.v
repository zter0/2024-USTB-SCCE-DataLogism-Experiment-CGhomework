module counter(
    input  wire        clk,
    input  wire        rst,
    input  wire [3:0]  switch_count,     // ²¦Âë¿ª¹ØÊäÈë
    output wire        clk_bps
);
    reg [18:0] counter_first, counter_second;
    reg [3:0] speed;
    
    always @(*) begin
        speed = switch_count;
        if (speed < 4)
            speed = 8 - speed;
        speed = speed - 4;
        
        if (speed == 0)
            speed = 1; // ·ÀÖ¹³ıÒÔÁã
            
    end
    

    always @(posedge clk or posedge rst) begin
        if (rst) 
            counter_first <= 14'b0;
        else 
            if (counter_first == 14'd999) 
                counter_first <= 14'b0;
            else 
                counter_first <= counter_first +1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) 
            counter_second <= 14'b0;
        else        
            if (counter_second == 14'd999 * 8 / speed) 
                counter_second <= 14'b0;
            else 
                if (counter_first == 14'd999) 
                    counter_second <= counter_second + 1;
    end

  assign clk_bps = (counter_second == 14'd999 * 8 / speed);

endmodule