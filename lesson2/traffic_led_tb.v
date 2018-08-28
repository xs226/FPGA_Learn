`timescale 1ns/1ns
module traffic_led_tb();	
    reg clk;
    reg rst_n;	
    wire[2:0] led_east;
	wire[2:0] led_south;
	wire[2:0] led_west;
	wire[2:0] led_north;
	
    parameter CYCLE = 20;
	parameter RST_TIME = 3;
	
    traffic_led #(2) uut(
         .clk( clk ),
         .rst_n( rst_n ),
		 .led_east( led_east ),
		 .led_west( led_west ),
		 .led_south( led_south ),
		 .led_north( led_north )
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

endmodule