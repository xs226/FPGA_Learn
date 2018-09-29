module para_seg_display (
	clk,
	rst_n,
	din,
	din_vld,
	segment,
	segsel
);

parameter SEG_NUM =1;

input clk ;
input rst_n;
input[4*SEG_NUM-1:0] din;
input[SEG_NUM-1:0] din_vld;

output[7:0] segment;
output[SEG_NUM-1:0] segsel;
reg[7:0] segment;
reg[SEG_NUM-1:0] segsel;

reg[4*SEG_NUM-1:0] din_ff0;

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

parameter TIME_20ms = 5_000_000 ;
reg[23:0] cnt_20ms;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_20ms <= 0;
    end
    else begin
        if(cnt_20ms==TIME_20ms-1) cnt_20ms <= 0;
        else cnt_20ms <= cnt_20ms + 1;
    end
end

reg[3:0] sel_cnt;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        sel_cnt<=3'd0;
    end
    else if(cnt_20ms==TIME_20ms-1) begin
		if(sel_cnt==SEG_NUM-1) sel_cnt<=3'd0;
		else sel_cnt<=sel_cnt+1;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        segsel<={SEG_NUM{1'b1}} ;
    end
    else if(cnt_20ms==TIME_20ms-1) begin
        segsel<=~(1<<sel_cnt);
    end
end

reg[3:0] i;
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        din_ff0<={ 4*SEG_NUM{1'b0} };
    end
    else begin
        for(i=0;i<SEG_NUM;i=i+1)begin
			if(din_vld[i]) din_ff0[4*(i+1)-1 -:4]<=din[4*(i+1)-1 -:4];
			else din_ff0[4*(i+1)-1 -:4]<=din_ff0[4*(i+1)-1 -:4];
		end
    end
end


reg[3:0] dis_value;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dis_value<=4'd0;
    end
    else if(cnt_20ms==TIME_20ms-1) begin
        dis_value<=din_ff0[4*(sel_cnt+1)-1 -:4];
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






















