`timescale 1ns/1ns
module water_led_tb ();
	
    reg               clk    ;
    reg               rst_n  ;	
    reg               din    ;

    wire[3:0]         dout   ;
	
    parameter         CYCLE = 20;
	parameter         RST_TIME = 3;
	
    water_led #(5) uut(
         .clk    ( clk    ),
         .rst_n  ( rst_n  ),
         .dout   ( dout   )   
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
		din=0;
        #(10*CYCLE);
		
    end

endmodule