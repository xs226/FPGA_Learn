module module_name(
	clk;
	rst_n;
	din;
	dout
);

input clk ;
input rst_n;
input [DATA_W-1:0] din;
output[DATA_W-1:0] dout;
	
parameter  DATA_W    =  8;

always@(*)begin
    
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        
    end
    else if() begin
        
    end
end

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        
    end
    else if() begin
        
    end
end

endmodule




`timescale 1ns/1ns
module testbench_name();	
    reg clk;
    reg rst_n;	
    reg din;
    wire[3:0] dout;
	
    parameter CYCLE = 20;
	parameter RST_TIME = 3;
	
    module_name uut(
         .clk( clk ),
         .rst_n( rst_n ),
		 .din( din ),
         .dout( dout )   
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

always@(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        
    end
    else if() begin
        
    end
end

parameter TIME_S = 5_000_000 ;
reg[23:0] cnt_s;
wire add_cnt_s;
wire end_cnt_s;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt_s <= 0;
    end
    else if(add_cnt_s) begin
        if(end_cnt_s) cnt_s <= 0;
        else cnt_s <= cnt_s + 1;
    end
end

assign add_cnt_s = flag1 ;       
assign end_cnt_s = add_cnt_s && cnt_s==TIME_S-1 ; 









