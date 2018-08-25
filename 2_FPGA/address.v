//reg area: address 0~63
 //SYS
`define	ADDR_TYP_VER				8'b0000_0000   //type and version
`define	ADDR_CTRL					8'b0000_0001
`define	ADDR_STATUS					8'b0000_0010
`define	ADDR_PERIODL				8'b0000_0011
`define	ADDR_PERIODH_DUTY			8'b0000_0100
`define	ADDR_NSAMP					8'b0000_0101
`define  ADDR_RISING_TIM			8'b0000_0110
`define	ADDR_ERROR					8'b0000_0111
`define	ADDR_ERR_CHECK				8'b0000_1000
`define	ADDR_ERR_CNTLIM			8'b0000_1001
  //CCS
`define	ADDR_CCS_SPISET			8'b0000_1010
`define 	ADDR_CCS1_SPISTA			8'b0000_1011
`define 	ADDR_CCS2_SPISTA			8'b0000_1100
`define 	ADDR_CCS3_SPISTA			8'b0000_1101
`define 	ADDR_CCS4_SPISTA			8'b0000_1110
`define 	ADDR_CCS5_SPISTA			8'b0000_1111
`define 	ADDR_CCS6_SPISTA			8'b0001_0000
`define	ADDR_CCS_DACSET			8'b0001_0001	//
`define  ADDR_CCS_DACOFFSET		8'b0001_0010
`define  ADDR_CCS_ADCRV				8'b0001_0011
`define  ADDR_CCS_ADCMV				8'b0001_0100
`define	ADDR_CCS_MINADC			8'b0001_0101
`define	ADDR_CCS_MAXADC			8'b0001_0110
`define  ADDR_CCS_PREERRCD			8'b0001_0111
`define 	ADDR_CCS_SAMPERRCD  		8'b0001_1000
 //OPP
`define  ADDR_OPP_SPISTA			8'b0001_1001
`define  ADDR_OPP_AD0				8'b0001_1010
`define  ADDR_OPP_AD1				8'b0001_1011
`define  ADDR_OPP_MINADC			8'b0001_1100
`define  ADDR_OPP_MAXADC			8'b0001_1101
`define  ADDR_OPP_PWLMT				8'b0001_1110
`define  ADDR_OPP_ERRCD				8'b0001_1111

 //ANG
`define  ADDR_ANG_SPISET			8'b0010_0000
`define  ADDR_ANG_SPISTA			8'b0010_0001
`define  ADDR_ANG_SPIDATA			8'b0010_0010
`define  ADDR_ANG_DACSET			8'b0010_0011
`define  ADDR_ANG_FRAMDACSET		8'b0010_0100
`define  ADDR_ANG_MINADC			8'b0010_0101
`define  ADDR_ANG_MAXADC			8'b0010_0110
`define  ADDR_ANG_THCHG_NSAMP		8'b0010_0111
`define  ADDR_ANG_KAD				8'b0010_1000

//water meter
`define  ADDR_WMT_DATA				8'b0010_1001				
`define	ADDR_WMT_PDCTMAX			8'b0010_1010 
`define  ADDR_WMT_PDCTMIN			8'b0010_1011  //43
//IDLE CCS adc
`define  ADDR_IDLE_ADC				8'b0010_1100  
//total power protection /* modify 2018.1.9
`define  ADDR_TLPW_THD		      8'b0010_1101  //45
`define  ADDR_TLPWERR_CNTLIM	   8'b0010_1110  //46
//total current to minimum and medium bk opp
`define  ADDR_IOPP_CNTLIM			8'b0010_1111 
`define  ADDR_TLCUR_MINJUDGE		8'b0011_0000  //48
`define  ADDR_TLCUR_MEDJUDGE		8'b0011_0001  
`define  ADDR_BKOPP_MINTHD			8'b0011_0010  
`define  ADDR_BKOPP_MEDTHD			8'b0011_0011  
//total current to integrate opp protection
`define  ADDR_INTEGOPP_K			8'b0011_0100  //52   //K*256
`define  ADDR_INTEGOPP_B			8'b0011_0101  //53	//B*256
//test 								
`define  ADDR_OVERLMT_COUNT		8'b0011_0110  //54
`define  ADDR_IO_STA					8'b0011_0111  //55
//  modify 2018.1.9*/						

//ccs way num
`define	LASER_CHANNEL_NUM			8'd2
//data area: address 46~255
`define  FRAM_DATA_MAXNUM			8'd25   //modify 2018.1.9   	
`define 	FRAM_IDATA_NUM				8'd23	  //modify 2018.1.9   
`define  FRAM_VMDATA_NUM			8'd2
`define  FRAM_ARRAY_NUM				8'd1			
 	 
 //I data(1~n), n<=6 56~205
`define  CCYC_STEP0_NUM				(`FRAM_IDATA_NUM - 1'b1)
`define  CCYC_STEP1_NUM				(`FRAM_IDATA_NUM + `FRAM_VMDATA_NUM - 1'b1)
`define 	ADDR_IDATA_START			8'd56  //modify 2018.1.9   
`define 	ADDR_IDATA_WAY0			`ADDR_IDATA_START
`define 	ADDR_IDATA_WAY1			(`ADDR_IDATA_START + `FRAM_DATA_MAXNUM)
`define 	ADDR_IDATA_WAY2			(`ADDR_IDATA_WAY1  + `FRAM_DATA_MAXNUM)
`define 	ADDR_IDATA_WAY3			(`ADDR_IDATA_WAY2  + `FRAM_DATA_MAXNUM)
`define 	ADDR_IDATA_WAY4			(`ADDR_IDATA_WAY3  + `FRAM_DATA_MAXNUM)
`define 	ADDR_IDATA_WAY5			(`ADDR_IDATA_WAY4  + `FRAM_DATA_MAXNUM)
`define 	ADDR_IDATA_END				(`ADDR_IDATA_WAY5  + `FRAM_DATA_MAXNUM - 1'b1)
 //optic power(n=2) 206~255
`define 	ADDR_PHDATA_START			(`ADDR_IDATA_END + 1'b1)
`define  ADDR_PHDATA_AD0			`ADDR_PHDATA_START
`define  ADDR_PHDATA_AD1			(`ADDR_PHDATA_AD0 + `FRAM_DATA_MAXNUM)
`define  ADDR_PHDATA_END			(`ADDR_PHDATA_AD1 + `FRAM_DATA_MAXNUM - 1'b1)
`define  ADDR_LAST_PHDATA			(`ADDR_PHDATA_START + `FRAM_ARRAY_NUM*(`FRAM_IDATA_NUM + `FRAM_VMDATA_NUM) - 1'b1)	//opp ad0 data end 		

 //offset address in spi
`define  OFFSET_SPI_DATA			2'b00
`define  OFFSET_SPI_CTRL			2'b01
`define	OFFSET_SPI_STATUS			2'b10

//bak and integrate opp
//`define  OPPMAX_TWIDTH				16'd1024   //1us 
//WMT
`define  WMT_PDCOUNT_MAX			16'd25000      //40Hz
`define  WMT_PDCOUNT_MIN			16'd200		   //5KHz
`define  ANG_KAD_MIN					11'd921			//0.9*1024
`define  ANG_KAD_MAX					11'd1127       //1.1*1024
`define 	ANG_OVER_THD            8'd168         //ang overmax flag threshold,input ang overmax 0.05
//IDLE ADC MAX
`define  IDLE_CCSADC_MAX			12'd250			//1A
//DAC has set threshold for iog dectect enable 
`define  DAC_JUDSET_MIN				12'd250

	
