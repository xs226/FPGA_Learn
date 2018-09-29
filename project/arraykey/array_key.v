module array_key (
	clk ,
	rst_n ,
	key_col ,
	key_row ,
	key_num ,
	key_vld 
);

input clk ;
input rst_n ;
input [ 3:0] key_col ;
output[ 3:0] key_row ;
output[ 3:0] key_num ;
output key_vld;

reg[ 3:0] key_row ;
reg[ 3:0] key_num ;
reg key_vld;

reg[3:0] key_col_r ;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_col_r<=4'hf;
    end
    else  begin
        key_col_r <= key_col;
    end
end

parameter TIME_20ms = 5_000_000 ;
reg[23:0] cnt_20ms;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_20ms <= 0;
    end
    else if( key_col_r!=4'hf ) begin
        if(  cnt_20ms<TIME_20ms-1) cnt_20ms <= cnt_20ms + 1;
    end
	else cnt_20ms <= 0;
end	

reg key_flag,key_flagr;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_flag<=0;
    end
    else if(cnt_20ms == TIME_20ms-1) begin
        key_flag<=1;
    end
	else  key_flag<=0;
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
assign key_en =~key_flagr&key_flag;

parameter TIME_1ms = 5_000_000 ;
reg[23:0] cnt_1ms;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_1ms <= 0;
    end
    else if( key_col_r==4'hf ) begin
        if( cnt_1ms==TIME_1ms-1) cnt_1ms <= 0;
        else cnt_1ms <= cnt_1ms + 1;
    end
	else cnt_1ms <= 0;
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_row<=4'he;
    end
    else if(cnt_1ms==TIME_1ms-1 && key_col_r==4'hf) begin
        key_row<={key_row[2:0],key_row[3]};
    end
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_num<=0 ;
    end
    else if(key_en) begin
        case( key_row )
          	4'b1110 : if(key_col_r==4'he) key_num<=0 ;
					  else if(key_col_r==4'hd) key_num<=1 ;
					  else if(key_col_r==4'hb) key_num<=2 ;
					  else if(key_col_r==4'h7) key_num<=3 ;
					  else key_num<=0 ;
          	4'b1101 : if(key_col_r==4'he) key_num<=4 ;
					  else if(key_col_r==4'hd) key_num<=5 ;
					  else if(key_col_r==4'hb) key_num<=6 ;
					  else if(key_col_r==4'h7) key_num<=7 ;
					  else key_num<=0 ;
			4'b1011 : if(key_col_r==4'he) key_num<=8 ;
					  else if(key_col_r==4'hd) key_num<=9 ;
					  else if(key_col_r==4'hb) key_num<=10 ;
					  else if(key_col_r==4'h7) key_num<=11 ;
					  else key_num<=0 ;
			4'b0111 : if(key_col_r==4'he) key_num<=12 ;
					  else if(key_col_r==4'hd) key_num<=13 ;
					  else if(key_col_r==4'hb) key_num<=14 ;
					  else if(key_col_r==4'h7) key_num<=15 ;
					  else key_num<=0 ;
          	default: key_num<=0 ;
        endcase
    end    
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_vld<=0;
    end
    else if(key_en) begin
        key_vld<=1;
    end
	else key_vld<=0;
end

endmodule























