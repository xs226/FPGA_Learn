`timescale 1ns/1ns
module hex2dec_tb ();	
    reg clk ;
    reg rst_n ;	
    reg [ 3 :0] din ;
	reg din_vld;
    wire[ 8 :0] dout ;
	wire dout_vld;
	
    parameter CYCLE = 20 ;
	parameter RST_TIME = 3 ;
	
    hex2dec  uut1(
	.rst_n( rst_n ),
	.clk  ( clk ),
	.din ( din ),
	.din_vld ( din_vld ), 
	.dout ( dout ),
	.dout_vld ( dout_vld )
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

	integer i;
	
	initial begin
        #1;		
		din=0;
        #(4*CYCLE);
		for(i=0;i<50;i=i+1)begin
			din= {$random}%16;
			din_vld=$random;
			#(2*CYCLE);
		end
		
    end

endmodule





























