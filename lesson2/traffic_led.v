module traffic_led (
	clk,
	rst_n,
	led_east,
	led_south,
	led_west,
	led_north
);

input clk ;
input rst_n;

output[2:0] led_east;
output[2:0] led_south;
output[2:0] led_west;
output[2:0] led_north;
reg[2:0] led_east;
reg[2:0] led_south;
reg[2:0] led_west;
reg[2:0] led_north;
	
	
parameter TIME_1S = 5_000_000 ;
reg[23:0] cnt_1s;
wire add_cnt_1s;
wire end_cnt_1s;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_1s <= 0;
    end
    else if(add_cnt_1s) begin
        if(end_cnt_1s) cnt_1s <= 0;
        else cnt_1s <= cnt_1s + 1;
    end
end

assign add_cnt_1s = 1 ;       
assign end_cnt_1s = add_cnt_1s && cnt_1s==TIME_1S-1 ; 


parameter TIME_4S = 4 ;
reg[23:0] cnt_4s;
wire add_cnt_4s;
wire end_cnt_4s;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_4s <= 0;
    end
    else if(add_cnt_4s) begin
        if(end_cnt_4s) cnt_4s <= 0;
        else cnt_4s <= cnt_4s + 1;
    end
end

assign add_cnt_4s = cnt_1s==TIME_1S-1 ;       
assign end_cnt_4s = add_cnt_4s && cnt_4s==TIME_4S-1 ; 		



always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        led_east<=3'b110;
    end
    else if(add_cnt_4s && cnt_4s==0) begin
        led_east<={led_east[1:0],led_east[2]};
    end
end
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        led_west<=3'b110;
    end
    else if(add_cnt_4s && cnt_4s==1) begin
        led_west<={led_west[1:0],led_west[2]};
    end
end
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        led_south<=3'b110;
    end
    else if(add_cnt_4s && cnt_4s==2) begin
        led_south<={led_south[1:0],led_south[2]};
    end
end
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        led_north<=3'b110;
    end
    else if(add_cnt_4s && cnt_4s==3) begin
        led_north<={led_north[1:0],led_north[2]};
    end
end


endmodule






































