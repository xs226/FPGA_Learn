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
	
	
parameter TIME_1s = 5_000_000 ;
reg[23:0] cnt_1s;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_1s <= 0;
    end
    else begin
        if(cnt_1s==TIME_1s-1) cnt_1s <= 0;
        else cnt_1s <= cnt_1s + 1;
    end
end

reg[1:0] ew_state;
reg[3:0] ew_cnt;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        ew_state<=0;
    end
    else if( cnt_1s==TIME_1s-1 ) begin
        if( ew_state==0 && ew_cnt==9 )  ew_state<=1;
		else if( ew_state==1 && ew_cnt==4 ) ew_state<=2;
		else if( ew_state==2 && ew_cnt==14) ew_state<=0;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        ew_cnt<=0;
    end
    else if(cnt_1s==TIME_1s-1) begin
        if( (ew_state==0 && ew_cnt==9) || (ew_state==1 && ew_cnt==4) || ( ew_state==2 && ew_cnt==14) )ew_cnt<=0;
		else ew_cnt<=ew_cnt+1;
    end
end

wire ew_change_flag;

assign ew_change_flag=(	( ew_state==0 && ew_cnt==9 && cnt_1s==TIME_1s-1 )  ||
						( ew_state==1 && ew_cnt==4 && cnt_1s==TIME_1s-1 )  ||
						( ew_state==2 && ew_cnt==14 && cnt_1s==TIME_1s-1 )
					);

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        led_east<=3'b110;
    end
    else if(ew_change_flag) begin
        led_east<={led_east[1:0],led_east[2]};
    end
end


endmodule





































