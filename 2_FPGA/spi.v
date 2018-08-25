/***********************************************************************
　　   ****************** name：spi Driver **************
　　          ********** author：made by LKF **********
　　   ****************** time：2016.10.9 **********************
**************************************************************************/
`include "address.v"
  //offset address in spi
 `define  OFFSET_SPI_DATA			2'b00
 `define  OFFSET_SPI_CTRL			2'b01
 `define	 OFFSET_SPI_STATUS		2'b10
 
`define	TXEIE_BIT		15    //Tx buffer empty interrupt enable   
`define	RXNEIE_BIT		14    //RX buffer not empty interrupt enable
`define	ERRIE_BIT		13
`define	IRQEN_BIT		12
`define	DFF_BIT			11    //data frame format: 0 8bit ,1 16bit
`define	LSBFIRST_BIT	7     //frame format: 0 msb first,1 lsb first
`define	SPE_BIT			6     //spi enable:1 enable
`define	BR_BIT_END		5     //baud rate control
`define	BR_BIT_START	3
`define	MSTR_BIT			2     
`define	CPOL_BIT			1     //clock polarity:0 low ,1 high in spare time 
`define	CPHA_BIT			0     //clock phase:0 first edge,1 second edge

`define	BSY_BIT			7     //busy: 0 not,1 busy
`define	OVR_BIT			6     //overrun flag
`define	MODF_BIT			5     //mode fault
`define	TXE_BIT			1     //transmit buffer empty: 0 not empty , 1 empty
`define	RXNE_BIT			0     //receive buffer not empty:0 empty , 1 not empty

module spi (
	input		rstn_i,
	input		clk_i,
	input		[1:0]  addr_i,    //spi reg offset address
	input		[15:0] data_i,		
	output	[15:0] data_o,
	input    we_i,
	input    cyc_i,
	input    stb_i,
	output	ack_o,
	//slave mode
	input		nss_i,
	input		sck_i,
	input		mosi_i,
	output	miso_o,
   //master mode 
	output	nss_o,
	output	sck_o,
	output	mosi_o,
	input		miso_i,

	output	irq_o,
	output   ch_sel_wd      //ads79XX chsel window signal
	);


	
reg		ack_o_reg;
assign	ack_o = ack_o_reg;

//control register
reg		[15:0] ctl_reg;
wire		TXEIE;
wire		RXNEIE;
wire		ERRIE;
wire		IRQEN;
wire		DFF;
wire		LSBFIRST;
wire		SPE;
wire		[2:0]BR;
wire		MSTR;
wire		CPOL;
wire		CPHA;
//Status register
reg		BSY_flag_reg;
reg		OVR_flag_reg;
reg		MODF_flag_reg;
reg		TXE_flag_reg;
reg		RXNE_flag_reg;
wire		BSY;
wire		OVR;
wire		MODF;
wire		TXE;
wire		RXNE;
//Buffer register
reg		[15:0] tx_buf_reg;
reg		[15:0] rx_buf_reg;
//Bit counter register
reg		[4:0] bit_cnt_reg;
//clock divider register
reg		[7:0] dvd_cnt_reg;
reg		dvd_reg;
wire		dvd_zero;
//Shift register
reg		[15:0] shift_reg;
wire		shift_clk;
wire		shift_clk_negedge;
reg		shift_negative_edge_reg;
wire		shift_negative_edge_nxt;
wire		shift_tx_data;
wire		shift_rx_data;

wire		tx_start;
wire		tx_end;

reg		nss_i_reg1;
reg		nss_i_reg2;
reg		sck_i_reg1;
reg		sck_i_reg2;

reg		tx_start_reg1;

// -------Buffer Register----------------------
always @(posedge clk_i or negedge rstn_i)
   begin : write_read_proc
	if (~rstn_i)
		begin
		ctl_reg <= 16'b0;
		tx_buf_reg <= 16'b0;
		rx_buf_reg <= 16'b0;
		end
	else if (stb_i & cyc_i)
		case({we_i,addr_i})
			{1'b1,`OFFSET_SPI_DATA}	:	if (1'b1 == TXE)
													tx_buf_reg <= data_i;
			{1'b1,`OFFSET_SPI_CTRL}	:	ctl_reg <= data_i;
			{1'b0,`OFFSET_SPI_DATA}	:	if (1'b1 == RXNE)
													rx_buf_reg <= shift_reg;
			{1'b0,`OFFSET_SPI_CTRL}	:	rx_buf_reg <= {TXEIE,RXNEIE,ERRIE,IRQEN,DFF,3'b000,LSBFIRST,SPE,BR,MSTR,CPOL,CPHA};
			{1'b0,`OFFSET_SPI_STATUS}	:	rx_buf_reg <= {8'b0000_0000,BSY,OVR,MODF,3'b000,TXE,RXNE};
		endcase
   end

always @(posedge clk_i or negedge rstn_i)
   begin : acknowledge_proc
	if (~rstn_i)
		ack_o_reg <= 1'b0;
	else
		ack_o_reg <= stb_i & cyc_i;
   end
	
assign data_o = rx_buf_reg;

//  map the Control/Status register
assign TXEIE	= ctl_reg[`TXEIE_BIT];
assign RXNEIE	= ctl_reg[`RXNEIE_BIT];
assign ERRIE	= ctl_reg[`ERRIE_BIT];
assign IRQEN	= ctl_reg[`IRQEN_BIT];
assign DFF		= ctl_reg[`DFF_BIT];
assign LSBFIRST= ctl_reg[`LSBFIRST_BIT];
assign SPE		= ctl_reg[`SPE_BIT];
assign BR		= ctl_reg[`BR_BIT_END:`BR_BIT_START];
assign MSTR		= ctl_reg[`MSTR_BIT];
assign CPOL		= ctl_reg[`CPOL_BIT];
assign CPHA		= ctl_reg[`CPHA_BIT];

assign BSY 	= BSY_flag_reg;
assign OVR	= OVR_flag_reg;
assign MODF	= MODF_flag_reg;
assign TXE	= TXE_flag_reg;
assign RXNE	= RXNE_flag_reg;

// -------IRQ flag bit------------------
assign irq_o = IRQEN & ((TXEIE & TXE) | (RXNEIE & RXNE) | (ERRIE & OVR) | (ERRIE & MODF));

// -------------Busy flag------------------
assign tx_start = (MSTR)?((~BSY & SPE & ~TXE)?1'b1:1'b0):(~nss_i_reg1 & nss_i_reg2);
assign tx_end = (MSTR)?((BSY & (5'b0 == bit_cnt_reg) & shift_clk_negedge)?1'b1:1'b0):(nss_i_reg1 & ~nss_i_reg2);

// -------Status Register----------------------
always @(posedge clk_i or negedge rstn_i)
   begin : RXNE_flag_proc
	if (~rstn_i)
		RXNE_flag_reg <= 1'b0;
   else if ((`OFFSET_SPI_DATA == addr_i) & ~we_i & stb_i & RXNE)
		RXNE_flag_reg <= 1'b0;		//Rx buffer empty
	else if (tx_end & ~RXNE)
		RXNE_flag_reg <= 1'b1;
	end
//add txe delay
reg	tx_flag_sta;
reg[3:0]	tx_delay_count;
reg  	tx_delay_start;
wire 	tx_delay_finished;
parameter TX_DELAY = 4'd1;

always @(posedge clk_i or negedge rstn_i)
   begin : tx_sta_proc
	if (~rstn_i)
		tx_flag_sta <= 1'b0;
   else
		begin
		if ((`OFFSET_SPI_DATA == addr_i) & we_i & stb_i & TXE)
			begin
			tx_flag_sta <= 1'b1;
			tx_delay_start <= 1'b1;
			end
		else
			tx_delay_start <= 1'b0;
			
		if(tx_end)
			tx_flag_sta <= 1'b0;
		end
	end

always @(posedge clk_i or negedge rstn_i)
   begin : tx_delay_proc
	if (~rstn_i)
		tx_delay_count <= 4'b0;
	else if(tx_flag_sta) 
		begin
		if(tx_delay_count <= TX_DELAY )
			tx_delay_count <= tx_delay_count + 1'b1;
		end
	else
		tx_delay_count <= 4'b0;
	end
assign tx_delay_finished = (tx_delay_count == TX_DELAY) ? 1'b1 : 1'b0;

					
always @(posedge clk_i or negedge rstn_i)
   begin : TXE_flag_proc
	if (~rstn_i)
		begin
		TXE_flag_reg <= 1'b1;
		end
   else
		begin
		if(tx_delay_finished)
			TXE_flag_reg <= 1'b0;		//Tx buffer not empty
		if (tx_start)
			TXE_flag_reg <= 1'b1;
		end
	end
	
always @(posedge clk_i or negedge rstn_i)
   begin : MODF_flag_proc
   if (~rstn_i)
      MODF_flag_reg <= 1'b0;
   else if (MSTR & nss_i_reg2)
		MODF_flag_reg <= 1'b1;
	end
	
always @(posedge clk_i or negedge rstn_i)
   begin : OVR_flag_proc
   if (~rstn_i)
      OVR_flag_reg <= 1'b0;
   else
		begin
		if (we_i & stb_i & ~TXE)
			OVR_flag_reg <= 1'b1; 
		if (~we_i & stb_i & OVR)
			OVR_flag_reg <= 1'b0;
		if (tx_end & RXNE)
			OVR_flag_reg <= 1'b1; 
		end
	end

always @(posedge clk_i or negedge rstn_i)
	begin : BSY_flag_proc
	if (~rstn_i)
		BSY_flag_reg <= 1'b0;
	else if (~SPE)
		BSY_flag_reg <= 1'b0;
	else if (tx_start)
		BSY_flag_reg <= 1'b1;	
	else if (tx_end)
		BSY_flag_reg <= 1'b0;	
	end

// -----------Bit counter for master mode----------------
always @(posedge clk_i or negedge rstn_i)
	begin : BitCnt_proc
	if (~rstn_i)
		bit_cnt_reg <= 4'b0;
	else if (~SPE)
		bit_cnt_reg <= 4'b0;
	else if (tx_start)
		bit_cnt_reg <= (DFF)?5'b1_0000:5'b0_1000;
	else if (shift_clk)
		bit_cnt_reg <= bit_cnt_reg - 1'b1;	
	end

// --------------clock divider for clk generation-------
always @(posedge clk_i or negedge rstn_i)
	begin : Dvd_Cnt_proc
	if (~rstn_i)
		dvd_cnt_reg <= 8'b0;
	else if (~(BSY & MSTR))
		dvd_cnt_reg <= 8'b0;
	else if (8'b0 == dvd_cnt_reg)
		case(BR)
			3'b000:dvd_cnt_reg <= 8'b0000_0000;
			3'b001:dvd_cnt_reg <= 8'b0000_0001;
			3'b010:dvd_cnt_reg <= 8'b0000_0010;
			3'b011:dvd_cnt_reg <= 8'b0000_0011;
			3'b100:dvd_cnt_reg <= 8'b0000_0100;
			3'b101:dvd_cnt_reg <= 8'b0000_0101;
			3'b110:dvd_cnt_reg <= 8'b0000_0110;
			3'b111:dvd_cnt_reg <= 8'b0000_0111;
		endcase
	else
		dvd_cnt_reg <= dvd_cnt_reg - 1'b1;
	end

always @(posedge clk_i or negedge rstn_i)
	begin : Clk_Dvd_proc
	if (~rstn_i)
		dvd_reg <= 1'b0;
	else if (~(BSY & MSTR))
		dvd_reg <= 1'b0;
   else if (8'b0 == dvd_cnt_reg)
		dvd_reg <= ~dvd_reg;
   end

assign dvd_zero = (8'b0 == dvd_cnt_reg)?1'b1:1'b0;
assign shift_clk = (MSTR)?(dvd_zero & dvd_reg & BSY_flag_reg & ~tx_start):(sck_i_reg1 & ~sck_i_reg2);
assign shift_clk_negedge = (MSTR)?(dvd_zero & ~dvd_reg & BSY_flag_reg):(~sck_i_reg1 & sck_i_reg2);

// -----------------Shift register--------------------
always @(posedge clk_i or negedge rstn_i)
	begin : Shift_proc
	if (~rstn_i)
		shift_reg <= 16'b0;
	else if ((tx_start) | (~MSTR & ~nss_i & ~TXE))
		shift_reg <= tx_buf_reg;					//load data
	else if (shift_clk)  //posedge
		shift_reg <= (DFF)?
							(LSBFIRST)?{shift_rx_data, shift_reg[15:1]}:{shift_reg[14:0], shift_rx_data}:
							(LSBFIRST)?{shift_rx_data, shift_reg[7:1]}:{shift_reg[6:0], shift_rx_data};
   end
	
// --------Hold time register--------------
always @(posedge clk_i or negedge rstn_i)
	begin : HldTim_proc
	if (~rstn_i)
		shift_negative_edge_reg <= 1'b0;
	else if (shift_clk_negedge | tx_start_reg1)
		shift_negative_edge_reg <= shift_negative_edge_nxt;
	end

assign shift_negative_edge_nxt = (CPHA)?((LSBFIRST)?shift_reg[0]:((DFF)?shift_reg[15]:shift_reg[7])):((MSTR)?miso_i:mosi_i);
assign shift_tx_data = (CPHA)?shift_negative_edge_reg:((LSBFIRST)?shift_reg[0]:((DFF)?shift_reg[15]:shift_reg[7]));
assign shift_rx_data = (CPHA)?((MSTR)?miso_i:mosi_i):shift_negative_edge_reg;

// --------------various pipeline flops---------
always @(posedge clk_i)
   begin : flops_proc
	nss_i_reg2 <= nss_i_reg1;		//synchronizers
	nss_i_reg1 <= nss_i;	
	sck_i_reg2 <= sck_i_reg1;		//synchronizers
	sck_i_reg1 <= sck_i ^ CPOL;

	tx_start_reg1 <= tx_start;
   end
//BSY + tx_delay = nss_o
reg nss_reg_flag;
always @(posedge clk_i or negedge rstn_i)
	begin : nss_reg_flag_proc
	if (~rstn_i)
		nss_reg_flag <= 1'b0;
	else if (~SPE)
		nss_reg_flag <= 1'b0;
	else if (tx_delay_start)
		nss_reg_flag <= 1'b1;	
	else if (tx_end)
		nss_reg_flag <= 1'b0;	
	end
	
assign nss_o = ~nss_reg_flag;
assign sck_o = (MSTR)?(BSY & dvd_reg) ^ CPOL:1'bz;
assign mosi_o = (MSTR & BSY)?shift_tx_data:1'bz;
assign miso_o = ~(MSTR | nss_i)?shift_tx_data:1'bz;
assign ch_sel_wd = (DFF)?(bit_cnt_reg >5'b0_0100 && bit_cnt_reg < 5'b1_0000):(bit_cnt_reg >5'b0_0100 && bit_cnt_reg < 5'b0_1000);
endmodule
