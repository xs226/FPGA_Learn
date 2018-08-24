module water_led (
	clk ;
	rst_n ;
	dout
);

input clk ;
input rst_n ;
output[11:0] dout ;

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
assign end_cnt_1s = add_cnt_s && cnt_s==TIME_1S-1 ; 



always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dout<=12'h001;
    end
    else if(cnt_s==TIME_1S-1) begin
        dout<={dout[10:0],dout[11] };
    end
end


endmodule

aa







