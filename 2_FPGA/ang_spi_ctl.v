/***********************************************************************
　　   ****************** name：ang_spi_ctrl **************
　　          ********** author：made by LKF **********
　　   ****************** time：2016.10.17 **********************
***********************************************************************
		->deal with stm32 write/read adc.
**************************************************************************/
`include "address.v"

module ang_spi_ctrl(
	input		rstn_i,
	input		clk64_i,
	input		samp_enable,			//0:dis 1:en
	//fsmc 
	input		csn_i,
	input		wrn_i,
	input		rdn_i,
	input		[7:0]  fsmc_addr,
	input		[15:0] spi_data_i_buf,
	//SPI
	output   spi_we_o,
	output   spi_cyc_o,
	output   spi_stb_o,
	output   spi_irq_o,
	output	[1:0]  spi_addr_o,
	output	[15:0] spi_data_o,
	input		spi_ack_i,
	input		spi_irq_i
);

// ----------------------fsmc spi ctrl-----------------------
reg	wrn_i_reg1,wrn_i_reg2;
reg	rdn_i_reg1,rdn_i_reg2;
reg	csn_i_reg1,csn_i_reg2;
reg[7:0]  spi_addr_reg;

always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		begin
		wrn_i_reg1 <= 1'b1;
		wrn_i_reg2 <= 1'b1;
		rdn_i_reg1 <= 1'b1;
		rdn_i_reg2 <= 1'b1;
		csn_i_reg1 <= 1'b1;
		spi_addr_reg <= 8'b1111_1111;
		end
	else
		begin
		wrn_i_reg1 <= wrn_i;
		wrn_i_reg2 <= wrn_i_reg1;
		rdn_i_reg1 <= rdn_i;
		rdn_i_reg2 <= rdn_i_reg1;
		csn_i_reg1 <= csn_i;
		csn_i_reg2 <= csn_i_reg1;
		spi_addr_reg <= fsmc_addr;
		end
	end

//SPI STA 
reg	[7:0]	 spi_current_state;
reg	[7:0]  spi_next_state;
reg 	[1:0]	 spi_offset_reg;
reg   [15:0] spi_in_data_reg;

//------------------SPI write or read process----------------------
parameter SPI_IDLE			= 8'b0000_0001;
parameter SPI_ADC_CONFIG	= 8'b0000_0010;
parameter SPI_ADC_RD			= 8'b0000_0100;
parameter SPI_REG_WR			= 8'b0000_1000;
parameter SPI_REG_RD			= 8'b0001_0000;	

//fsmc write or read ad and reg
reg fwrite_adc_req;
reg fwrite_reg_req;
reg fread_reg_req;
wire spi_irq,spi_ack;
assign spi_irq = spi_irq_i;
assign spi_ack = spi_ack_i;

always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)  
		begin
		fwrite_adc_req <= 1'b0;
		fwrite_reg_req <= 1'b0;
		fread_reg_req  <= 1'b0;
		end
	else
		begin
		if(~csn_i_reg2 & wrn_i_reg1 & ~wrn_i_reg2 & rdn_i_reg1)    			//write poseedge
			case(spi_addr_reg)
				`ADDR_ANG_SPISET: 		
					fwrite_reg_req <= 1'b1;
				`ADDR_ANG_SPIDATA:		
					fwrite_adc_req <= 1'b1;
			endcase
		else if(~csn_i_reg1 & ~rdn_i_reg1 & rdn_i_reg2 & wrn_i_reg1) 		//read negedge
			case(spi_addr_reg)
				`ADDR_ANG_SPISET,`ADDR_ANG_SPISTA,`ADDR_ANG_SPIDATA:
						fread_reg_req <= 1'b1;			
			endcase
		else if(fwrite_adc_req && (spi_irq && spi_current_state == SPI_ADC_RD)) 		         //fsmc write ad0 finished
			fwrite_adc_req <= 1'b0;
	
		else if(fwrite_reg_req && (spi_ack && spi_current_state == SPI_REG_WR))  		      	//fsmc write reg finished
			fwrite_reg_req <= 1'b0;
	
		else if(fread_reg_req && (spi_ack && spi_current_state == SPI_REG_RD))  					//fsmc read reg finished
			fread_reg_req <= 1'b0;
		end	
	end

//SPI irq and ack
reg spi_irq_reg,spi_irq_regr;
assign spi_irq_o = spi_irq_regr;
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		begin
		spi_irq_reg  <= 1'b0;
		spi_irq_regr <= 1'b0;
		end
	else
		begin
		spi_irq_reg   <= spi_irq;
		spi_irq_regr  <= spi_irq_reg;
		end
	end

//samp_enable posedge:produce a read spi to confirm irq_o low 
wire samp_enable_posedge; 
reg  samp_enable_reg;

always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		samp_enable_reg <= 1'b0;
	else
		samp_enable_reg <= samp_enable;
	end
assign samp_enable_posedge = ~samp_enable_reg & samp_enable;

//adcsamp:clear irq  
reg[7:0]	count_adcsamp;
wire adcsamp_delay_valid;
parameter ADCSAMP_DELAY = 8'd80;//1.25us
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		count_adcsamp <= 8'd0;
	else if(samp_enable_reg)
		count_adcsamp <= ADCSAMP_DELAY;
	else if(count_adcsamp > 8'd0)
		count_adcsamp <= count_adcsamp - 1'b1;
	end
assign adcsamp_delay_valid = (count_adcsamp > 8'd0) ? 1'b1 : 1'b0;
	
//spi write and read event
wire   spi_wr,spi_rd;
wire   spi_configadc_wr,spi_rdadc_wr;
wire   spi_reg_wr,spi_reg_rd,spi_irq_rd;

assign spi_configadc_wr = ~spi_current_state[1] & spi_next_state[1];
assign spi_rdadc_wr	 	= ~spi_current_state[2] & spi_next_state[2];
assign spi_reg_wr 		= ~spi_current_state[3] & spi_next_state[3];
assign spi_reg_rd 		= ~spi_current_state[4] & spi_next_state[4];
assign spi_irq_rd 		= adcsamp_delay_valid & (~spi_irq_reg & spi_irq);
assign spi_wr = spi_configadc_wr | spi_rdadc_wr | spi_reg_wr;
assign spi_rd = spi_reg_rd | spi_irq_rd | samp_enable_posedge;

reg	spi_wr_reg,spi_rd_reg;	
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		begin
		spi_wr_reg <= 1'b0;
		spi_rd_reg <= 1'b0;
		end
	else
		begin
		spi_wr_reg <= spi_wr;
		spi_rd_reg <= spi_rd;
		end
	end
	
assign spi_we_o =  spi_wr_reg;
assign spi_stb_o = spi_wr_reg | spi_rd_reg;
assign spi_cyc_o = spi_stb_o;

//spi read and write
always @(posedge clk64_i or negedge rstn_i)
	begin : SPI_FSM_SEQ
	if (~rstn_i)
		spi_current_state <= SPI_IDLE;
	else
		spi_current_state <= spi_next_state;
	end

	
always @(rstn_i or samp_enable or spi_current_state or spi_next_state  or
		fwrite_adc_req or fwrite_reg_req or fread_reg_req or spi_ack or spi_irq_reg)
	begin : SPI_FSM_WR_RD_COMBO
	if (~rstn_i)
		spi_next_state <= SPI_IDLE;
	else
		case(spi_current_state)
			SPI_IDLE: 
				begin
				if(fwrite_adc_req)
					spi_next_state = SPI_ADC_CONFIG;
				else if(fwrite_reg_req)
					spi_next_state = SPI_REG_WR;
				else if(fread_reg_req)
					spi_next_state = SPI_REG_RD;
				else if(samp_enable) 
					spi_next_state = SPI_ADC_CONFIG;
				else
					spi_next_state = SPI_IDLE;
				end
			SPI_ADC_CONFIG	: spi_next_state = (spi_ack)?SPI_ADC_RD:SPI_ADC_CONFIG;
			SPI_ADC_RD		: spi_next_state = (spi_irq_reg)?SPI_IDLE:SPI_ADC_RD;
			SPI_REG_WR		: spi_next_state = (spi_ack)?SPI_IDLE:SPI_REG_WR;
			SPI_REG_RD		: spi_next_state = (spi_ack)?SPI_IDLE:SPI_REG_RD;
			default			: spi_next_state = SPI_IDLE;
		endcase
	end


always @(posedge clk64_i or negedge rstn_i)
	begin : SPI_WRITE_READ_ADDR_FSM_OUT
	if (~rstn_i)
		begin
		spi_offset_reg <= 2'b0;
		spi_in_data_reg <= 16'h0000;
		end
	else if (spi_wr)
		case (spi_next_state)
			SPI_ADC_CONFIG:	
				begin 
				spi_offset_reg <= `OFFSET_SPI_CTRL; 
				spi_in_data_reg <= 16'h584c;	//posedge sample 	
				end
			SPI_ADC_RD:	
				begin
				spi_offset_reg <= `OFFSET_SPI_DATA; 
				spi_in_data_reg <= 16'h0000; 		
				end
			SPI_REG_WR:	
				begin	
				spi_offset_reg <= `OFFSET_SPI_CTRL; 
				spi_in_data_reg <= spi_data_i_buf;
				end
			default:	
				begin 
				spi_offset_reg <= `OFFSET_SPI_DATA; 
				spi_in_data_reg <= 16'h0000; 		
				end	
		endcase
	else if(spi_reg_rd && spi_next_state == SPI_REG_RD)
		begin
		spi_in_data_reg <= 16'h0000; 
		case(spi_addr_reg)
			`ADDR_ANG_SPISET:
				spi_offset_reg <= `OFFSET_SPI_CTRL; 
			`ADDR_ANG_SPIDATA:
				spi_offset_reg <= `OFFSET_SPI_DATA;
			`ADDR_ANG_SPISTA:
				spi_offset_reg <= `OFFSET_SPI_STATUS;
			default:
				spi_offset_reg <= `OFFSET_SPI_DATA;
			endcase
		end
	else if(spi_rd)
		begin
		spi_offset_reg <= `OFFSET_SPI_DATA;
		spi_in_data_reg <= 16'h0000; 
		end
	end

assign spi_addr_o = spi_offset_reg;
assign spi_data_o = spi_in_data_reg;
						  
endmodule