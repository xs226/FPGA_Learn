`timescale 1ns/1ns
module fsm_tb ();	
    reg clk ;
    reg rst_n ;	
    reg en ;
    wire[ 3 :0] dout ;
	
    parameter CYCLE = 20 ;
	parameter RST_TIME = 3 ;
	
    fsm  uut(
	.rst_n( rst_n ),
	.clk  ( clk ),
	.en ( en ),
	.dout ( dout )
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

	initial begin
        #1;		
		en=0;
        #(10*CYCLE);
		en=1;
		#(3*CYCLE);
		en=0;
		
		#(3*CYCLE);
		en=1;
		#(3*CYCLE);
		en=0;
		
    end

endmodule




/*	virtual type { {3'd0 IDLE} {3'd1 S1} {3'd2 S2} } FSM_TYPE;
	virtual function {(FSM_TYPE)/uut/current_state} current_state_n;
	add wave -hex -color pink current_state_n;
*/





