module fsm (
	clk ,
	rst_n ,
	en ,
	dout
);

input clk ;
input rst_n ;
input  en ;
output[3:0] dout ;

reg[3:0] dout;


reg[3:0] cnt_s1,cnt_s2;




parameter  IDLE    =  4'd0,
		   S1  =  4'd1,
		   S2  =  4'd2;
		   
reg[3:0] current_state;
reg[3:0] next_state;


always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_s1 <= 0;
    end
    else if( current_state==S1 )begin
			if(cnt_s1==4) cnt_s1 <= 0;
			else cnt_s1 <= cnt_s1 + 1;
		end		
		else  cnt_s1 <= 0;
end
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_s2 <= 0;
    end
    else if( current_state==S2 )begin
			if(cnt_s2==6) cnt_s2 <= 0;
			else cnt_s2 <= cnt_s2 + 1;
		end		
		else  cnt_s2 <= 0;
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
		IDLE:if(en==1) next_state=S1 ;
			else next_state=current_state ;
		S1: if(cnt_s1==4) next_state=S2 ;
			else next_state=current_state ;
		S2: if(cnt_s2==6) next_state=IDLE ;
			else next_state=current_state ;
	    default:next_state=IDLE;
endcase
end


always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dout<=IDLE;
    end
    else begin
        dout<=current_state;
    end
end

endmodule