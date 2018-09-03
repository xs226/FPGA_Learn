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

reg freme_head ;
reg[7:0] pkt_type;
reg rec_len_flag;
reg[15:0] data_len;
reg[15:0] cnt_len;
reg[2:0] cnt_head ;
reg[7:0] din_ff0;

parameter  IDLE    		=  4'd0,
		   HEAD  		=  4'd1,
		   TYPE_DATA  	=  4'd2,
		   TYPE_CMD  	=  4'd3,
		   DATA_LEN  	=  4'd4,
		   DATA  		=  4'd5,
		   DATA_CRC  	=  4'd6;
		   
reg[3:0] current_state;
reg[3:0] next_state;


/************************freme_head信号****************************/
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
always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        freme_head<=0;
    end
    else if(cnt_head==9 && din==0xd5 ) freme_head<=1;
		else freme_head<=0;
end

/************************* pkt_type *****************************/

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        pkt_type<=0;
    end
    else if(freme_head==1) begin
        pkt_type<=din;
    end
	else pkt_type<=0;
end

/************************* rec_len_flag *****************************/
reg[23:0] cnt_len;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_s <= 0;
    end
    else if(  ) begin
        if(  && cnt_s==TIME_s-1) cnt_s <= 0;
        else cnt_s <= cnt_s + 1;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        rec_len_flag<=0;
    end
    else if( current_state==TYPE_DATA) begin
        
    end
end


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
		IDLE:if( freme_head ) next_state=HEAD ;
			 else next_state=current_state ;		
		HEAD: if(pkt_type==0) next_state=TYPE_CMD ;
			  else next_state=TYPE_DATA ;
		TYPE_DATA: if(rec_len_flag) next_state=DATA_LEN ;
			    else next_state=current_state; ;
		TYPE_CMD: if(cnt_len==63) next_state=DATA ;
				else next_state=current_state;
		DATA_LEN: if(cnt_len==data_len-1) next_state=DATA ;
				else next_state=current_state;
		DATA: if(cnt_len==3) next_state=DATA_CRC ;
				else next_state=current_state ;
		DATA_CRC: next_state=IDLE ;
	    default:next_state=IDLE;
endcase
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        
    end
    else begin
        
    end
end



endmodule








