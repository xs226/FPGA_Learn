module seg_led (
	clk,
	rst_n,
	segment,
	segsel
);

input clk ;
input rst_n;

output[7:0] segment;
output[7:0] segsel;
reg[7:0] segment;
reg[7:0] segsel;

parameter DATA0   = 8'b00000011  ;
parameter DATA1   = 8'b11110011  ;
parameter DATA2   = 8'b00100101  ;
parameter DATA3   = 8'b00001101  ;
parameter DATA4   = 8'b10011001  ;
parameter DATA5   = 8'b01001001  ;
parameter DATA6   = 8'b01000001  ;
parameter DATA7   = 8'b00011111  ;
parameter DATA8   = 8'b00000001  ;
parameter DATA9   = 8'b00001001  ;

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

reg[5:0] count_s;
reg[3:0] dis_value;
wire[3:0] cnt_thd;
assign cnt_thd=dis_value+1;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        count_s <= 0;
    end
    else if( cnt_1s==TIME_1s-1 ) begin
        if(count_s==cnt_thd-1) count_s <= 0;
        else count_s <= count_s + 1;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dis_value<=0;
    end
    else if(count_s==cnt_thd-1 && cnt_1s==TIME_1s-1 ) begin
		if(dis_value==7) dis_value<=0;
		else dis_value<=dis_value+1;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        segsel<=8'hfe;
    end
    else if(count_s==cnt_thd-1 && cnt_1s==TIME_1s-1 ) begin
		segsel<={segsel[6:0],segsel[7]};		
    end
end

always@(*)begin
	case(dis_value)
        0:  segment <= DATA0      ;
        1:  segment <= DATA1      ;
        2:  segment <= DATA2      ;
        3:  segment <= DATA3      ;
        4:  segment <= DATA4      ;
        5:  segment <= DATA5      ;
        6:  segment <= DATA6      ;
        7:  segment <= DATA7      ;
        8:  segment <= DATA8      ;
        9:  segment <= DATA9      ;
        default:segment <= 8'hff  ;
    endcase
end


endmodule





















