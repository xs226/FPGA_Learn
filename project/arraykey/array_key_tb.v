`timescale 1ns/1ns
module array_key_tb ();	
    reg clk ;
    reg rst_n ;	
    reg [ 3 :0] key_col ;
    wire[ 3 :0] key_row ;
	wire[ 3 :0] key_num ;
	wire key_vld;
	
    parameter CYCLE = 20 ;
	parameter RST_TIME = 3 ;
	
    array_key  #(.TIME_20ms(5),.TIME_1ms(1) )  uut1(
	.rst_n( rst_n ),
	.clk  ( clk ),
	.key_col ( key_col ),
	.key_row ( key_row ), 
	.key_num ( key_num ),
	.key_vld ( key_vld )
	);

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
integer i,j,t;	

	initial begin
        #1;		
		key_col=4'hf;
        #(10*CYCLE);
		
		for(j=0;j<50;j=j+1)
		for(i=0;i<4;i=i+1)begin
			key_col=~(1<<i);
			t= {$random}%10;
			#(t*CYCLE);
			key_col=4'hf;
			t= {$random}%4;
			#(t*CYCLE);
		end
		
    end

endmodule