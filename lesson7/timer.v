module seg_led (
	clk,
	rst_n,
	segment,
	segsel,
	key
);

input clk ;
input rst_n;
input key;

output[7:0] segment;
output[5:0] segsel;
reg[7:0] segment;
reg[5:0] segsel;

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



parameter TIME_20ms = 1_000_000 ;
reg[20:0] cnt_20ms;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_20ms <= 0;
    end
    else if( !key ) begin
        if(cnt_20ms<TIME_20ms-1)  cnt_20ms <= cnt_20ms + 1;
    end
	else cnt_20ms<=0;
end

reg key_flag,key_flagr;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_flag<=0;
    end
    else if(cnt_20ms==TIME_20ms-1) begin
        key_flag<=1;
    end
	else key_flag<=0;
end
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
		key_flagr<=0;
    end
    else begin
		key_flagr<=key_flag;
    end
end

wire key_en;
reg pause;

assign key_en=~key_flagr&key_flag;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        pause<=0;
    end
    else  begin
        if(key_en) pause<=~pause;
    end
end


parameter TIME_1s = 50_000_000 ;
reg[23:0] cnt_1s;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_1s <= 0;
    end
    else if(pause==0) begin
        if(cnt_1s==TIME_1s-1) cnt_1s <= 0;
        else cnt_1s <= cnt_1s + 1;
    end
end

reg[3:0] shi_s,shi_g,fen_s,fen_g,miao_s,miao_g;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        miao_g<=0;
    end
    else if(cnt_1s==TIME_1s-1&&pause==0) begin
        if( miao_g==9 ) miao_g<=0;
		else miao_g<=miao_g+1;
	end
end
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        miao_s<=0;
    end
    else if( miao_g==9 && cnt_1s==TIME_1s-1) begin
        if( miao_s==5 ) miao_s<=0;
		else miao_s<=miao_s+1;
	end
end


always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        fen_g<=0;
    end
    else if(miao_s==5 && miao_g==9 && cnt_1s==TIME_1s-1) begin
        if( fen_g==9 ) fen_g<=0;
		else fen_g<=fen_g+1;
	end
end
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        fen_s<=0;
    end
    else if( fen_g==9 && miao_s==5 && miao_g==9 && cnt_1s==TIME_1s-1) begin
        if( fen_s==5 ) fen_s<=0;
		else fen_s<=fen_s+1;
	end
end

wire[3:0] shi_g_thd;
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        shi_g<=0;
    end
    else if(fen_s==5 &&fen_g==9 &&miao_s==5 && miao_g==9 && cnt_1s==TIME_1s-1) begin
		if(shi_g==shi_g_thd) shi_g<=0;
		else shi_g<=shi_g+1;
	end
end
assign shi_g_thd=shi_s<2?9:3;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        shi_s<=0;
    end
    else if(shi_g==shi_g_thd && fen_s==5 &&fen_g==9 &&miao_s==5 && miao_g==9 && cnt_1s==TIME_1s-1) begin
        if( shi_s==2 ) shi_s<=0;
		else shi_s<=shi_s+1;
	end
end

reg[5:0] dis_value;
always@(*)begin
    case( segsel )
      	6'b11_1110 : dis_value=miao_g ;
		6'b11_1101 : dis_value=miao_s ;
		6'b11_1011 : dis_value=fen_g ;
		6'b11_0111 : dis_value=fen_s ;
		6'b10_1111 : dis_value=shi_g ;
		6'b01_1111 : dis_value=shi_s ;		
      	default:  ;
    endcase
end

parameter TIME_20us = 1000 ;
reg[9:0] cnt_20us;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_20us <= 0;
    end
    else begin
        if(cnt_20us==TIME_20us-1) cnt_20us <= 0;
        else cnt_20us <= cnt_20us + 1;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        segsel<=6'h3e;
    end
    else if(cnt_20us==TIME_20us-1) begin
		segsel<={segsel[4:0],segsel[5]};		
    end
end

always@(*)begin
	case( dis_value )
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





















