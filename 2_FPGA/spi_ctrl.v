/***********************************************************************
　　   ****************** name：spi_ctrl **************
　　          ********** author：made by LKF **********
　　   ****************** time：2016.10.9 **********************
***********************************************************************
		->deal with stm32 write da and read adc. 
		->deal with analog mode write da and read adc.
		->produce adc cycle sample control signal for CCS and OPP.
**************************************************************************/

`include "address.v"
`define	DAC_CHA					2'b00
`define	DAC_CHB					2'b01
`define  DAC_WRITE_REG			2'b00
`define	DAC_WRITE_UPDATE		2'b01
`define	DAC_WRITE_ALL_UPDATE	2'b10
`define	POWER_DOWN				2'b11

module spi_ctrl(
	input		rstn_i,
	input		clk64_i,
	input		da_set_mod,				//0:disable ang set da 1:enable ang set da   
	input    SCN_MD,					//0:fpga passive sample 1:fpga active sample 
	input		samp_enable,			//adc sample driving signal 0:not sample 1:continous sample
	//fsmc 
	input		csn_i,
	input		wrn_i,
	input		rdn_i,
	input		[7:0]  fsmc_addr,
	input		[15:0] spi_data_i_buf,
	//ANG 
	input		ang_da_update_i,			//posedge update da 		
	input    [11:0]ang_da_data_i,
	//SPI
	output   [6:0]spi_we_o,
	output   [6:0]spi_cyc_o,
	output   [6:0]spi_stb_o,
	output   spi_irq_o,				  //fsmc write event,ack irq
	//SPI common contrl 
	output	[1:0]  spi_addr_o,
	output	[15:0] spi_data_o,
	input		[6:0]spi_ack_i,
	input		[6:0]spi_irq_i,

	output	adc_chnl,					//fsmc select ad chnl
	output   scn_valid_flag,			//scn_mod+delay 2.5us
	output	ccs_adda_sel,			 	//0:write ad 1:write da
	output   dac_setpower_flag			//dac set power bigger than min
);
//dac set power flag
assign dac_setpower_flag = da_set_mod ? angdac_setpower_flag : rsdac_setpower_flag;
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

//ang da update signal detect
reg ang_da_update_reg,ang_da_update_regr,ang_da_update_regrr;
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		begin
		ang_da_update_reg <= 1'b1;
		ang_da_update_regr<= 1'b1;
		ang_da_update_regrr <= 1'b1;
		end
	else 
		begin
		ang_da_update_reg <= ang_da_update_i;
		ang_da_update_regr<= ang_da_update_reg;
		ang_da_update_regrr <= ang_da_update_regr;
		end
	end
wire ang_da_update_posedge = ~ang_da_update_regrr & ang_da_update_regr;		

reg	[9:0]	 spi_current_state;
reg	[9:0]  spi_next_state;
reg 	[1:0]	 spi_offset_reg;
reg   [15:0] spi_in_data_reg;

//------------------SPI write or read process----------------------
parameter SPI_IDLE			= 10'b00_0000_0001;
parameter SPI_ADC_CONFIG	= 10'b00_0000_0010;
parameter SPI_ADC_RD			= 10'b00_0000_0100;
parameter SPI_DAC_CONFIG	= 10'b00_0000_1000;
parameter SPI_DACSET_WR		= 10'b00_0001_0000;
parameter SPI_DACOFFSET_WR	= 10'b00_0010_0000;
parameter SPI_REG_WR			= 10'b00_0100_0000;
parameter SPI_REG_RD			= 10'b00_1000_0000;	

//fsmc/ang write or read da/ad data reg flag
reg fwrite_angdaset_req;
reg fwrite_daset_req;
reg fwrite_daoffset_req;
reg fwrite_adc_req;
reg fwrite_reg_req;
reg fread_reg_req;
reg adc_chnl_reg;
reg spi_irq_reg;
reg[15:0] ccs_dacset_reg;      //dac set value
reg[15:0] ccs_angdacset_reg;	 //ang dac set value
reg[15:0] ccs_dacoffset_reg;	 //offset dac set value 
wire spi_irq,spi_ack;
assign spi_irq = |spi_irq_i;
assign spi_ack = |spi_ack_i;

always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)  
		begin
		fwrite_angdaset_req <= 1'b0;
		fwrite_daset_req <= 1'b0;
		fwrite_daoffset_req <= 1'b0;
		fwrite_adc_req <= 1'b0;
		fwrite_reg_req <= 1'b0;
		fread_reg_req <= 1'b0;
		ccs_dacset_reg	<= 16'b0;
		ccs_angdacset_reg <= 16'b0;
		ccs_dacoffset_reg <= 16'b0;
		adc_chnl_reg		<= 1'b0;
		end

	else if(da_set_mod & ang_da_update_posedge)	  			//ad mode da update
		begin
		fwrite_angdaset_req <= 1'b1;
		ccs_angdacset_reg	<= {4'b0,ang_da_data_i};  			//all way
		end	
	else if(da_set_mod && fwrite_angdaset_req && spi_irq_reg && (spi_current_state == SPI_DACSET_WR))
		fwrite_angdaset_req <= 1'b0;					 			//rd clear irq finished
		
	else 
		begin
		if(~da_set_mod)												//cancel ang mode
			begin
			fwrite_angdaset_req <= 1'b0;
			ccs_angdacset_reg	<= 16'b0;  			 
			end
			
		if(SCN_MD | fwrite_angdaset_req)				//SCN_MD | fwrite_angdaset_req = 1,disable all fsmc operation
			begin
			fwrite_daset_req <= 1'b0;
			fwrite_daoffset_req <= 1'b0;
			fwrite_adc_req <= 1'b0;
			fwrite_reg_req <= 1'b0;
			fread_reg_req <= 1'b0;
			ccs_dacoffset_reg <= 16'b0; 
			ccs_dacset_reg	<= 16'b0;
			end
		
		else if(~csn_i_reg2 & wrn_i_reg1 & ~wrn_i_reg2 & rdn_i_reg1)    			//write poseedge
			case(spi_addr_reg)
				`ADDR_CCS_DACSET	: 			
					begin 
					fwrite_daset_req <= 1'b1; 
					ccs_dacset_reg <= spi_data_i_buf; 
					end
				`ADDR_CCS_DACOFFSET:		
					begin	
					fwrite_daoffset_req <= 1'b1; 
					ccs_dacoffset_reg <= spi_data_i_buf; 
					end
				`ADDR_CCS_ADCRV,`ADDR_OPP_AD0:		
					begin	
					fwrite_adc_req <= 1'b1; 
					adc_chnl_reg	<= 1'b0; 
					end 
				`ADDR_CCS_ADCMV,`ADDR_OPP_AD1:		
					begin	
					fwrite_adc_req <= 1'b1; 
					adc_chnl_reg	<= 1'b1;
					end 	
				`ADDR_CCS_SPISET: 
					fwrite_reg_req <= 1'b1;
				endcase
		else if(~csn_i_reg1 & ~rdn_i_reg1 & rdn_i_reg2 & wrn_i_reg1) 		//read negedge
			case(spi_addr_reg)
				`ADDR_CCS_SPISET,`ADDR_CCS_ADCRV,`ADDR_OPP_AD0,
				`ADDR_CCS_ADCMV,`ADDR_OPP_AD1,`ADDR_CCS1_SPISTA,`ADDR_CCS2_SPISTA,`ADDR_CCS3_SPISTA,
				`ADDR_CCS4_SPISTA,`ADDR_CCS5_SPISTA,`ADDR_CCS6_SPISTA,`ADDR_OPP_SPISTA:
					fread_reg_req <= 1'b1; 
				endcase
		//flag clear
		else if(fwrite_daset_req && (spi_irq && spi_current_state == SPI_DACSET_WR))	   		//fsmc write daset finished
			fwrite_daset_req <= 1'b0;
		else if(fwrite_daoffset_req && (spi_irq && spi_current_state == SPI_DACOFFSET_WR))	   //fsmc write daoffset finished
			fwrite_daoffset_req <= 1'b0;

		else if(fwrite_adc_req && (spi_irq && spi_current_state == SPI_ADC_RD)) 		         //fsmc write adc finished
			fwrite_adc_req <= 1'b0;
	
		else if(fwrite_reg_req && (spi_ack && spi_current_state == SPI_REG_WR))  		      	//fsmc write reg finished
			fwrite_reg_req <= 1'b0;
	
		else if(fread_reg_req && (spi_ack && spi_current_state == SPI_REG_RD))  					//fsmc read reg finished
			fread_reg_req <= 1'b0;		
		end
	end

//SPI irq and ack
reg spi_irq_regr;
reg spi_angwrda_flag;   //analog write da process from enter in angwrda write da to irq negedge, to keep not output irq 
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		spi_angwrda_flag <= 1'b0;
	else if(fwrite_angdaset_req && spi_current_state == SPI_DACSET_WR)
		spi_angwrda_flag <= 1'b1;
	else if(spi_angwrda_flag & spi_irq_regr & ~spi_irq_reg)
		spi_angwrda_flag <= 1'b0;
	end

assign spi_irq_o = spi_angwrda_flag ? 1'b0 : spi_irq_regr;
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

//when cancel frame sample state,clear the irq  
//scn_md delay
reg[7:0]	count_scn;
parameter SCN_DELAY = 8'd160;//2.5us
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		count_scn <= 8'd0;
	else if(SCN_MD)
		count_scn <= SCN_DELAY;
	else if(count_scn > 8'd0)
		count_scn <= count_scn - 1'b1;
	end
assign scn_valid_flag = (count_scn > 8'd0) ? 1'b1 : 1'b0;

//SCN_MD posedge:produce a time read spi to confirm irq_o low 
reg  scn_md_reg;
wire scn_md_posedge; 
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		scn_md_reg <= 1'b0;
	else
		scn_md_reg <= SCN_MD;
	end
assign scn_md_posedge = ~scn_md_reg & SCN_MD;
	
//spi write and read event
wire   spi_wr,spi_rd;
wire   spi_configadc_wr,spi_rdadc_wr;
wire 	 spi_configdac_wr,spi_dacset_wr,spi_dacoffset_wr;
wire   spi_reg_wr,spi_reg_rd,spi_irq_rd;
wire	 spi_angirq_rd;

assign spi_configadc_wr = ~spi_current_state[1] & spi_next_state[1];
assign spi_rdadc_wr 		= ~spi_current_state[2] & spi_next_state[2];
assign spi_configdac_wr = ~spi_current_state[3] & spi_next_state[3];
assign spi_dacset_wr 	= ~spi_current_state[4] & spi_next_state[4];
assign spi_dacoffset_wr = ~spi_current_state[5] & spi_next_state[5];
assign spi_reg_wr 		= ~spi_current_state[6] & spi_next_state[6];
assign spi_reg_rd 		= ~spi_current_state[7] & spi_next_state[7];
assign spi_angirq_rd    = fwrite_angdaset_req & spi_current_state[4] & ~spi_next_state[4];

assign spi_irq_rd 		= scn_valid_flag & (~spi_irq_reg & spi_irq);    
assign spi_wr = spi_configadc_wr | spi_rdadc_wr | spi_configdac_wr | spi_dacset_wr | spi_dacoffset_wr | spi_reg_wr;
assign spi_rd = spi_reg_rd | spi_irq_rd | scn_md_posedge | spi_angirq_rd;

//DA channel select,produce spi_cs signal
reg	spi_wr_reg,spi_rd_reg,spi_reg_rd_reg;
wire spi_we,spi_stb;
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		begin
		spi_wr_reg <= 1'b0;
		spi_rd_reg <= 1'b0;
		spi_reg_rd_reg <= 1'b0;
		end
	else
		begin
		spi_wr_reg <= spi_wr;
		spi_rd_reg <= spi_rd;
		spi_reg_rd_reg <= spi_reg_rd;
		end
	end
	
assign spi_we =  spi_wr_reg;
assign spi_stb = spi_wr_reg | spi_rd_reg;

reg  	[6:0]spi_all_we;
reg	[6:0]spi_all_stb;
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		begin
		spi_all_we <= 7'b0;
		spi_all_stb <= 7'b0;
		end
	else if(spi_current_state == SPI_DACSET_WR & da_set_mod)
		begin spi_all_we <= {7{spi_we}}; spi_all_stb <= {7{spi_stb}};end
	else if(spi_current_state == SPI_DACSET_WR & ~da_set_mod)
		case(ccs_dacset_reg[14:12])
			3'b000:	begin spi_all_we <= {7{spi_we}}; spi_all_stb <= {7{spi_stb}};end
			3'b001:	begin spi_all_we <= {6'b0,spi_we}; spi_all_stb <= {6'b0,{spi_stb}};end
			3'b010:	begin spi_all_we <= {5'b0,spi_we,1'b0}; spi_all_stb <= {5'b0,{spi_stb},1'b0};end
			3'b011:	begin spi_all_we <= {4'b0,spi_we,2'b0}; spi_all_stb <= {4'b0,{spi_stb},2'b0};end
			3'b100:	begin spi_all_we <= {3'b0,spi_we,3'b0}; spi_all_stb <= {3'b0,{spi_stb},3'b0};end
			3'b101:	begin spi_all_we <= {2'b0,spi_we,4'b0}; spi_all_stb <= {2'b0,{spi_stb},4'b0};end
			3'b110:	begin spi_all_we <= {1'b0,spi_we,5'b0}; spi_all_stb <= {1'b0,{spi_stb},5'b0};end
			default: begin spi_all_we <= 7'b0;spi_all_stb <= 7'b0;end
		endcase
	else if(spi_current_state == SPI_DACOFFSET_WR)
		case(ccs_dacoffset_reg[14:12])
			3'b000:	begin spi_all_we <= {7{spi_we}}; spi_all_stb <= {7{spi_stb}};end
			3'b001:	begin spi_all_we <= {6'b0,spi_we}; spi_all_stb <= {6'b0,{spi_stb}};end
			3'b010:	begin spi_all_we <= {5'b0,spi_we,1'b0}; spi_all_stb <= {5'b0,{spi_stb},1'b0};end
			3'b011:	begin spi_all_we <= {4'b0,spi_we,2'b0}; spi_all_stb <= {4'b0,{spi_stb},2'b0};end
			3'b100:	begin spi_all_we <= {3'b0,spi_we,3'b0}; spi_all_stb <= {3'b0,{spi_stb},3'b0};end
			3'b101:	begin spi_all_we <= {2'b0,spi_we,4'b0}; spi_all_stb <= {2'b0,{spi_stb},4'b0};end
			3'b110:	begin spi_all_we <= {1'b0,spi_we,5'b0}; spi_all_stb <= {1'b0,{spi_stb},5'b0};end
			default: begin spi_all_we <= 7'b0;spi_all_stb <= 7'b0;end
		endcase
	else if(spi_current_state == SPI_ADC_RD)  //spi_irq_rd cleared
		begin 
		spi_all_we <= {7{spi_we}}; 
		spi_all_stb <= {7{spi_stb}};
		end	
	else if(spi_current_state == SPI_ADC_CONFIG | spi_current_state == SPI_DAC_CONFIG | spi_current_state == SPI_REG_WR)
		begin 
		spi_all_we <= {7{spi_we}}; 
		spi_all_stb <= {7{spi_stb}};
		end	
	else if(spi_current_state == SPI_REG_RD)
		begin 
		spi_all_we <= 7'b0; 
		spi_all_stb <= {7{spi_stb}};
		end
	else
		begin 
		spi_all_we <= 7'b0;
		//spi_all_we  <= {7{spi_we}};
		spi_all_stb <= {7{spi_stb}};    //default rd 
		end
	end
assign spi_we_o = spi_all_we;
assign spi_stb_o = spi_all_stb;
assign spi_cyc_o = spi_all_stb;

reg samp_enable_reg,samp_enable_regr;
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		begin
		samp_enable_reg  <= 1'b0;
		samp_enable_regr <= 1'b0;
		end
	else
		begin
		samp_enable_reg  <= samp_enable;
		samp_enable_regr <= samp_enable_reg;
		end
	end
		
//spi read and write
always @(posedge clk64_i or negedge rstn_i)
	begin : SPI_FSM_SEQ
	if (~rstn_i)
		spi_current_state <= SPI_IDLE;
	else
		spi_current_state <= spi_next_state;
	end

	
always @(rstn_i or spi_current_state or spi_next_state or fwrite_daset_req or fwrite_daoffset_req 
			or fwrite_adc_req or fwrite_reg_req or fread_reg_req or fwrite_angdaset_req
			or samp_enable_regr or spi_ack or spi_irq_reg)
	begin : SPI_FSM_WR_RD_COMBO
	if (~rstn_i)
		spi_next_state = SPI_IDLE;
	else
		case(spi_current_state)
			SPI_IDLE: 
				if(fread_reg_req)
					spi_next_state = SPI_REG_RD;  //ack
				else if(fwrite_reg_req)
					spi_next_state = SPI_REG_WR;	//ack
				else if(spi_irq_reg)   //wait irq low
					spi_next_state = SPI_IDLE;
				else if(fwrite_daset_req | fwrite_daoffset_req | fwrite_angdaset_req)
					spi_next_state = SPI_DAC_CONFIG;
				else if(fwrite_adc_req)
					spi_next_state = SPI_ADC_CONFIG;
				else if(samp_enable_regr) 
					spi_next_state = SPI_ADC_CONFIG;
				else
					spi_next_state = SPI_IDLE;
			SPI_ADC_CONFIG	: spi_next_state = (spi_ack)?SPI_ADC_RD:SPI_ADC_CONFIG;
			SPI_ADC_RD		: spi_next_state = (spi_irq_reg)?SPI_IDLE:SPI_ADC_RD;
			SPI_DAC_CONFIG	: 
				if(spi_ack & (fwrite_daset_req | fwrite_angdaset_req))
					spi_next_state = SPI_DACSET_WR;
				else if(spi_ack & fwrite_daoffset_req)
					spi_next_state = SPI_DACOFFSET_WR;
				else
					spi_next_state = SPI_DAC_CONFIG;
			SPI_DACSET_WR	: spi_next_state = (spi_irq_reg)?SPI_IDLE:SPI_DACSET_WR;
			SPI_DACOFFSET_WR	: spi_next_state = (spi_irq_reg)?SPI_IDLE:SPI_DACOFFSET_WR;
			SPI_REG_WR		: spi_next_state = (spi_ack)?SPI_IDLE:SPI_REG_WR;
			SPI_REG_RD		: spi_next_state = (spi_ack)?SPI_IDLE:SPI_REG_RD;
			default			: spi_next_state = SPI_IDLE;
		endcase
	end


reg	angdac_setpower_flag;
reg	rsdac_setpower_flag;
always @(posedge clk64_i or negedge rstn_i)
	begin : SPI_WRITE_READ_ADDR_FSM_OUT
	if (~rstn_i)
		begin
		spi_offset_reg <= 2'b0;
		angdac_setpower_flag <= 1'b0;
		rsdac_setpower_flag  <= 1'b0;
		end
	else if (spi_wr_reg)
		case (spi_current_state)
			SPI_ADC_CONFIG:	
				begin 
				spi_offset_reg <= `OFFSET_SPI_CTRL; 
				spi_in_data_reg <= 16'h585d;	//RXNEIE_BIT=1,IRQEN_BIT=1,DFF_BIT=1 16bit,BR=b011 1/8div freq,CPHA_BIT=0 negedge//16'h584c;	 	
				end
			SPI_ADC_RD:	
				begin
				spi_offset_reg <= `OFFSET_SPI_DATA; 
				spi_in_data_reg <= 16'h0000; 		 
				end
			SPI_DAC_CONFIG:	
				begin	
				spi_offset_reg <= `OFFSET_SPI_CTRL; 
				spi_in_data_reg <= 16'h585d; //RXNEIE_BIT=1,IRQEN_BIT=1,DFF_BIT=1 16bit,BR=b011 1/8div freq,CPHA_BIT=0 negedge //16'h584d; 	
				end
			SPI_DACSET_WR:	
				begin	
				spi_offset_reg <= `OFFSET_SPI_DATA;
				if(fwrite_angdaset_req)
					begin
					spi_in_data_reg <= {`DAC_CHA,`DAC_WRITE_UPDATE,ccs_angdacset_reg[11:0]};
					if(ccs_angdacset_reg[11:0] > `DAC_JUDSET_MIN)
							angdac_setpower_flag <= 1'b1;
					else
							angdac_setpower_flag <= 1'b0;
					end
				else
					begin
					spi_in_data_reg <= {`DAC_CHA,`DAC_WRITE_UPDATE,ccs_dacset_reg[11:0]};
					if(ccs_dacset_reg[11:0] > `DAC_JUDSET_MIN)
							rsdac_setpower_flag <= 1'b1;
					else
							rsdac_setpower_flag <= 1'b0;
					end
				end
			SPI_DACOFFSET_WR:
				begin	
				spi_offset_reg <= `OFFSET_SPI_DATA;
				spi_in_data_reg <= {`DAC_CHB,`DAC_WRITE_UPDATE,ccs_dacoffset_reg[11:0]}; 
				end
			SPI_REG_WR:	
				begin	
				spi_offset_reg <= `OFFSET_SPI_CTRL; 
				spi_in_data_reg <= spi_data_i_buf;
				end
			default:	
				begin 
				spi_offset_reg <= `OFFSET_SPI_CTRL; 
				spi_in_data_reg <= 16'h0000; 		
				end	
		endcase
	else if(spi_reg_rd_reg && spi_current_state == SPI_REG_RD)
		begin
		spi_in_data_reg <= 16'h0000; 
		case(spi_addr_reg)
			`ADDR_CCS_SPISET:
				spi_offset_reg <= `OFFSET_SPI_CTRL; 
			`ADDR_CCS_ADCRV,`ADDR_OPP_AD0,`ADDR_CCS_ADCMV,`ADDR_OPP_AD1:
				spi_offset_reg <= `OFFSET_SPI_DATA;
			`ADDR_CCS1_SPISTA,`ADDR_CCS2_SPISTA,`ADDR_CCS3_SPISTA,
			`ADDR_CCS4_SPISTA,`ADDR_CCS5_SPISTA,`ADDR_CCS6_SPISTA,
			`ADDR_OPP_SPISTA:
				spi_offset_reg <= `OFFSET_SPI_STATUS;
			default:
					spi_offset_reg <= `OFFSET_SPI_DATA;
			endcase
		end
	else
		begin
		spi_offset_reg <= `OFFSET_SPI_DATA;
		spi_in_data_reg <= 16'h0000; 
		end
	end
	
assign spi_addr_o = spi_offset_reg;
assign spi_data_o = spi_in_data_reg;
assign adc_chnl = adc_chnl_reg;
assign ccs_adda_sel = (spi_current_state == SPI_DAC_CONFIG) ||	(spi_current_state == SPI_DACSET_WR) || (spi_current_state == SPI_DACOFFSET_WR) ? 1'b1 : 1'b0;				  
endmodule
