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

parameter  IDLE    		=  4'd0,
		   HEAD  		=  4'd1,
		   TYPE_DATA  	=  4'd2,
		   TYPE_CMD  	=  4'd3,
		   DATA_LEN  	=  4'd4,
		   DATA  		=  4'd5,
		   DATA_CRC  	=  4'd6;
		   
reg[3:0] current_state;
reg[3:0] next_state;
reg[7:0] pkt_type;
reg rec_len_over_flag;

reg[15:0] cnt_data ;


/************************freme_head_flag信号****************************/
reg[7:0] din_ff0;
reg[2:0] cnt_head ;
reg freme_head_flag ;

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
    else if( (cnt_head==0&&din=0x55)|| (din_ff0==0xd5&&din=0x55) || (din_ff0==0x55&&din=0xd5) ) begin
        if(cnt_head==9) cnt_head<=0;
		else cnt_head<=cnt_head+1;
    end
end

/************************* pkt_type *****************************/

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        pkt_type<=0;
    end
    else if(current_state==HEAD) begin
        pkt_type<=din;
    end
	else pkt_type<=0;
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
        current_state<=IDLE;
    end
    else begin
        current_state<=next_state;
    end
end

always@(*)begin
    case(current_state)
		IDLE:if( cnt_head==9 && din==0xd5 ) next_state=HEAD ;
			 else next_state=current_state ;		
		HEAD: if(pkt_type==0) next_state=TYPE_CMD ;
			  else next_state=TYPE_DATA ;
		TYPE_DATA: if( rec_len_cnt==1 ) next_state=DATA_LEN ;
			    else next_state=current_state; ;
		TYPE_CMD: if( cnt_data==63) next_state=DATA ;
				else next_state=current_state;
		DATA_LEN: if( cnt_data==data_len-1) next_state=DATA ;
				else next_state=current_state;
		DATA: if( cnt_data==3 ) next_state=DATA_CRC ;
				else next_state=current_state ;
		DATA_CRC: next_state=IDLE ;
	    default:next_state=IDLE;
endcase
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dout<=0;
    end
    else if( (current_state==TYPE_CMD)||(current_state==DATA_LEN) ) begin
        dout<=din;
    end
end
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dout_sop<=0;
    end
    else if(current_state==IDLE && cnt_head==9 && din==0xd5) begin
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
    else if(current_state==DATA && cnt_data==3 ) begin
		dout_eop<=1; 
    end
	else dout_eop<=0; 
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
		dout_vld<=0; 
    end
    else if(current_state==IDLE && cnt_head==9 && din==0xd5) begin
		dout_vld<=1; 
    end
	else if(current_state==DATA && cnt_data==3 ) begin
		dout_vld<=0; 
    end
end

endmodule






