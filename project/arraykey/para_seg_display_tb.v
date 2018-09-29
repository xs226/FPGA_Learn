`timescale 1ns/1ns
module para_seg_display_tb ();	
    reg clk ;
    reg rst_n ;	
    reg [ 31 :0] din ;
	reg[7:0] din_vld;
	
    wire[ 7 :0] segment ;
	wire[7:0] segsel;
	
    parameter CYCLE = 20 ;
	parameter RST_TIME = 3 ;



	
    para_seg_display  #(.SEG_NUM(8),.TIME_20ms(2) )  uut1(
	.rst_n( rst_n ),
	.clk  ( clk ),
	.din ( din ),
	.din_vld ( din_vld ), 
	.segment ( segment ),
	.segsel ( segsel )
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
		din=4'h0;
		din_vld=8'hff;
        #(10*CYCLE);
		
		din=32'h12345678;
		#(30*CYCLE);
		
		din=32'h58149236;
		#(30*CYCLE);
		din_vld=4'h3;
        #(10*CYCLE);
		
		
    end

endmodule





