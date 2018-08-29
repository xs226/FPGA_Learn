`timescale 1ns/1ns
module seg_led_tb();	
    reg clk;
    reg rst_n;	
    wire[7:0] segment;
	wire[7:0] segsel;
	
    parameter CYCLE = 20;
	parameter RST_TIME = 3;
	
    seg_led #(.TIME_1s(1) ) uut(
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

endmodule

virtual type {
{8'b00000011 DATA0}
{8'b11110011 DATA1}
{8'b00100101 DATA2}
{8'b00001101 DATA3}
{8'b10011001 DATA4}
{8'b01001001 DATA5}
{8'b01000001 DATA6}
{8'b00011111 DATA7}
{8'b00000001 DATA8}
{8'b00001001 DATA9}
} SEG_DATA;

virtual function {(SEG_DATA)/uut_name/signal} new_signal;

add wave -hex -color pink new_signal;