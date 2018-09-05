`timescale 1ns/1ns
module fsm_tb ();	
    reg clk ;
    reg rst_n ;	
    reg[7:0] din ;
    wire[7:0] dout[1:0] ;
	wire dout_sop[1:0] ;
	wire dout_eop[1:0] ;
	wire dout_vld[1:0] ;
	
	reg[3:0] com_flag;
	
    parameter CYCLE = 20 ;
	parameter RST_TIME = 3 ;
	
    fsm  uut1(
	.rst_n( rst_n ),
	.clk  ( clk ),
	.din ( din ),
	.dout ( dout[0] ),
	.dout_sop(dout_sop[0]),
	.dout_eop(dout_eop[0]),
	.dout_vld(dout_vld[0])
	
	);

	pkt_check   uut2(
					  .clk      (clk),
					  .rst_n    (rst_n),
					  .din      (din  ),
					  .dout_vld (dout_vld[1]),
					  .dout     (dout[1]    ),
					  .dout_sop (dout_sop[1]    ),
					  .dout_eop (dout_eop[1]    )
	);	

	always@(posedge clk or negedge rst_n)begin
	    if(rst_n==1'b0)begin
	        com_flag<=0;
	    end
	    else  begin
			if(dout[0]==dout[1])	com_flag[0]<=0;
			else com_flag[0]<=1;			
			if(dout_sop[0]==dout_sop[1])	com_flag[1]<=0;
			else com_flag[1]<=1;
			if(dout_eop[0]==dout_eop[1])	com_flag[2]<=0;
			else com_flag[2]<=1;
			if(dout_vld[0]==dout_vld[1])	com_flag[3]<=0;
			else com_flag[3]<=1;
			
		end
	end
	
	
    initial begin
        clk = 0;
        forever #(CYCLE/2) clk = ~clk;
    end

    initial begin
        rst_n=1;
        #2;		
		rst_n=0;
        #(RST_TIME*CYCLE);
		rst_n=1;
    end

	integer i,j;



	
	initial begin
        #1;		
		din=8'h55;
		#(5*CYCLE);
		din=8'hd5;
		#(1*CYCLE);
		din=8'h55;
		#(1*CYCLE);
		din=8'h55;
		#(1*CYCLE);
		
		
		for(j=0;j<2;j=j+1) begin		
			start_frame;			
			din=  0; 
			#(1*CYCLE);
			for(i=0;i<68;i=i+1)begin
				din= {$random}%10;
				#(1*CYCLE);
			end
		end
		
		
			start_frame;
			
			din=  1; 
			#(1*CYCLE);
			din=0;
			#(1*CYCLE);
			din=1;
			#(1*CYCLE);
			for(i=0;i<5;i=i+1)begin
				din= {$random}%10;
				#(1*CYCLE);
			end
		
		start_frame;
		start_frame;
		start_frame;
		
    end

task start_frame ;
	integer i;
	for(i=0;i< 5 ;i=i+1)begin		
	din= 8'h55;
	#(1*CYCLE);
	din= 8'hd5;
	#(1*CYCLE);
	end
endtask


	
endmodule




/*	virtual type { {3'd0 IDLE} {3'd1 S1} {3'd2 S2} } FSM_TYPE;
	virtual function {(FSM_TYPE)/uut/current_state} current_state_n;
	add wave -hex -color pink current_state_n;
*/





