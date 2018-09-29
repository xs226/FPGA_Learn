module hex2dec (
	clk ,
	rst_n ,
	din ,
	din_vld,
	dout,
	dout_vld
);

input clk ;
input rst_n ;
input [ 3:0] din ;
input din_vld;
output[ 7:0] dout ;
output dout_vld;
reg dout_vld;
	
reg[3:0] dout_hi,dout_low;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dout_hi<=0;
		dout_low<=0;
    end
    else begin
		if(din>4'd9)begin
			dout_hi<=1;
			dout_low<=din-4'd10;
		end
		else begin
			dout_hi<=0;
			dout_low<=din;
		end
		
    end
end

assign dout={dout_hi,dout_low};

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dout_vld<=0;
    end
    else begin
        dout_vld<=din_vld;
    end
end

endmodule







