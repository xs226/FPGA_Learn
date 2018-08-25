/***********************************************************************
　　   ****************** name：ccs_sw_ctl Driver **************
　　          ********** author：made by LKF **********
　　   ****************** time：2016.10.9 **********************
***********************************************************************
		According conttl input and mod_in,produce const current switch contrl signal. 
		ex_offset_sw: the second offset current output 
		ccs_sw:const current switch output
**************************************************************************/
module ccs_sw_ctl(
	input		rstn_i,
	input		clk64_i,
	input		mod_in_i,
	input		enable_i,						//1:on 0:off
	input		[1:0]mode_sel,					//00:DC 01:modulate 10:AD 11:raycus inner modulation(reserved for test)
	input		CCS_RD,							//lightout enable
	input		[20:0] period_count,       //50Hz-50KHz: 1280000~1280 64M CLK
	input		[20:0] duty_count,			//duty (0~100%):0~1280000  64M CLK		
	input		[7:0] fpul_dep_delay,		//first pulse depression delay
	
	output	ex_offset_sw,					//the second offset switch
	output	ccs_sw							//ccs switch signal
	);

//-----------------------mode select-----------------------------------------------
wire MODULATE_IN; //1:inner modulate for raycus 
assign MODULATE_IN = (mode_sel == 2'b11) ? 1'b1 : 1'b0;
//-----------------------MOD_IN_MODULATE:period and duty---------------------------	
wire  dis_update_flag;
wire	pwm_period_zero;
wire  mod_inmodulate_offsta;
reg[20:0] period_cnt_reg;
assign pwm_period_zero = (21'b1 == period_cnt_reg);
assign dis_update_flag = ~MODULATE_IN |(MODULATE_IN & CCS_RD & pwm_period_zero & mod_in_i);
assign mod_inmodulate_offsta = ~MODULATE_IN | ~CCS_RD | ~enable_i | ~mod_in_i;

reg[20:0] period_count_reg;
reg[20:0] duty_count_reg;

always @(posedge clk64_i or negedge rstn_i)
	begin  
	if(~rstn_i)
		begin
		period_count_reg <= 21'b0;
		duty_count_reg   <= 21'b0;
		end
	else if(!dis_update_flag)
		begin
		period_count_reg <= period_count;
		duty_count_reg	  <= duty_count;
		end
	end
	
//clock divider for 64MHz clk generation
always @(posedge clk64_i or negedge rstn_i)
	begin : Clk64_PWM_period_proc
	if (~rstn_i)
		period_cnt_reg <= 21'b1;
   else if (mod_inmodulate_offsta)
		period_cnt_reg <= 21'b1;
	else if (pwm_period_zero)
		period_cnt_reg <= period_count_reg;
	else if(period_count_reg == 21'b0)
		period_cnt_reg <= 21'b1;
	else
		period_cnt_reg <= period_cnt_reg - 1'b1;
	end

//duty count
reg[20:0] duty_cnt_reg;
wire duty;
assign duty = (21'b0 != duty_cnt_reg);
always @(posedge clk64_i or negedge rstn_i)
	begin : Clk64_PWM_duty_proc
	if (~rstn_i)
		duty_cnt_reg <= 21'b0;
   else if (mod_inmodulate_offsta)
		duty_cnt_reg <= 21'b0;
	else if (pwm_period_zero)
		duty_cnt_reg <= duty_count_reg;
	else if(duty)
		duty_cnt_reg <= duty_cnt_reg - 1'b1; 
	end

//----------------------const current switch ctrl----------------------
reg  ccs_sw_reqr;
reg  first_lowlgt_flag;
reg	offlgt_overtime_flag;
wire ccs_sw_req;
wire ex_offset_sig;
wire overshoot_clr_en;
assign ccs_sw_req = (CCS_RD & enable_i)? (MODULATE_IN ? duty:mod_in_i) :1'b0;
assign overshoot_clr_en = (8'b0 != fpul_dep_delay);
assign ex_offset_sig = (CCS_RD & (~ccs_sw)) ? 1'b1:1'b0;
assign ccs_sw = ccs_sw_reqr & (!first_lowlgt_flag) & enable_i;
assign ex_offset_sw = enable_i & (ex_offset_sig | first_lowlgt_flag) & overshoot_clr_en & ~offlgt_overtime_flag;

always @(posedge clk64_i or negedge rstn_i)
	begin  
	if(~rstn_i)
		ccs_sw_reqr <= 1'b0;
	else
		ccs_sw_reqr <= ccs_sw_req;
	end
	
//off light state overtime detect
parameter
		DELAY_100MS			= 	24'd640_0000,
		DELAY_200MS			=  24'd1280_0000,
		DELAY_OFF_OFFSET	=	DELAY_100MS - 1'b1;
		
reg[23:0]	count_offlgt;
always @(posedge clk64_i or negedge rstn_i)
	begin  
	if(~rstn_i)
		begin
			count_offlgt <= 24'd0;
			offlgt_overtime_flag <= 1'b1;
		end
	else
		if(ccs_sw_req)
			begin
				count_offlgt <= 24'd0;
				offlgt_overtime_flag <= 1'b0;
			end
		else if(count_offlgt <= DELAY_OFF_OFFSET)
			count_offlgt <= count_offlgt + 1'b1;
		else
			offlgt_overtime_flag <= 1'b1;
	end

//lower light level when first lightout in offlight overtime state 
parameter	DELAY_1US		=	10'd4,//10'd64,
				DELAY_5US		=  10'd320,
				DELAY_10US		=	10'd640,
				DELAY_INTERVAL =  DELAY_1US - 1'b1;
				
reg[9:0]	count_interval;
wire	delay_interval_finished;
assign delay_interval_finished = (DELAY_INTERVAL == count_interval);
		
always @(posedge clk64_i or negedge rstn_i)
	begin  
	if(~rstn_i)
		count_interval <= 10'd0;
	else
		if(first_lowlgt_flag)
			if(delay_interval_finished)
				count_interval <= 10'd0;
			else
				count_interval <= count_interval + 1'b1;
		else
			count_interval <= 10'd0;
	end	
	
reg[11:0]	count_first_delay;
always @(posedge clk64_i or negedge rstn_i)
	begin  
	if(~rstn_i)
		begin
			count_first_delay	<= 12'b0;
			first_lowlgt_flag <= 1'b0;
		end
	else
		if(first_lowlgt_flag)
			begin
			if(delay_interval_finished && count_first_delay > 12'd1)
				count_first_delay <= count_first_delay - 1'b1;
			else if(delay_interval_finished && count_first_delay <= 12'd1)
				first_lowlgt_flag <= 1'b0;
			end					
		else if(offlgt_overtime_flag & ccs_sw_req & overshoot_clr_en)
			begin
			first_lowlgt_flag <= 1'b1;
			count_first_delay <= (fpul_dep_delay << 3'd4);
			end			
	end

	
endmodule
