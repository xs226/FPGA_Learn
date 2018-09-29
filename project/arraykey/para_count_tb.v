`timescale 1ns/1ns
module counter_tb ();	
    reg clk ;
    reg rst_n ;	
    reg din_vld ;
    wire[ 11 :0] dout ;
	wire dout_vld;
	
    parameter CYCLE = 20 ;
	parameter RST_TIME = 3 ;

	
    counter  #(3 )  uut1(
	.rst_n( rst_n ),
	.clk  ( clk ),
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
		din_vld=0;
        #(4*CYCLE);
		for(i=0;i<50;i=i+1)begin
			din_vld= $random;
			#(2*CYCLE);
		end
    end

endmodule



















