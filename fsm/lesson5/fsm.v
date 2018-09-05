module fsm (
	clk ,
	rst_n ,
	din ,
	dout ,
	dout_sop ,
	dout_eop ,
	dout_vld
);

input clk ;
input rst_n ;
input[7:0]  din ;
output[7:0] dout ;
output dout_sop;
output dout_eop;
output dout_vld;

reg[7:0] dout;
reg dout_sop;
reg dout_eop;
reg dout_vld;

parameter  HEAD  	=  4'd0,
		   TYPE  	=  4'd1,
		   LEN  	=  4'd2,
		   DATA  	=  4'd3,
		   FCS  	=  4'd4;
		   
reg[3:0] current_state;
reg[3:0] next_state;


/************************freme_head_flag信号****************************/
reg[7:0] din_ff0;
reg[3:0] cnt_head ;

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        din_ff0<=0;
    end
    else  begin
        din_ff0<=din;
    end
end
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        cnt_head<=0;
    end
    else if( (cnt_head==0&&din==8'h55)||(din_ff0==8'h55&&din==8'h55) ) cnt_head<=1;
	else if( (din_ff0==8'hd5&&din==8'h55) || (din_ff0==8'h55&&din==8'hd5) ) begin
        if(cnt_head==9) cnt_head<=0;
		else cnt_head<=cnt_head+1;
    end
	else cnt_head<=0;
end

/************************* rec_len_cnt *****************************/
reg[2:0] rec_len_cnt ;
reg[15:0] data_len;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        rec_len_cnt <= 0;
    end
    else if( current_state==TYPE_DATA ) begin
        if(rec_len_cnt==1) rec_len_cnt<= 0;
        else rec_len_cnt <= rec_len_cnt + 1;
    end
	else rec_len_cnt<= 0;
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        data_len<=0;
    end
    else if( current_state==TYPE_DATA) begin
        data_len<={data_len[7:0],din};
    end
end

/*************************cnt_data**************************/

reg[5:0] cnt_data;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_data <= 0;
    end
    else if( current_state==TYPE_CMD ) begin
        if(  cnt_data==63) cnt_data <= 0;
        else cnt_data <= cnt_data + 1;
    end
	else if( current_state==DATA_LEN ) begin
        if(  cnt_data==data_len-1) cnt_data <= 0;
        else cnt_data <= cnt_data + 1;
    end
	else if( current_state==DATA ) begin
        if(  cnt_data==3) cnt_data <= 0;
        else cnt_data <= cnt_data + 1;
    end
	else cnt_data <= 0;
	
end









/************************* fsm *****************************/

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        current_state<=HEAD;
    end
    else begin
        current_state<=next_state;
    end
end

always@(*)begin
    case(current_state)
		HEAD:if( cnt_head==9 && din==8'hd5 ) next_state=TYPE;
			 else next_state=current_state ;		
		TYPE: if(din==0) next_state=DATA ;
			  else next_state=LEN ;
		LEN: if( cnt_data==CNT_THD-1 ) next_state=DATA ;
			    else next_state=current_state;
		DATA: if( cnt_data==CNT_THD-1 ) next_state=FCS ;
				else next_state=current_state;
		FCS: if( cnt_data==CNT_THD-1 ) next_state=HEAD;
				else next_state=current_state;
	    default:next_state=HEAD;
	endcase
end







always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dout<=0;
    end
    else if(current_state!=IDLE ) begin
        dout<=din;
    end
end
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dout_sop<=0;
    end
    else if(current_state==HEAD) begin
        dout_sop<=1;
    end
	else begin
        dout_sop<=0;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
       dout_eop<=0; 
    end
    else if(current_state==DATA && cnt_data==2 ) begin
		dout_eop<=1; 
    end
	else dout_eop<=0; 
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
		dout_vld<=0; 
    end
    else if(current_state==HEAD) begin
		dout_vld<=1; 
    end
	else if(current_state==DATA_CRC && cnt_data==3 ) begin
		dout_vld<=0; 
    end
end

endmodule



