`timescale 1ns/1ns
module seg_led_tb();	
    reg clk;
    reg rst_n;	
    wire[7:0] segment;
	wire[7:0] segsel;
	
    parameter CYCLE = 20;
	parameter RST_TIME = 3;
	
    seg_led #(.TIME_1s(2) ) uut(
         .clk( clk ),
         .rst_n( rst_n ),
		 .segment( segment ),
		 .segsel( segsel )
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
		//din=0;
        #(10*CYCLE);
		
    end

endmodulepsi  水压传感器