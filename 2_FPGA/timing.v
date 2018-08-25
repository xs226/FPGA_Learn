//  Register Definition:
//  Addr Name        R/W  Description
//   0   TYPE_VER    R	  Type and version Register
//								  [15:13]= Type 
//								  [12:2]= optic power(*100W)
//								  [1:0] = Version
//   1   CTRL        R/W  Control Register
//                        [15]=RESVERED
//								  [14]= fpga_led_ctl					//modify 2018.1.9
//											1: led on and off,period 2s
//											0: no contrl,if fpga error,led off
//								  [13]=STM32_ERROR set bit
//											1:stm32 error state
//											0:stm32 ok
//								  [12:11]=SAMP_MD(Sample mode contrl)
//											00:passive sample,only by stm32
//											01:active sample in laser on stable status
//											10:active sample all time,except write dac  									
//											11:reserved
//								  [10]=RED_LGT(red indicator contrl)
//											0: off
//											1: on
//								  [9]=CCS_RD (Current output ready)
//                                  0: Cancel.
//                                  1: Ready.
//                        [8]=MPOWER_EN (main power contrl)
//						                  0: OFF.
//                                  1: ON.
//								  [7:4]=RESERVED
//								  [3]=FIELD_SEL
//												0: LOCAL
//												1: REMOTE
//								  [2:1]=MODE SEL
//                                  00: DC. 
//                                  01: EX_MODULATE.
//												10: AD.
//												11: IN_MODULATE.
//								  [0]=WMT_EN (Water meter detect contrl)
//                                  0: Off.
//                                  1: On.   
//   2   STATUS     	 R   Status register
//								  [15]=ERROR_STA
//								  [14]=WARN_STA
//                        [13]=LGTOUT_STA
//								  [12]=LGTOUT_RD_STA
//								  [11]=IDLE_STA
//                        [10]=REM_START_STA
//                        [9]= ANG_LGTEN_STA 	//modify 2018.1.9
//                        [8]= REDLGT_REQ_STA	//modify 2018.1.9
//								  [7]= CONFIG_OK_STA	   //modify 2018.1.9
								  //event happened flag,write status reg bit,bit flag will be cleared
//								  [6:5]=RESERVED_EV
//                        [4]=ERROR_EV
//                        [3]=WARN_EV		 
//                        [2]=REM_START_EV	 
//                        [1]=REM_LGTEN_EV     //modify 2018.1.9
//                        [0]=reserved	 		  //modify 2018.1.9
//   3   PERIODL      R/W  Period Register	 //raycus use
//                        [15:0]=PERIOD_COUNTL
//                               
//   4   PERIODH&DUTY R/W Period & Duty Register	//raycus use
//								  [15:12]=RESVERED
//								  [11:7]=PERIOD_COUNTH
//                        [6:0]=DUTY
//                              DUTY:0(0%)~100(100%)
//   5   NSAMP        R/W  Sample Number Control register
//								  [15:8]=RESERVED
//								  [7:4] =FRAM_DUMMY (invalid samp data num)
//                                  DUMMY:0~15
//                        [3:0]=FRAM_CONVERT (Convert cycle control)
//                                  CONVERT:0~10
//                                  Cc = (2 ^ CONVERT) cycle(2.125us)
//	  6 	RISING_TIM	 R/W  OPP and CCS rising time 
//								  [15:6]=CCS rising time T=RISING_TIM[15:6]*5us     
//								  [5:0] =OPP rising time T=RINGG_TIM[5:0]*5us
//   7   ERROR    	 R   Error and warn register
//                        [15]=MPIOG_ERR
//                        [14]=QBHLOCK_ERR
//                        [13]=KEYLOCK_ERR
//                        [12]=IOPP_INTEGLOW_ERR		//integrate optic power low 50% //modify 2018.1.9
//                        [11]=OPP_LIM_ERR				//comparator overlimit
//								  [10]=OPP_FLICK_ERR     		//flicker comparator error
//								  [9]=CCS_LIM_ERR					//comparator overlimit
//                        [8]=WMT_ERR						//frequcy and duty 
//                        [7]=IDLE_CCS_ERR				//error ccs in idle state
//								  [6]=TOTAL_POWER_ERR			//total power overlimit
//								  [5]=IOPP_BKLOW_ERR				//back optic power less than the threshold //modify 2018.1.9
//                        [4]=ANGIN_LIM_WARN				
//                        [3]=OPP_SAMP_WARN				//OPP max/min/presamp warn  
//								  [2]=CCS_MAXSAMP_WARN
//                        [1]=CCS_MINSAMP_WARN
//								  [0]=CCS_PRESAMP_WARN
//										0: no
//										1: error happened
//   8  CHECK			R/W  Error and warn check register
//                        [15]=MPIOG_ERR
//                        [14]=QBHLOCK_ERR
//                        [13]=KEYLOCK_ERR
//                        [12]=IOPP_INTEGLOW_ERR			//modify 2018.1.9
//                        [11]=OPP_LIM_ERR
//								  [10]=OPP_FLICK_ERR     		
//                        [9]=CCS_LIM_ERR
//                        [8]=WMT_ERR
//                        [7]=IDLE_CCS_ERR
//								  [6]=TOTAL_POWER_ERR			//total power overlimit
//								  [5]=IOPP_BKLOW_ERR				//less than the optic power threshold of set total current  //modify 2018.1.9
//                        [4]=ANGIN_LIM_WARN				
//                        [3]=OPP_SAMP_WARN				//OPP max/min/presamp warn  
//								  [2]=CCS_MAXSAMP_WARN
//                        [1]=CCS_MINSAMP_WARN
//								  [0]=CCS_PRESAMP_WARN
//										0: no
//										1: error happened
//   9  ERR_CNTLIM    R/W  AD data Error count limit register: count_limit = (2 ^ XXX_CNTLIM)
//                        [15:12]=OPP_SAMP_CNTLIM     //max 1024
//								  [11:8]=OPP_PRESAMP_CNTLIM   //max 1024
//								  [7:4]=CCS_SAMP_CNTLIM       //max 128
//                        [3:0]=CCS_PRESAMP_CNTLIM    //max 128
//CCS
//	 10 ADDR_CCS_SPISET R/W CCS spi contrl register
//	 11 ADDR_CCS1_SPISTA R  CCS1 spi status register
//	 12 ADDR_CCS2_SPISTA R  CCS2 spi status register
//	 13 ADDR_CCS3_SPISTA R  CCS3 spi status register
//	 14 ADDR_CCS4_SPISTA R  CCS4 spi status register
//	 15 ADDR_CCS5_SPISTA R  CCS5 spi status register
//	 16 ADDR_CCS6_SPISTA R  CCS6 spi status register
//	 17 ADDR_CCS_DACSET R/W CCS current dac register
//									[15]=RESERVED
//								 	[14:12]=CCS way number
//										0: all way
//										1~6: ccs way1~6:
//									[11:0]=current value
//	 18 ADDR_CCS_DACOFFSET R/W CCS offset current dac register
//									[15]=RESERVED
//								 	[14:12]=CCS way number
//										0: all way
//										1~6: ccs way1~6:
//									[11:0]=current value								
//  19 ADDR_CCS_ADCRV	R/W CCS Rsamp register address
//									[15]=RESERVED
//								 	[14:12]=CCS way number
//										0: all way
//										1~6: ccs way1~6:
//									[11:0]= write value  
//  20 ADDR_CCS_ADCMV	R/W CCS mosfet samp register address
//									[15]=RESERVED
//								 	[14:12]=CCS way number
//										0: all way
//										1~6: ccs way1~6:
//									[11:0]= write value 
//	 21 ADDR_CCS_MINADC R/W CCS current corresponding adc minimum limit value
//									[15]= CCS single way enable  ////modify 2018.1.9
//								 	[14:12]=CCS way number
//										0: all way
//										1~6: ccs way1~6
//									[11:0]= minimum limit adc value
//	 22 ADDR_CCS_MAXADC R/W CCS current corresponding adc maximum limit value
//									[15]=CCS single way enable
//								 	[14:12]=CCS way number
//										0~5: ccs way1~6
//									[11:0]= maximum limit adc value
//	 23 ADDR_CCS_PREERRCD	presamp threshold error code register
//								  [15:8]= nWay IDLE CCS adc error
//								  [7:0] = nWAY PRESAMP ERROR
//										0:normal
//										1:error	
//	 24 ADDR_CCS_SAMPERRCD	samp threshold error code register
//								  [15:8]= nWAY MAXSAMP ERROR
//								  [7:0] = nWAY MINSAMP ERROR
//										0:normal
//										1:error
	
//OPP
//	 25 ADDR_OPP_SPISTA R   OPP spi status register
//	 28 ADDR_OPP_MINADC R/W current corresponding OPP adc minimum limit value
//									[15:13]=RESERVED
//								 	[12]=OPP way number
//										0: OPP way0
//										1: OPP way1
//									[11:0]=current corresponding OPP adc minimum limit value
//	 29 ADDR_OPP_MAXADC R/W current corresponding OPP adc maximum limit value
//									[15:13]=EN
//								 	[12]=OPP way number
//										0: OPP way0
//										1: OPP way1
//									[11:0]=current corresponding OPP adc maximum limit value]
//  30 ADDR_OPP_PWLMT  R/W OPP comparator pulse judge limit
//									[15:6]=OPPH_COUNT_LMT:back and integate light comparator high ratio limit
//										 OPPH_COUNT_LMT:0~1023
//                              limit value = OPPH_COUNT_LMT*cycle(1us)
//									[5:0] = OPPF_COUNT_LMT:flicker light comparator high limit
//	 									  limit value = (0~63)*cycle(1us)
//	 31 ADDR_OPP_ERRCD  R  OPP samp threshold error code register
//								  [15:7]= RESVERED
//								  [8] = OPP HIGH COUNT ERROR
//								  [7] = RESERVED
//								  [6] = CH1 PRESAMP ERROR
//								  [5] = CH1 MAXSAMP ERROR
//								  [4] = CH1 MINSAMP ERROR
//								  [3] = RESVERED
//								  [2] = CH0 PRESAMP ERROR
//								  [1] = CH0 MAXSAMP ERROR
//								  [0] = CH0 MINSAMP ERROR
//										0:normal
//										1:error
//ANG
//	 32 ADDR_ANG_SPISET R/W ANG spi contrl register
//	 33 ADDR_ANG_SPISTA R   ANG spi status register
//  34 ADDR_ANG_SPIDATA 
//  35 ADDR_ANG_DACSET R   ANG spi samp set register
//			[15:12]=RESERVED
//			[11:0]=ANG samp set value
//  36 ADDR_ANG_FRAMDACSET	AD	mode,save the dacset value when frame produce
//			[15:12]=RESERVED
//			[11:0]=ANG samp set value,when frame produce
//	 37 ADDR_ANG_MINADC  analog corresponding ANG adc minimum limit value
//	 38 ADDR_ANG_MAXADC  analog corresponding ANG adc maximum limit value
//	 39 ADDR_ANG_THCHG_NSAMP analog ad change threshold and sample number
//			[15:8]=ad change threshold
//			[7:0]=sample number
//  40 ADDR_ANG_KAD analog ad adjust ratio
//			[15:11]=RESERVED
//			[10:0]=Kad = (0.9~1.1)*1024 
//WMT
//	 41 ADDR_WMT_DATA	 water meter period value
//	 42 ADDR_WMT_PDCTMAX water meter period count max limit
//  43 ADDR_WMT_PDCTMIN water meter period count min limit
//  /* //modify 2018.1.9
//	 44 ADDR_IDLE_ADC  ccs adc sample average value  
//			RD:	
//			[15]=RESERVED
//			[14:12]=CCS way number
//			0: way 1
//			1~6: ccs way1~6:
//			[11:0]= sample value 
//			//WR
// 		[11:0]= the max idle current threshold set value
//  45 ADDR_TLPW_THD total power threshold for non-linear protection
//			[15:0]= 6 way ccs max adc sum value
//  46 ADDR_TLPWERR_CNTLIM R/W  total power error count limit register
//			[15:8]  = RESERVED 
//			[7:0]   = 0~100 total current error count limit
//	 47  ADDR_IOPP_CNTLIM total current to optic power count limit
//			[15:8]  = 0~128 IOPP integate optic power
//			[7:0]   = 0~128 IOPP back optic power
//  48  ADDR_TLCUR_MINJUDGE IOPP total current judge (back optic power minimum) threshold
//			[15:0] = sum current sample value threshold
//  49  ADDR_TLCUR_MEDJUDGE IOPP total current judge (back optic power medium) threshold
//			[15:0] = sum current sample value threshold  
//	 50  ADDR_BKOPP_MINTHD the min back optic power threshold to total current
//  		[15:12]= RESERVED
//			[11:0] = the threshold value
//	 51  ADDR_BKOPP_MEDTHD the medium back optic power threshold to total current
//  		[15:12]= RESERVED
//			[11:0] = the threshold value
//	 52  ADDR_INTEGOPP_K integate optic power K   K=Ka*256
// 		[15]   = SIGNBIT sign bit of B, 1 negative,0 positive
//			[14:0] = K value  K <= 127 
//	 53  ADDR_INTEGOPP_B integate optic power K   B=Ba*256
//			[15:0] = B data value  Ba<=255
//  54 ADDR_OVERLMT_COUNT ioppinteg  and ioppbk error count 
// 		[15:8] = ioppinteg error count number
//			[7:0]  = ioppbk error count number 
//  55 ADDR_INPUT_STA input signal status for test
//			[15]= RESERVED
//			[14]= fsmc_irqdata_sta  
//			[13]= fsmc_irqfull_sta 
//			[12]= fsmc_irqchg_sta 
//			[11]= ang_lgten_sta  
//			[10]= rem_start_sta
//			[9] = wmt_sig_sta 
//			[8] = ccs_limerr_sta 
//			[7] = ccs_adchsel_sta 
//			[6] = opp_adchsel_sta
//			[5] = oppovlmt_sta 
//			[4] = flicker_sta 
//			[3] = qbhlock_sta 
//			[2] = keylock_sta 
//			[1] = modsw_sta 
//			[0] = iog_sta 
//modify 2018.1.9  */

`include "address.v"
//TYPE	0
`define  LASER_TYPE						16'h2051   //type 2 500W v1
//CTRL	1
`define	CTRL_END							14
`define	CTRL_START						0

`define  CTRL_LED_BIT					14
`define  CTRL_ERROR_BIT					13
`define	CTRL_SAMP_MD_END				12
`define	CTRL_SAMP_MD_START			11
`define  CTRL_REDLGT_BIT				10
`define	CTRL_CCS_RD_BIT				9
`define	CTRL_MPOWER_EN_BIT			8
`define	CTRL_FIELD_SEL_BIT			3
`define	CTRL_MODE_SEL_END				2
`define	CTRL_MODE_SEL_START			1
`define	CTRL_WMT_EN_BIT				0
//STATUS	2
`define 	STATUS_EV_END					4
`define	STATUS_EV_START				1

`define	STATUS_ERROR_STA_BIT			15
`define	STATUS_WARN_STA_BIT			14
`define	STATUS_LGTOUT_STA_BIT		13
`define	STATUS_LGTRD_STA_BIT			12
`define	STATUS_IDLE_STA_BIT			11
`define	STATUS_REMSTART_STA_BIT		10
`define  STATUS_LGTEN_STA_BIT			9
`define  STATUS_REDLGTREQ_STA_BIT	8
`define  STATUS_CONFIG_OK_STA_BIT   7
`define  STATUS_PLC_START_STA_BIT   6 //20180113 LXS
`define  STATUS_PLC_MODE_STA_BIT   	5 //20180113 LXS
`define	STATUS_ERROR_EV_BIT			4
`define	STATUS_WARN_EV_BIT			3
`define	STATUS_REMSTART_EV_BIT		2
`define	STATUS_LGTEN_EV_BIT			1
`define	STATUS_BAK_EV_BIT				0
//PERIODL 3
`define	PERIODL_END						15
`define	PERIODL_START					0
//PERIODH&DUTY 4
`define	PERIODH_DUTY_END				11
`define	PERIODH_DUTY_START			0

`define	PERIODH_COUNTH_END			11
`define	PERIODH_COUNTH_START			7
`define	DUTY_END							6
`define	DUTY_START						0
//NSAMP	5
`define	NSAMP_DUMMY_END				7
`define	NSAMP_START						0

`define	NSAMP_DUMMY_END				7
`define	NSAMP_DUMMY_START				4
`define	NSAMP_SAMP_END					3
`define	NSAMP_SAMP_START				0	
//FVD_TIM	6
`define	RISINGTIM_END					15
`define	RISINGTIM_START				0

`define	RISING_CCSTIM_END  			15
`define	RISING_CCSTIM_START			6
`define	RISING_OPPTIM_END				5
`define	RISING_OPPTIM_START			0
//ERROR	7
`define	ERROR_END						15
`define	ERROR_START						5
`define	WARN_END							4
`define	WARN_START						0

`define	ERROR_MPIOG_ERR_BIT			15
`define	ERROR_QBHLOCK_ERR_BIT		14
`define	ERROR_KEYLOCK_ERR_BIT		13
`define	ERROR_IOPPINTEG_ERR_BIT		12
`define	ERROR_OPPLIM_ERR_BIT			11
`define  ERROR_OPPFLIM_ERR_BIT		10
`define	ERROR_CCSLIM_ERR_BIT			9
`define	ERROR_WMT_ERR_BIT  			8
`define	ERROR_IDLECCS_ERR_BIT		7
`define  ERROR_TLPW_ERR_BIT			6
`define  ERROR_IOPPBK_ERR_BIT			5
`define	ERROR_ANGIN_WARN_BIT			4
`define	ERROR_OPPSAMP_WARN_BIT		3
`define	ERROR_CCSMAXSAMP_WARN_BIT	2
`define	ERROR_CCSMINSAMP_WARN_BIT	1
`define	ERROR_CCSPRESAMP_WARN_BIT	0

//CHECK	8
`define	CHECK_ERR_END					15
`define	CHECK_ERR_START				5
`define	CHECK_WARN_END					4
`define	CHECK_WARN_START				0

`define	CHECK_MPIOG_ERR_BIT			15
`define	CHECK_QBHLOCK_ERR_BIT		14
`define	CHECK_KEYLOCK_ERR_BIT		13
`define	CHECK_IOPPINTEG_ERR_BIT		12
`define	CHECK_OPPLIM_ERR_BIT			11
`define  CHECK_OPPFLIM_ERR_BIT		10
`define	CHECK_CCSLIM_ERR_BIT			9
`define	CHECK_WMT_ERR_BIT				8
`define	CHECK_IDLECCS_ERR_BIT		7
`define  CHECK_TLPW_ERR_BIT			6
`define  CHECK_IOPPBK_ERR_BIT			5
`define	CHECK_ANGIN_WARN_BIT			4
`define	CHECK_OPPSAMP_WARN_BIT		3
`define	CHECK_CCSMAXSAMP_WARN_BIT	2
`define	CHECK_CCSMINSAMP_WARN_BIT	1
`define	CHECK_CCSPRESAMP_WARN_BIT	0
//ERR_CNTLIM	9
`define	ERR_CNTLIM_END					15
`define	ERR_CNTLIM_START				0

`define	ERR_CNTLIM_OPPSAMP_END		15
`define	ERR_CNTLIM_OPPSAMP_START	12
`define	ERR_CNTLIM_OPPPRESAMP_END	11
`define	ERR_CNTLIM_OPPPRESAMP_START 8
`define	ERR_CNTLIM_CCSSAMP_END		 7
`define	ERR_CNTLIM_CCSSAMP_START	 4
`define	ERR_CNTLIM_CCSPRESAMP_END	 3
`define	ERR_CNTLIM_CCSPRESAMP_START 0
//CCS_SPI_DACSET	17
`define	CCS_SPI_DACSET_END			14
`define	CCS_SPI_DACSET_START			0

`define	CCS_SPI_DACWAY_END			14
`define	CCS_SPI_DACWAY_START			12
`define	CCS_SPI_DACVAL_END			11
`define	CCS_SPI_DACVAL_START			0
//CCS_PREERRCD 
`define  CCS_IDLEERR_END				15
`define  CCS_IDLEERR_START				8
`define	CCS_PREERRCD_END				7
`define	CCS_PREERRCD_START			0
//CCS_SAMPERRCD 
`define	CCS_SAMPMAXERRCD_END			15
`define	CCS_SAMPMAXERRCD_START		8
`define	CCS_SAMPMINERRCD_END			7
`define	CCS_SAMPMINERRCD_START		0
//OPP_PWLMT     
`define  OPPH_COUNT_END					15
`define 	OPPH_COUNT_START				6
`define  OPPF_COUNT_END					5
`define  OPPF_COUNT_START				0
//OPP_ERRCD		 
`define  OPP_ERRCD_HCOUNT_BIT			8
`define	OPP_ERRCD_PRESAMP1_BIT		6
`define	OPP_ERRCD_MAXSAMP1_BIT		5
`define	OPP_ERRCD_MINSAMP1_BIT		4
`define	OPP_ERRCD_PRESAMP0_BIT		2
`define	OPP_ERRCD_MAXSAMP0_BIT		1
`define	OPP_ERRCD_MINSAMP0_BIT		0
//ANG_THCHG_NSAMP	
`define  ANG_ADC_THCHG_END				15
`define  ANG_ADC_THCHG_START			8
`define  ANG_ADC_NSAMP_END				7
`define 	ANG_ADC_NSAMP_START			0
//ADDR_TLPWERR_CNTLIM
`define	ERR_CNTLIM_TLPW_END			7
`define	ERR_CNTLIM_TLPW_START		0
//48  ADDR_IOPP_CNTLIM
`define 	IOPPINTEG_ERRCNT_END			15
`define  IOPPINTEG_ERRCNT_START		8
`define 	IOPPBK_ERRCNT_END				7
`define  IOPPBK_ERRCNT_START			0
//49	ADDR_TLCUR_MINJUDGE
//51  ADDR_BKOPP_MINTHD
`define  IOPPBK_MIN_END					11
`define  IOPPBK_MIN_START				0
//52  ADDR_BKOPP_MEDTHD
`define  IOPPBK_MED_END					11
`define  IOPPBK_MED_START				0
//53  ADDR_INTEGOPP_K
`define  B_SIGN_BIT						15
`define  K_DATA_END						14
`define  K_DATA_START					0
//54 ADDR_OVERLMT_COUNT
`define	IOPPINTEG_ERRCOUNT_END		15
`define  IOPPINTEG_ERRCOUNT_START	8
`define 	IOPPBK_ERRCOUNT_END			7
`define 	IOPPBK_ERRCOUNT_START		0
//55 ADDR_IO_STA
`define  FSMC_IRQDATA_OSTA				14
`define  FSMC_IRQFULL_OSTA				13
`define  FSMC_IRQCHG_OSTA				12
`define  ANG_LGTEN_ISTA_BIT			11
`define  REM_START_ISTA_BIT			10
`define  WMT_SIG_ISTA_BIT				9
`define  CCS_LIMERR_ISTA_BIT			8
`define  CCS_ADCHSEL_OSTA_BIT			7
`define  OPP_ADCHSEL_OSTA_BIT			6
`define	OPPOVLMT_ISTA_BIT				5
`define	FLICKER_ISTA_BIT				4
`define  QBHLOCK_ISTA_BIT				3
`define  KEYLOCK_ISTA_BIT				2
`define	MODSW_ISTA_BIT					1
`define	IOG_ISTA_BIT					0

module timing(
	input		rstn_i,
	input		clk_in,  
//FSMC Input
	input		fsmc_csn,
	input		fsmc_nwr,
	input		fsmc_nrd,
	input		[7:0]  fsmc_addr,
	inout		[15:0] fsmc_db,
	output	fsmc_data_irq_o,
	output   fsmc_full_irq_o,
	output   fsmc_chg_irq_o,
//ex com 
	input		qbhlock_i,
	input		keylock_i,
	//input		interlock_i,
	//input		ang_lgten_i,	//modify 2018.1.9   
	input		rem_start_i,
	input		mod_sw_i,
	output	err_out_o,   
//main power contrl
	input		mpwr_iog_i,
	output	mpwr_en_o,
//water meter 
	//input		wmt_en_i,
	input		wmt_sig_i,
//OPP contrl
	output	opp_ad_ncs,
	output	opp_ad_sclk,
	//output	opp_ad_chsel,
	input		opp_ad_miso,
	input		opp_limerr1_i,
	//input		opp_limerr2_i, //modify 2018.1.9   
//ANG contrl
	output   ang_ad_ncs,
	output 	ang_ad_sclk,
	input		ang_ad_miso,
//CCS 
//CCS common signal
	//CCS common signal
	input		ccs_limerr1_i,
	input		ccs_limerr2_i,
	//output	ccs_ad_chsel,
	output	ccs_ad_chsel1,
	output	ccs_ad_chsel2, //add
	output	ccs_sw1_3_o,	//1-3 switch,modify to ccs1
	output	ccs_sw4_6_o,	//4-6 switch,modify to ccs2
	
	output	ccs1_sclk,		//way1
	output	ccs1_da_nsync,	//way1 dac
	output	ccs1_da_mosi,
	output	ccs1_ad_ncs,	//way1 adc
	input		ccs1_ad_miso,
	
	output	ccs2_sclk,		//way2
	output	ccs2_da_nsync,	//way2 dac
	output	ccs2_da_mosi,
	output	ccs2_ad_ncs,	//way2 adc
	input		ccs2_ad_miso,
	
//RED LASER LED
	input    red_laser_i,
//plc_start
	input    plc_start_i,
//plc_mode
	input    plc_mode_i,	
//LED
	//output	led_out,
	output led_out1,		   //modify
	output led_out2,			//modify
	output alarm_led
);
wire opp_ad_chsel,opp_limerr2_i,ang_lgten_i; //no use  //modify 2018.1.9  

//led
wire fpga_error_sta;
assign led_out1 = 1'b0;			//power on
assign led_out2 = LED_BLINK ? clk_2s : fpga_error_sta;  //work on,fpga error state off
assign alarm_led= error_sta; 
assign err_out_o  = ~status[`STATUS_LGTOUT_STA_BIT];
//*****************************------clk -------*********************************/
//clk
wire clk64_i;
//assign clk64_i = clk_in;
pll pll1(.inclk0(clk_in),.c0(clk64_i));
//clk_250ns
reg[7:0] count_250ns;
reg clk_250ns;
always @(posedge clk64_i or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		clk_250ns <= 1'b0;
		count_250ns <= 8'b0;
		end
	else if(count_250ns == 8'b0000_0111)
		begin
		clk_250ns <= ~clk_250ns;
		count_250ns <= 8'b0;
		end
	else
		count_250ns <= count_250ns + 1'b1;
	end 
//clk-1us
reg[7:0] count_1us;
reg clk_1us;
always @(posedge clk64_i or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		clk_1us <= 1'b0;
		count_1us <= 8'b0;
		end
	else if(count_1us == 8'b0001_1111)
		begin
		clk_1us <= ~clk_1us;
		count_1us <= 8'b0;
		end
	else
		count_1us <= count_1us + 1'b1;
	end
//clk-100us	
reg[7:0] count_100us;
reg clk_100us;
always @(posedge clk_1us or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		clk_100us <= 1'b0;
		count_100us <= 8'b0;
		end
	else if(count_100us == 8'd49)
		begin
		clk_100us <= ~clk_100us;
		count_100us <= 8'b0;
		end
	else
		count_100us <= count_100us + 1'b1;
	end

//clk-5ms	modify for iog
reg[7:0] count_5ms;
reg clk_5ms;
always @(posedge clk_100us or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		clk_5ms <= 1'b0;
		count_5ms <= 8'b0;
		end
	else if(count_5ms == 8'd24)
		begin
		clk_5ms <= ~clk_5ms;
		count_5ms <= 8'b0;
		end
	else
		count_5ms <= count_5ms + 1'b1;
	end
//clk for led blink
reg[15:0] count_2s;
reg clk_2s;
always @(posedge clk_5ms or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		clk_2s <= 1'b0;
		count_2s <= 16'b0;
		end
	else if(count_2s == 16'd199)
		begin
		clk_2s <= ~clk_2s;
		count_2s <= 16'b0;
		end
	else
		count_2s <= count_2s + 1'b1;
	end

//****************************------ fsmc interface------------************************************/
//-------------------Buffer Register--------------------
reg	[15:0] ctrl_reg;
reg   [15:0] status_ev_reg;
reg	[15:0] periodl_reg;
reg	[15:0] periodh_duty_reg;
reg	[15:0] nsamp_reg;
reg	[15:0] rising_tim_reg;
//error
reg	[15:0] err_check_reg;
reg	[15:0] err_cntlim_reg;
//ccs
reg	[15:0] ccs_minadc_reg[7:0];
reg	[15:0] ccs_maxadc_reg[7:0];
//opp
reg	[15:0] opp_minadc_reg[1:0];
reg	[15:0] opp_maxadc_reg[1:0];
reg	[15:0] opp_pwlmt_reg;
//ang
reg	[15:0] ang_spidata_buf_reg;
reg	[15:0] ang_minadc_reg;
reg	[15:0] ang_maxadc_reg;
reg   [15:0] ang_thchg_nsamp_reg;
//WMT
reg	[15:0] wmt_pdcount_max;
reg	[15:0] wmt_pdcount_min;
//
reg	[15:0] spi_data_i_buf_reg;
reg	[15:0] rx_buf_reg;
reg	[15:0] ang_frame_daset;
reg   [15:0] ANG_Kad_reg;
reg   [15:0] idle_current_value; 
//TLPW
reg	[15:0] total_power_limit;
reg   [15:0] tlpw_cntlim_reg;
//IOPP
reg   [15:0] iopp_cntlim_reg;
//IOPP BACK
reg	[15:0] ioppbk_iminthd_reg;
reg	[15:0] ioppbk_imedthd_reg;
reg	[15:0] ioppbk_oppminthd_reg;
reg	[15:0] ioppbk_oppmedthd_reg;
//IOPP INTEGRATE
reg	[15:0] ioppinteg_k_reg;
reg	[15:0] ioppinteg_b_reg;
//IOPP MAX ERROR COUNT 	
reg 	[15:0] iopp_maxerr_count_reg;
wire  [15:0] status;
wire	[15:0] error_code;
wire	[15:0] ccs_preerror_code;
wire	[15:0] ccs_samperror_code;
wire	[15:0] opp_error_code;
wire  [15:0] ang_spi_data;
wire  [15:0] ccs1_spi_data,ccs2_spi_data,ccs3_spi_data,ccs4_spi_data,ccs5_spi_data,ccs6_spi_data;
wire  [15:0] opp_spi_data;
wire  [15:0] wmt_period_data;
wire  [15:0] ccs1ram_q,ccs2ram_q,ccs3ram_q,ccs4ram_q,ccs5ram_q,ccs6ram_q,oppbak_ram_q,oppinteg_ram_q;
wire ccs1ram_rden,ccs2ram_rden,ccs3ram_rden,ccs4ram_rden,ccs5ram_rden,ccs6ram_rden,oppbakram_rden,oppintegram_rden;

wire 	error_sta;
wire 	warn_sta;
//input io status for test
reg[15:0]  io_sta;
always @(posedge clk_1us or negedge rstn_i)  
	begin 
	if (~rstn_i)
		io_sta <= 16'b0;
	else
		begin
		io_sta[15] 							<= 1'b0;
		io_sta[`FSMC_IRQDATA_OSTA]		<= fsmc_data_irq_o;
		io_sta[`FSMC_IRQFULL_OSTA]		<= fsmc_full_irq_o;
		io_sta[`FSMC_IRQCHG_OSTA]		<= fsmc_chg_irq_o;
		io_sta[`ANG_LGTEN_ISTA_BIT]	<= ang_lgten_i;
		io_sta[`REM_START_ISTA_BIT]	<= rem_start_i;
		io_sta[`WMT_SIG_ISTA_BIT]		<= wmt_sig_i;
		io_sta[`CCS_LIMERR_ISTA_BIT]  <= ccs_limerr_i;
		io_sta[`CCS_ADCHSEL_OSTA_BIT] <= ccs_ad_chsel1;
		io_sta[`OPP_ADCHSEL_OSTA_BIT]	<= opp_ad_chsel;
		io_sta[`OPPOVLMT_ISTA_BIT] 	<= opp_limerr1_i;
		io_sta[`FLICKER_ISTA_BIT]  	<= opp_limerr2_i;
		io_sta[`QBHLOCK_ISTA_BIT]  	<= qbhlock_i;
		io_sta[`KEYLOCK_ISTA_BIT]  	<= keylock_i;
		io_sta[`MODSW_ISTA_BIT]    	<= mod_sw_i;
		io_sta[`IOG_ISTA_BIT]  	   	<= mpwr_iog_i;
		end
	end


reg config_ok;
///*------------------fsmc read and write proceed------------------------
always @(posedge clk64_i or negedge rstn_i)
	begin : FSMC_Write_Read_proc
	if (~rstn_i)
		begin
		spi_data_i_buf_reg <= 16'h0000;
		ctrl_reg 			 <= 16'h0000;
		status_ev_reg		 <= 16'h0000;
		periodl_reg 		 <= 16'h0000;
		periodh_duty_reg 	 <= 16'h0000;
		nsamp_reg 			 <= 16'h0024;   //dummy 2,convert 16
		rising_tim_reg		 <= 16'h4b03;   //ccs rising 1.5ms;opp rising 3*5 = 15us
		err_check_reg	    <= 16'h0000;	 //屏蔽所有故障
		err_cntlim_reg 	 <= 16'h3333;   //连续采到8次，判定为故障
		ccs_minadc_reg[0]  <= 16'h8000;   //恒流源最小采样值为0
		ccs_minadc_reg[1]  <= 16'h8000;
		ccs_minadc_reg[2]  <= 16'h8000;
		ccs_minadc_reg[3]  <= 16'h8000;
		ccs_minadc_reg[4]  <= 16'h8000;
		ccs_minadc_reg[5]  <= 16'h8000;
		ccs_minadc_reg[6]  <= 16'h8000;
		ccs_minadc_reg[7]  <= 16'h8000;
		ccs_maxadc_reg[0]  <= 16'h8fff;	//恒流源最大采样值为0xfff
		ccs_maxadc_reg[1]  <= 16'h8fff;
		ccs_maxadc_reg[2]  <= 16'h8fff;
		ccs_maxadc_reg[3]  <= 16'h8fff;
		ccs_maxadc_reg[4]  <= 16'h8fff;
		ccs_maxadc_reg[5]  <= 16'h8fff;
		ccs_maxadc_reg[6]  <= 16'h8fff;
		ccs_maxadc_reg[7]  <= 16'h8fff;
		opp_minadc_reg[0]  <= 16'h8000;	//光采样最小采样值为0
		opp_minadc_reg[1]  <= 16'h8000;
		opp_maxadc_reg[0]  <= 16'h8fff;	//光采样最大采样值为0xfff
		opp_maxadc_reg[1]  <= 16'h8fff;
		opp_pwlmt_reg		 <= 16'ha008;  //bak and integrate lim 640us,flicker 8
		ang_spidata_buf_reg<= 16'h0000;
		ang_minadc_reg		 <= 16'h0000;  //AD输入信号最小值为0
		ang_maxadc_reg		 <= 16'h0fff;  //AD输入信号最大值为0xfff
		ang_thchg_nsamp_reg<= 16'h0204;  //AD改变阈值0X20，采样数2的四次方
		ANG_Kad_reg 		 <= 16'h0400;	//1024--Kad = 1
		wmt_pdcount_max	 <= `WMT_PDCOUNT_MAX;
		wmt_pdcount_min	 <= `WMT_PDCOUNT_MIN;
		idle_current_value	 <= 16'd250;//`IDLE_CCSADC_MAX;
		total_power_limit	 <= 16'h0fff;
		tlpw_cntlim_reg    <= 16'h0019;
		iopp_cntlim_reg 	 <= 16'h100a;
		ioppbk_iminthd_reg <= 16'h0100;
		ioppbk_imedthd_reg <= 16'h1000;
		ioppbk_oppminthd_reg <= 16'hffff;//16'h0100;          //if stm32 not init the reg,will report error
		ioppbk_oppmedthd_reg <= 16'hffff;//16'h1000;				//if stm32 not init the reg,will report error
		ioppinteg_k_reg		<= 16'h0100;
		ioppinteg_b_reg		<= 16'h0100;
		iopp_maxerr_count_reg<= 16'h0000;
		config_ok				<= 1'b0;
		end
	else if(~fsmc_csn & ~fsmc_nwr & fsmc_nrd)				//wr reg
		case(fsmc_addr)
			`ADDR_TYP_VER				:  begin if(fsmc_db == `LASER_TYPE) config_ok <= 1'b1; else config_ok <= config_ok; end
			`ADDR_CTRL					:	ctrl_reg <= fsmc_db;
			`ADDR_STATUS				:	status_ev_reg <= fsmc_db;  //for clear event flag
			`ADDR_PERIODL				:	periodl_reg <= fsmc_db;
			`ADDR_PERIODH_DUTY		: 	periodh_duty_reg <= fsmc_db;
			`ADDR_NSAMP					:	nsamp_reg <= fsmc_db;
			`ADDR_RISING_TIM			:	rising_tim_reg <= fsmc_db;
			`ADDR_ERR_CHECK			:	err_check_reg <= fsmc_db;
			`ADDR_ERR_CNTLIM			:	err_cntlim_reg <= fsmc_db;
			`ADDR_CCS_SPISET,`ADDR_CCS_DACSET,`ADDR_CCS_DACOFFSET,`ADDR_CCS_ADCRV,`ADDR_CCS_ADCMV,
			`ADDR_OPP_AD0,`ADDR_OPP_AD1:
												spi_data_i_buf_reg <= fsmc_db;			
			`ADDR_CCS_MINADC			:	ccs_minadc_reg[fsmc_db[14:12]] <= fsmc_db;
			`ADDR_CCS_MAXADC			:	ccs_maxadc_reg[fsmc_db[14:12]] <= fsmc_db;
			`ADDR_OPP_MINADC			:	opp_minadc_reg[fsmc_db[12]] <= fsmc_db;
			`ADDR_OPP_MAXADC			:	opp_maxadc_reg[fsmc_db[12]] <= fsmc_db;
			`ADDR_OPP_PWLMT			:  opp_pwlmt_reg <= fsmc_db;
			`ADDR_ANG_SPISET,`ADDR_ANG_SPIDATA
											:	ang_spidata_buf_reg <= fsmc_db;
			`ADDR_ANG_MINADC			:	ang_minadc_reg <= fsmc_db;
			`ADDR_ANG_MAXADC			:	ang_maxadc_reg <= fsmc_db;
			`ADDR_ANG_THCHG_NSAMP	:	ang_thchg_nsamp_reg <= fsmc_db;
			`ADDR_WMT_PDCTMAX			:  wmt_pdcount_max <= fsmc_db;
			`ADDR_WMT_PDCTMIN			:	wmt_pdcount_min <= fsmc_db;
			`ADDR_ANG_KAD				:  ANG_Kad_reg	<= fsmc_db;
			`ADDR_IDLE_ADC				:	idle_current_value <= fsmc_db;  //idle_current_value [14:12] save the way address
			`ADDR_TLPW_THD				:	total_power_limit  <= fsmc_db;
			`ADDR_TLPWERR_CNTLIM		:  tlpw_cntlim_reg	 <= fsmc_db;
			`ADDR_IOPP_CNTLIM			:	iopp_cntlim_reg	 <= fsmc_db;
			`ADDR_TLCUR_MINJUDGE		:	ioppbk_iminthd_reg <= fsmc_db;
			`ADDR_TLCUR_MEDJUDGE		:	ioppbk_imedthd_reg <= fsmc_db;
			`ADDR_BKOPP_MINTHD		:  ioppbk_oppminthd_reg <= fsmc_db;
			`ADDR_BKOPP_MEDTHD		:  ioppbk_oppmedthd_reg <= fsmc_db;
			`ADDR_INTEGOPP_K			:	ioppinteg_k_reg	 <= fsmc_db;
			`ADDR_INTEGOPP_B			:	ioppinteg_b_reg	 <= fsmc_db;
			`ADDR_OVERLMT_COUNT		:	iopp_maxerr_count_reg <= fsmc_db;
			default: ;
		endcase
	else if(~fsmc_csn& ~fsmc_nrd & fsmc_nwr)				//rd reg
		case(fsmc_addr)
			`ADDR_TYP_VER				:  rx_buf_reg <= `LASER_TYPE;
			`ADDR_CTRL					:	rx_buf_reg <= ctrl_reg;
			`ADDR_STATUS				:	rx_buf_reg <= status;
			`ADDR_PERIODL				:	rx_buf_reg <= periodl_reg;
			`ADDR_PERIODH_DUTY		:	rx_buf_reg <= periodh_duty_reg;
			`ADDR_NSAMP					:	rx_buf_reg <= nsamp_reg;
			`ADDR_RISING_TIM			:  rx_buf_reg <= rising_tim_reg;
			`ADDR_ERROR					:	rx_buf_reg <= error_code;
			`ADDR_ERR_CHECK			:	rx_buf_reg <= err_check_reg;
			`ADDR_ERR_CNTLIM			:	rx_buf_reg <= err_cntlim_reg;
			`ADDR_CCS_SPISET			:	rx_buf_reg <= ccs1_spi_data;
			`ADDR_CCS1_SPISTA			:	rx_buf_reg <= ccs1_spi_data;
			`ADDR_CCS2_SPISTA			:	rx_buf_reg <= ccs2_spi_data;
			`ADDR_CCS3_SPISTA			:	rx_buf_reg <= ccs3_spi_data;
			`ADDR_CCS4_SPISTA			:	rx_buf_reg <= ccs4_spi_data;
			`ADDR_CCS5_SPISTA			:	rx_buf_reg <= ccs5_spi_data;
			`ADDR_CCS6_SPISTA			:	rx_buf_reg <= ccs6_spi_data;
			`ADDR_CCS_ADCRV,`ADDR_CCS_ADCMV:
				case(spi_data_i_buf_reg[14:12])				//previous write save value
						3'b000:	rx_buf_reg <= ccs1_spi_data;   
						3'b001:	rx_buf_reg <= ccs1_spi_data;
						3'b010:	rx_buf_reg <= ccs2_spi_data;
						3'b011:	rx_buf_reg <= ccs3_spi_data;
						3'b100:	rx_buf_reg <= ccs4_spi_data;
						3'b101:	rx_buf_reg <= ccs5_spi_data;
						3'b110:	rx_buf_reg <= ccs6_spi_data;
						default: rx_buf_reg <= ccs1_spi_data;
					endcase
			`ADDR_OPP_AD0,`ADDR_OPP_AD1:
						rx_buf_reg <= opp_spi_data;
			`ADDR_CCS_PREERRCD		:	rx_buf_reg <= ccs_preerror_code;
			`ADDR_CCS_SAMPERRCD		:	rx_buf_reg <= ccs_samperror_code;
			`ADDR_OPP_SPISTA			:	rx_buf_reg <= opp_spi_data;
			`ADDR_OPP_MINADC			:  rx_buf_reg <= opp_minadc_reg[0];
			`ADDR_OPP_MAXADC			:	rx_buf_reg <= opp_maxadc_reg[0];
			`ADDR_OPP_ERRCD			:	rx_buf_reg <= opp_error_code;
			`ADDR_OPP_PWLMT			:	rx_buf_reg <= opp_pwlmt_reg;
			`ADDR_ANG_SPISET,`ADDR_ANG_SPISTA,`ADDR_ANG_SPIDATA:	
												rx_buf_reg <= ang_spi_data;
			`ADDR_ANG_DACSET			:	rx_buf_reg <= {4'b0,ang_da_data};			//change every ang da update
			`ADDR_ANG_FRAMDACSET		:  rx_buf_reg <= ang_frame_daset;   			//change when frame data produce
			`ADDR_ANG_MINADC			:	rx_buf_reg <= ang_minadc_reg;
			`ADDR_ANG_MAXADC			:	rx_buf_reg <= ang_maxadc_reg;
			`ADDR_ANG_THCHG_NSAMP	:	rx_buf_reg <= ang_thchg_nsamp_reg;
			`ADDR_WMT_DATA				:	rx_buf_reg <= wmt_period_data;
			`ADDR_WMT_PDCTMAX			:	rx_buf_reg <= wmt_pdcount_max;
			`ADDR_WMT_PDCTMIN			:	rx_buf_reg <= wmt_pdcount_min;
			`ADDR_ANG_KAD				:  rx_buf_reg <= {5'b0,ANG_Kad};
			`ADDR_IDLE_ADC				:
					case(idle_current_value[14:12])				//previous write save value
						3'b000:	rx_buf_reg <= idle_sampadc_av[0];   
						3'b001:	rx_buf_reg <= idle_sampadc_av[0];
						3'b010:	rx_buf_reg <= idle_sampadc_av[1];
						3'b011:	rx_buf_reg <= idle_sampadc_av[2];
						3'b100:	rx_buf_reg <= idle_sampadc_av[3];
						3'b101:	rx_buf_reg <= idle_sampadc_av[4];
						3'b110:	rx_buf_reg <= idle_sampadc_av[5];
						default: rx_buf_reg <= idle_sampadc_av[0];
					endcase
			
			`ADDR_TLPW_THD				:	rx_buf_reg <= total_power_limit;
			`ADDR_TLPWERR_CNTLIM		:  rx_buf_reg <= tlpw_cntlim_reg;
			`ADDR_IOPP_CNTLIM			:	rx_buf_reg <= iopp_cntlim_reg;
			`ADDR_TLCUR_MINJUDGE		:	rx_buf_reg <= ioppbk_iminthd_reg;
			`ADDR_TLCUR_MEDJUDGE		:	rx_buf_reg <=ioppbk_imedthd_reg;
			`ADDR_BKOPP_MINTHD		:  rx_buf_reg <=ioppbk_oppminthd_reg;
			`ADDR_BKOPP_MEDTHD		:  rx_buf_reg <=ioppbk_oppmedthd_reg;
			`ADDR_INTEGOPP_K			:	rx_buf_reg <=ioppinteg_k_reg;
			`ADDR_INTEGOPP_B			:	rx_buf_reg <=ioppinteg_b_reg;
			`ADDR_OVERLMT_COUNT		:	rx_buf_reg <= {ioppinteg_err_maxcount,ioppbk_err_maxcount};
			`ADDR_IO_STA				:	rx_buf_reg <= io_sta;
			default:
				begin
				if(ccs1ram_rden)	
					rx_buf_reg <= ccs1ram_q;
				else if(ccs2ram_rden)	
					rx_buf_reg <= ccs2ram_q;
				else if(ccs3ram_rden)	
					rx_buf_reg <= ccs3ram_q;
				else if(ccs4ram_rden)	
					rx_buf_reg <= ccs4ram_q;
				else if(ccs5ram_rden)	
					rx_buf_reg <= ccs5ram_q;
				else if(ccs6ram_rden)	
					rx_buf_reg <= ccs6ram_q;	
				else if(oppbakram_rden)
					rx_buf_reg <= oppbak_ram_q;
				else if(oppintegram_rden)
					rx_buf_reg <= oppinteg_ram_q;
				else
					rx_buf_reg <= {16'hz};
				end
			endcase		
   end

assign fsmc_db = (~fsmc_csn & ~fsmc_nrd & fsmc_nwr) ? rx_buf_reg : 16'hz;

//-----------Map the fsmc register-------------------------                            
//map the Control register
reg	SAMP_PASMOD,SAMP_SCNMOD,SAMP_CONTMOD;
wire	STM32_ERROR;
//wire	RED_LGT;
wire	CCS_RD;
wire	MPWR_EN;
wire	FIELD_SEL;
wire	[1:0] MOD_SEL;
wire	WMT_EN;
wire  SCN_MD;
wire  LED_BLINK;

assign SCN_MD		= SAMP_PASMOD  ? 1'b0 : 1'b1;
assign STM32_ERROR= ctrl_reg[`CTRL_ERROR_BIT];
//assign RED_LGT		= ctrl_reg[`CTRL_REDLGT_BIT];
assign CCS_RD		= ctrl_reg[`CTRL_CCS_RD_BIT];
assign MPWR_EN		= ctrl_reg[`CTRL_MPOWER_EN_BIT];
assign FIELD_SEL 	= ctrl_reg[`CTRL_FIELD_SEL_BIT];
assign MOD_SEL 	= ctrl_reg[`CTRL_MODE_SEL_END:`CTRL_MODE_SEL_START]; 
assign WMT_EN 		= ctrl_reg[`CTRL_WMT_EN_BIT];
assign LED_BLINK  = ctrl_reg[`CTRL_LED_BIT];

always @(posedge clk64_i or negedge rstn_i)
 begin:Samp_Mode_Select
 if(~rstn_i)
	begin SAMP_PASMOD <= 1'b1; SAMP_SCNMOD	<= 1'b0; SAMP_CONTMOD<= 1'b0; end
 else
	case(ctrl_reg[`CTRL_SAMP_MD_END:`CTRL_SAMP_MD_START])
		2'b00 :	begin SAMP_PASMOD <= 1'b1; SAMP_SCNMOD	<= 1'b0; SAMP_CONTMOD<= 1'b0; end
		2'b01 :	begin SAMP_PASMOD <= 1'b0; SAMP_SCNMOD	<= 1'b1; SAMP_CONTMOD<= 1'b0; end
		2'b10 :	begin SAMP_PASMOD <= 1'b0; SAMP_SCNMOD	<= 1'b0; SAMP_CONTMOD<= 1'b1; end
		default: 
			begin SAMP_PASMOD <= 1'b1; SAMP_SCNMOD	<= 1'b0; SAMP_CONTMOD<= 1'b0; end
	endcase
 end
//ADDR_PERIODH_DUTY
//ADDR_NSAMP
wire  [3:0] FRAM_DUMMY;
wire	[3:0] FRAM_CONVERT;
assign FRAM_DUMMY   = nsamp_reg[`NSAMP_DUMMY_END:`NSAMP_DUMMY_START];
assign FRAM_CONVERT = nsamp_reg[`NSAMP_SAMP_END :`NSAMP_SAMP_START];

reg[9:0] RISING_CCS_DELAY;
reg[5:0] RISING_OPP_DELAY;
always @(posedge clk64_i or negedge rstn_i)
 if(~rstn_i)
	begin
	RISING_CCS_DELAY <= 10'd0;
	RISING_OPP_DELAY <= 6'b0;
	end
 else
	begin
	RISING_CCS_DELAY <= rising_tim_reg[`RISING_CCSTIM_END:`RISING_CCSTIM_START];
	RISING_OPP_DELAY <= rising_tim_reg[`RISING_OPPTIM_END:`RISING_OPPTIM_START];
	end
//***************************----main power contrl-----------*************************/
parameter MPOWER_ON 	= 1'b1,
			 MPOWER_OFF = 1'b0;
assign mpwr_en_o = ((~MPWR_EN) | error_sta | (~config_ok)) ? MPOWER_OFF : MPOWER_ON;

//***************************----- water meter detect-----*************************/
/*//wmt_en_i input signal low disable,high enable
reg wmt_en_reg,wmt_en_regr;
always @(posedge clk_100us or negedge rstn_i)  
	begin 
	if (~rstn_i)
		begin
		wmt_en_reg  <= 1'b1;  
		wmt_en_regr <= 1'b1;
		end
	else
		begin
		wmt_en_reg  <= wmt_en_i;
		wmt_en_regr <= wmt_en_reg;
		end
	end

parameter WMTEN_COUNT_NUM = 8'd100,   
			 WMTEN_THD_NUM	= 8'd10,           
			 WMTEN_ON		= 1'b1,
			 WMTEN_OFF		= 1'b0;
			 
reg [7:0] count_wmten;
reg [7:0] count_wmten_h;
reg wmten_sta;
always @(posedge clk_100us or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		count_wmten <= 8'd0;
		count_wmten_h <= 8'd0;
		wmten_sta <= WMTEN_ON;
		end
	else if(count_wmten >= WMTEN_COUNT_NUM)
		begin
		count_wmten <= 8'd0;
		count_wmten_h <= 8'd0;
		if(count_wmten_h >= WMTEN_THD_NUM)
			wmten_sta <= WMTEN_ON;
		else
			wmten_sta <= WMTEN_OFF;
		end
	else
		begin
		count_wmten <= count_wmten + 1'b1;
		if(wmt_en_regr)
			count_wmten_h <= count_wmten_h + 1'b1;
		end
	end*/
wire wmt_err_flag;	
wmt_detect wmt_detect_inst(.rstn_i(rstn_i),.clk_1us(clk_1us),.wmt_en(WMT_EN),.wmt_sig(wmt_sig_i),.pdn1us_max(wmt_pdcount_max),.pdn1us_min(wmt_pdcount_min),
									.wmt_data(wmt_period_data),.wmt_err(wmt_err_flag));

//***************************-----produce swtich contrl -----*************************/
///*--------------calculate period and duty------------------------
//PERIOD = 50Hz~50KHz (1280000~1280 64M CLK)
//period_count_i = periodh | periodl   duty_ratio_i = (PERIOD*duty)/100
wire[20:0] period_count_i;
wire[6:0]  duty_ratio_i;
wire[27:0] duty_mult_result;
wire[27:0] duty_quotient;
wire  perioduty_update_req;
wire[6:0] remain;   //no use

assign period_count_i = {periodh_duty_reg[`PERIODH_COUNTH_END:`PERIODH_COUNTH_START],periodl_reg[`PERIODL_END:`PERIODL_START]};
assign duty_ratio_i	 = periodh_duty_reg[`DUTY_END:`DUTY_START];
assign perioduty_update_req = ((`ADDR_PERIODH_DUTY == fsmc_addr) & ~fsmc_csn & ~fsmc_nwr & fsmc_nrd) ? 1'b1 : 1'b0;

pwm_mult pwm_mult1(.dataa(period_count_i),.datab(duty_ratio_i),.result(duty_mult_result));
pwm_div 	pwm_div1(.denom(7'd100),.numer(duty_mult_result),.quotient(duty_quotient),.remain(remain));

reg[1:0]	 cal_duty_sta;
parameter
			 CAL_DUTY_IDLE 	= 2'b01,
			 CAL_DUTY_DELAY 	= 2'b10;
			 
reg[20:0] 	duty_count_reg;
reg[20:0] 	period_count_reg;
reg[2:0]		count_dutycal_delay;
		 		 	
always @(posedge clk64_i or negedge rstn_i)
	begin : Period_duty_write_detect
	if (~rstn_i)
		begin
		cal_duty_sta 	  <= CAL_DUTY_IDLE;
		duty_count_reg   <= 21'b0;
		period_count_reg <= 21'b0;
		count_dutycal_delay	<= 3'b0;
		end
	else
		case(cal_duty_sta)
			CAL_DUTY_IDLE:	
				if(perioduty_update_req)
					begin
					cal_duty_sta <= CAL_DUTY_DELAY;
					count_dutycal_delay <= 3'b100;
					end
				else
					cal_duty_sta <= CAL_DUTY_IDLE;
			CAL_DUTY_DELAY:
				if(count_dutycal_delay == 3'b0)
					begin
					duty_count_reg <= duty_quotient[20:0];
					period_count_reg <= period_count_i;
					cal_duty_sta <= CAL_DUTY_IDLE;
					end
				else
					count_dutycal_delay <= count_dutycal_delay - 1'b1;
			
			default:
					cal_duty_sta <= CAL_DUTY_IDLE;
		endcase
	end
	
wire[20:0] period_count;
wire[20:0] duty_count;
assign	period_count= period_count_reg;
assign	duty_count 	= duty_count_reg;

reg	 mod_in_reg,mod_in_regr;
wire   mod_in_j;
assign mod_in_j = mod_in_regr;
always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		mod_in_reg  <= 1'b0;
		mod_in_regr <= 1'b0;
		end
	else
		begin
		mod_in_reg  <= mod_sw_i;
		mod_in_regr <= mod_in_reg;
		end
	end

wire ccs_sw;
assign ccs_sw1_3_o = ~ccs_sw;
assign ccs_sw4_6_o = ~ccs_sw;		
wire ccs_sw_enable;
assign ccs_sw_enable = (~error_sta) & config_ok;  //fatal error close the sw
ccs_sw_ctl ccs_sw_ctl1(
		.rstn_i(rstn_i),
		.clk64_i(clk64_i),
		.mod_in_i(mod_in_j),
		.enable_i(ccs_sw_enable),			//1:on 0:off
		.mode_sel(MOD_SEL),					//00:DC 01:modulate 10:AD 11:raycus inner modulation(reserved for test)
		.CCS_RD(CCS_RD),						//lightout enable
		.period_count(period_count),
		.duty_count(duty_count),
	   .fpul_dep_delay(8'b0),				//first pulse depression delay
		//.ex_offset_sw(ccs_offsetsw_o), //no use,for second offset
		.ccs_sw(ccs_sw)
	);
	
/****************************-----analog contrl in ad mode-----***********************/
wire [1:0] ang_spi_addr;
wire [15:0]ang_spiset_data;
wire ang_spi_we,ang_spi_cyc,ang_spi_stb;
wire ang_spi_ack,ang_spi_irq;
wire ang_ad_mosi;
wire ang_adch_selwd;
 
spi ang_spi_inst1(
		.rstn_i(rstn_i),
		.clk_i(clk64_i),
		.addr_i(ang_spi_addr),    //spi reg offset address
		.data_i(ang_spiset_data),
	   .data_o(ang_spi_data),
		.we_i(ang_spi_we),
		.cyc_i(ang_spi_cyc),
		.stb_i(ang_spi_stb),
		.ack_o(ang_spi_ack),
		.nss_o(ang_ad_ncs),
	   .sck_o(ang_ad_sclk),
		.mosi_o(ang_ad_mosi),
		.miso_i(ang_ad_miso),
		.irq_o(ang_spi_irq),
		.ch_sel_wd(ang_adch_selwd)
	);

wire ang_samp_enable;
wire da_set_mod;
assign ang_samp_enable = da_set_mod & (~error_sta) & config_ok;
ang_spi_ctrl ang_spi_ctrl1(
		.rstn_i(rstn_i),
		.clk64_i(clk64_i),
		.samp_enable(ang_samp_enable),
		.csn_i(fsmc_csn),
		.wrn_i(fsmc_nwr),
		.rdn_i(fsmc_nrd),
		.fsmc_addr(fsmc_addr),
		.spi_data_i_buf(ang_spidata_buf_reg),
		.spi_we_o(ang_spi_we),
		.spi_cyc_o(ang_spi_cyc),
		.spi_stb_o(ang_spi_stb),
		//.spi_irq_o(),
		.spi_addr_o(ang_spi_addr),
		.spi_data_o(ang_spiset_data),
		.spi_ack_i(ang_spi_ack),
		.spi_irq_i(ang_spi_irq)
);

wire [7:0]ANG_ADC_THCHG;
wire [7:0]ANG_ADC_CONVERT;
assign ANG_ADC_THCHG   = ang_thchg_nsamp_reg[`ANG_ADC_THCHG_END:`ANG_ADC_THCHG_START];
assign ANG_ADC_CONVERT = ang_thchg_nsamp_reg[`ANG_ADC_NSAMP_END:`ANG_ADC_NSAMP_START];
reg  [10:0]	ANG_SAMP_NUM;
always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		ANG_SAMP_NUM <= 11'b0;
	else
		ANG_SAMP_NUM <= (11'b1 << ANG_ADC_CONVERT);
	end
	
parameter ANG_INIT   = 8'b0000_0001,
			 ANG_IDLE 	= 8'b0000_0010,
			 ANG_CALAV	= 8'b0000_0100,
			 ANG_CALDIFF= 8'b0000_1000,
			 ANG_COMP	= 8'b0001_0000,
			 ANG_MULT_DELAY = 8'b0010_0000,
			 ANG_DA_UPDATE	 = 8'b0100_0000;
			 
reg [7:0]  ang_current_state,ang_next_state;
reg [21:0] ang_data_sum;
reg [15:0] ang_data_av_reg;
reg [15:0] ang_av_diff;
reg [10:0] ang_count_samp;
reg		  ang_samp_valid;
reg [15:0] ang_ad_lastsave;
reg [11:0] ang_da_data;  //analog da value
reg  ang_da_update;      //analog da update
reg  ang_overmax_flag;
reg[3:0] count_ang_kdelay; //mult delay

wire[21:0] ang_data_av;
wire ang_diff_overlmted;
wire ang_group_finished;
wire ang_kdelay_finished;
wire ang_update_enable;
assign ang_update_enable = (CCS_RD & ang_samp_enable);
assign ang_data_av =  (ang_data_sum >> ANG_ADC_CONVERT);
assign ang_diff_overlmted = (ang_av_diff > ANG_ADC_THCHG) ? 1'b1 : 1'b0;
assign ang_group_finished = ((ang_current_state == ANG_CALAV) && (ang_count_samp == ANG_SAMP_NUM)) ? 1'b1 : 1'b0;
assign ang_kdelay_finished = (count_ang_kdelay == 4'b0) ? 1'b1 : 1'b0;
//adjust ratio
reg [10:0] ANG_Kad;
always @(rstn_i or ANG_Kad_reg)
	begin
	if(~rstn_i)
		ANG_Kad = 11'b0;
	else if( ANG_Kad_reg > `ANG_KAD_MAX)
		ANG_Kad = `ANG_KAD_MAX;
	else if(ANG_Kad_reg < `ANG_KAD_MIN)  
		ANG_Kad <= `ANG_KAD_MIN;
	else										
		ANG_Kad <= ANG_Kad_reg[10:0];
	end
wire [22:0] ang_modify_daset;
ang_kdaset_mult ang_kdaset_mult_inst(.dataa(ANG_Kad),.datab(ang_data_av_reg[11:0]),.result(ang_modify_daset));

//detect data out signal
reg  ang_datao_flagr;
wire ang_datao_posedge;
assign ang_datao_posedge = (ang_spi_irq & ~ang_datao_flagr);	
always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		ang_datao_flagr <= 1'b0;
	else
		ang_datao_flagr <= ang_spi_irq;
	end

//analog sample sta
always @(posedge clk64_i or negedge rstn_i)
	begin 
	if (~rstn_i)
		ang_current_state <= ANG_INIT;
	else
		ang_current_state <= ang_next_state;	
	end

always @(rstn_i or ang_update_enable or ang_current_state or ang_group_finished or ang_diff_overlmted or ang_kdelay_finished)
	begin
	if(~rstn_i | (~ang_update_enable))
		ang_next_state = ANG_INIT;
	else
		case(ang_current_state)
			ANG_INIT		: ang_next_state = ang_update_enable ? ANG_IDLE	: ANG_INIT;
			ANG_IDLE		: ang_next_state = ANG_CALAV;
			ANG_CALAV	: ang_next_state = ang_group_finished ? ANG_CALDIFF : ANG_CALAV;
			ANG_CALDIFF	: ang_next_state = ANG_COMP;
			ANG_COMP		: ang_next_state = ang_diff_overlmted ? ANG_MULT_DELAY : ANG_IDLE;
			ANG_MULT_DELAY : ang_next_state = ang_kdelay_finished ? ANG_DA_UPDATE : ANG_MULT_DELAY;
			ANG_DA_UPDATE  : ang_next_state = ANG_IDLE;
				default  : ang_next_state = ANG_IDLE;
		endcase
	end

always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		begin
		ang_count_samp  <= 11'd0;
		ang_data_sum	 <= 22'd0;
		ang_data_av_reg <= 16'd0;
		ang_av_diff		 <= 16'd0;
		ang_samp_valid  <= 1'b0;
		ang_ad_lastsave <= 16'd0;
		ang_da_update  <= 1'b0;
		ang_da_data	   <= 12'b0;
		count_ang_kdelay <= 4'b0010;
		ang_overmax_flag <= 1'b0;
		end
	else
		case(ang_current_state)
			ANG_INIT:
				begin
				ang_count_samp  <= 11'd0;
				ang_data_sum	 <= 22'd0;
				ang_data_av_reg <= 16'd0;
				ang_av_diff		 <= 16'd0;
				ang_samp_valid  <= 1'b0;
				ang_ad_lastsave <= 16'd0;
				ang_da_update  <= 1'b1;     //produce a clear da signal when enter or cancel AD mode
				ang_da_data	   <= 12'b0;
				count_ang_kdelay <= 4'b0010;
				ang_overmax_flag <= 1'b0;
				end
			ANG_IDLE:
				begin
				ang_count_samp  <= 11'd0;
				ang_data_sum	 <= 22'd0;
				ang_data_av_reg <= 16'd0;
				ang_av_diff		 <= 16'd0;
				ang_da_update  <= 1'b0;
				count_ang_kdelay <= 4'b0010;
				ang_overmax_flag <= 1'b0;
				end
			ANG_CALAV:
				if(ang_datao_posedge && (ang_count_samp  < ANG_SAMP_NUM))
					begin
					if(ang_samp_valid)
						begin
						ang_count_samp <= ang_count_samp + 1'b1;
						ang_data_sum <= ang_data_sum + ang_spi_data[15:4];
						end
					else
						ang_samp_valid <= 1'b1;
					end
			ANG_CALDIFF:
				begin
				ang_data_av_reg	<= ang_data_av[15:0];
				if(ang_data_av[15:0] >= ang_ad_lastsave)
					ang_av_diff	<= ang_data_av[15:0]- ang_ad_lastsave;
				else
					ang_av_diff	<= ang_ad_lastsave - ang_data_av[15:0];
				end
			ANG_COMP:
				begin
				count_ang_kdelay <= 4'b0010;
				if(ang_diff_overlmted)
					ang_ad_lastsave <= ang_data_av_reg;
				else
					ang_ad_lastsave <= ang_ad_lastsave;
				end
			ANG_MULT_DELAY:
				begin
				if(count_ang_kdelay > 4'b0)
					count_ang_kdelay <= count_ang_kdelay - 1'b1;
				else
					count_ang_kdelay <= count_ang_kdelay;
				end
			ANG_DA_UPDATE:
				begin
				ang_da_update  <= 1'b1;
				if(ang_modify_daset[21:10] > ang_maxadc_reg)
					begin
					ang_da_data	<= ang_maxadc_reg[11:0];
					if(ang_modify_daset[21:10] > (ang_maxadc_reg + `ANG_OVER_THD))
						ang_overmax_flag<= 1'b1; 
					end
				else if(ang_modify_daset[21:10] < ang_minadc_reg)
					ang_da_data <= 12'b0;
				else
					ang_da_data <= ang_modify_daset[21:10];
				end
			endcase
	end

//ang err judge
parameter ANG_COUNT_NUM = 8'd100,
			 ANGIN_ERR_NUM = 8'd40;

reg	[7:0]ang_samp_count;
reg   [7:0]ang_err_count;
reg	angin_warn_flag;
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		begin
		ang_samp_count <= 8'b0;
		ang_err_count  <= 8'b0;
		end
	else if(ang_current_state == ANG_COMP)
		begin
		if(ang_samp_count < ANG_COUNT_NUM )
			begin
			ang_samp_count <= ang_samp_count + 1'b1;
			if(ang_overmax_flag)
				ang_err_count  <= ang_err_count + 1'b1;
			end
		else
			begin
			ang_samp_count <= 8'b0;
			ang_err_count	<= 8'b0;
			if(ang_err_count >= ANGIN_ERR_NUM)
				angin_warn_flag <= 1'b1;
			else 
				angin_warn_flag <= 1'b0;
			end
		end
	end

always @(posedge cyc_frame_finished)
	ang_frame_daset <= ang_da_data;            //stm32 ad mode frame data -da set value 
	
//*******************************-----da contrl and sample cycle ----***********************/
parameter  CYC_INIT 			 = 10'b00_0000_0001,
			  CYC_IDLE 			 = 10'b00_0000_0010,
			  CYC_RISING_ADCH0 = 10'b00_0000_0100,
			  CYC_STABLE_ADCH0 = 10'b00_0000_1000,
			  CYC_GROUP_ADCH0  = 10'b00_0001_0000,
			  CYC_STABLE_ADCH1 = 10'b00_0010_0000,
			  CYC_GROUP_ADCH1  = 10'b00_0100_0000,
			  CYC_FRAME 		 = 10'b00_1000_0000;  

reg[9:0]  cyc_current_state,cyc_next_state; 
//spi_ctrl
wire samp_enable;
						  
//SPI Common ccs+opp
wire [6:0]spi_array_we;
wire [6:0]spi_array_cyc;
wire [6:0]spi_array_stb;
wire spi_datao_flag; 
wire [1:0]spi_array_addr;
wire [15:0]spi_array_dataout;
wire [6:0]spi_array_ack;
wire [6:0]spi_array_irq;
wire adc_frame_chnl;
wire scn_valid_flag;  
wire ccs_adda_sel;    //0:ad 1:da
wire [6:0]ch_sel_wd;
wire adch_sel_wd; 
assign adch_sel_wd = (&ch_sel_wd) & (~ccs_adda_sel);  //adc channel switch windows period
reg adch_sel_wdr,adch_sel_wdrr;
always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		adch_sel_wdr <= 1'b0;
		adch_sel_wdrr <= 1'b0;
		end
	else
		begin
		adch_sel_wdr <= adch_sel_wd;
		adch_sel_wdrr <= adch_sel_wdr;
		end
	end
wire adch_selwd_posedge;
assign adch_selwd_posedge = ~adch_sel_wdrr & adch_sel_wdr;  

wire spi_ccs1_nss,spi_ccs2_nss,spi_ccs3_nss,spi_ccs4_nss,spi_ccs5_nss,spi_ccs6_nss;
wire spi_opp_nss;
assign da_set_mod = (MOD_SEL == 2'b10) ? 1'b1 : 1'b0;   //0:fsmc mode 1:AD mode 
assign samp_enable = cyc_current_state == CYC_RISING_ADCH0 || cyc_current_state == CYC_STABLE_ADCH0 || cyc_current_state == CYC_STABLE_ADCH1 || idle_samp_current_sta == IDSAMP_SAMP;	
assign {ccs1_da_nsync,ccs2_da_nsync,ccs3_da_nsync,ccs4_da_nsync,ccs5_da_nsync,ccs6_da_nsync} 
			= ccs_adda_sel ? {spi_ccs1_nss,spi_ccs2_nss,spi_ccs3_nss,spi_ccs4_nss,spi_ccs5_nss,spi_ccs6_nss} : 6'b11_1111;
assign {ccs1_ad_ncs,ccs2_ad_ncs,ccs3_ad_ncs,ccs4_ad_ncs,ccs5_ad_ncs,ccs6_ad_ncs} 	
			= ccs_adda_sel ? 6'b11_1111 : {spi_ccs1_nss,spi_ccs2_nss,spi_ccs3_nss,spi_ccs4_nss,spi_ccs5_nss,spi_ccs6_nss};
assign opp_ad_ncs	= ccs_adda_sel ? 1'b1 : spi_opp_nss;
wire dac_has_setpower;

spi_ctrl spi_ctrl_inst(
		.rstn_i(rstn_i),
		.clk64_i(clk64_i),
		.da_set_mod(da_set_mod),
		.SCN_MD(SCN_MD),
		.samp_enable(samp_enable),
		.csn_i(fsmc_csn),
		.wrn_i(fsmc_nwr),
		.rdn_i(fsmc_nrd),
		.fsmc_addr(fsmc_addr),
		.spi_data_i_buf(spi_data_i_buf_reg),
		.ang_da_update_i(ang_da_update),
 		.ang_da_data_i(ang_da_data),
		.spi_we_o(spi_array_we),
		.spi_cyc_o(spi_array_cyc),
		.spi_stb_o(spi_array_stb),
		.spi_irq_o(spi_datao_flag),
		.spi_addr_o(spi_array_addr),
		.spi_data_o(spi_array_dataout),
		.spi_ack_i(spi_array_ack),
		.spi_irq_i(spi_array_irq),
		.adc_chnl(adc_frame_chnl),
		.scn_valid_flag(scn_valid_flag),
		.ccs_adda_sel(ccs_adda_sel),
		.dac_setpower_flag(dac_has_setpower)
		);

spi ccs1_spi_inst(
		.rstn_i(rstn_i),
		.clk_i(clk64_i),
		.addr_i(spi_array_addr),    //spi reg offset address
		.data_i(spi_array_dataout),
	   .data_o(ccs1_spi_data),
		.we_i(spi_array_we[0]),
		.cyc_i(spi_array_cyc[0]),
		.stb_i(spi_array_stb[0]),
		.ack_o(spi_array_ack[0]),
		.nss_o(spi_ccs1_nss),
	   .sck_o(ccs1_sclk),
		.mosi_o(ccs1_da_mosi),
		.miso_i(ccs1_ad_miso),
		.irq_o(spi_array_irq[0]),
		.ch_sel_wd(ch_sel_wd[0])
		);

spi ccs2_spi_inst(
		.rstn_i(rstn_i),
		.clk_i(clk64_i),
		.addr_i(spi_array_addr),    //spi reg offset address
		.data_i(spi_array_dataout),
	   .data_o(ccs2_spi_data),
		.we_i(spi_array_we[1]),
		.cyc_i(spi_array_cyc[1]),
		.stb_i(spi_array_stb[1]),
		.ack_o(spi_array_ack[1]),
		.nss_o(spi_ccs2_nss),
	   .sck_o(ccs2_sclk),
		.mosi_o(ccs2_da_mosi),
		.miso_i(ccs2_ad_miso),
		.irq_o(spi_array_irq[1]),
		.ch_sel_wd(ch_sel_wd[1])
	);

spi ccs3_spi_inst(
		.rstn_i(rstn_i),
		.clk_i(clk64_i),
		.addr_i(spi_array_addr),    //spi reg offset address
		.data_i(spi_array_dataout),
	   .data_o(ccs3_spi_data),
		.we_i(spi_array_we[2]),
		.cyc_i(spi_array_cyc[2]),
		.stb_i(spi_array_stb[2]),
		.ack_o(spi_array_ack[2]),
		.nss_o(spi_ccs3_nss),
	   .sck_o(ccs3_sclk),
		.mosi_o(ccs3_da_mosi),
		.miso_i(ccs3_ad_miso),
		.irq_o(spi_array_irq[2]),
		.ch_sel_wd(ch_sel_wd[2])
	);

spi ccs4_spi_inst(
		.rstn_i(rstn_i),
		.clk_i(clk64_i),
		.addr_i(spi_array_addr),    //spi reg offset address
		.data_i(spi_array_dataout),
	   .data_o(ccs4_spi_data),
		.we_i(spi_array_we[3]),
		.cyc_i(spi_array_cyc[3]),
		.stb_i(spi_array_stb[3]),
		.ack_o(spi_array_ack[3]),
		.nss_o(spi_ccs4_nss),
	   .sck_o(ccs4_sclk),
		.mosi_o(ccs4_da_mosi),
		.miso_i(ccs4_ad_miso),
		.irq_o(spi_array_irq[3]),
		.ch_sel_wd(ch_sel_wd[3])
	);

spi ccs5_spi_inst(
		.rstn_i(rstn_i),
		.clk_i(clk64_i),
		.addr_i(spi_array_addr),    //spi reg offset address
		.data_i(spi_array_dataout),
	   .data_o(ccs5_spi_data),
		.we_i(spi_array_we[4]),
		.cyc_i(spi_array_cyc[4]),
		.stb_i(spi_array_stb[4]),
		.ack_o(spi_array_ack[4]),
		.nss_o(spi_ccs5_nss),
	   .sck_o(ccs5_sclk),
		.mosi_o(ccs5_da_mosi),
		.miso_i(ccs5_ad_miso),
		.irq_o(spi_array_irq[4]),
		.ch_sel_wd(ch_sel_wd[4])
	);

spi ccs6_spi_inst(
		.rstn_i(rstn_i),
		.clk_i(clk64_i),
		.addr_i(spi_array_addr),    //spi reg offset address
		.data_i(spi_array_dataout),
	   .data_o(ccs6_spi_data),
		.we_i(spi_array_we[5]),
		.cyc_i(spi_array_cyc[5]),
		.stb_i(spi_array_stb[5]),
		.ack_o(spi_array_ack[5]),
		.nss_o(spi_ccs6_nss),
	   .sck_o(ccs6_sclk),
		.mosi_o(ccs6_da_mosi),
		.miso_i(ccs6_ad_miso),
		.irq_o(spi_array_irq[5]),
		.ch_sel_wd(ch_sel_wd[5])
	);

wire opp_mosi;   //no use
spi opp_spi_inst1(
		.rstn_i(rstn_i),
		.clk_i(clk64_i),
		.addr_i(spi_array_addr),    //spi reg offset address
		.data_i(spi_array_dataout),
	   .data_o(opp_spi_data),
		.we_i(spi_array_we[6]),
		.cyc_i(spi_array_cyc[6]),
		.stb_i(spi_array_stb[6]),
		.ack_o(spi_array_ack[6]),
		.nss_o(spi_opp_nss),
	   .sck_o(opp_ad_sclk),
		.mosi_o(opp_mosi),
		.miso_i(opp_ad_miso),
		.irq_o(spi_array_irq[6]),
		.ch_sel_wd(ch_sel_wd[6])
	);

//----------------CCS+OPP sample data frame cycle---------------------
reg		 cyc_step_ptr;				//0:step0 1:step1
reg		 cyc_ccsad_ptr;			//ccs ad ptr 0:ad0 1:ad1
reg		 cyc_oppad_ptr;			//opp ad ptr 0:ad0 1:ad1
wire		 cyc_oppdata_ptr;			//opp data ptr
assign    cyc_oppdata_ptr = 		1'b0; //modify
//assign    cyc_oppdata_ptr = (cyc_current_state == CYC_STABLE_ADCH0||cyc_current_state == CYC_STABLE_ADCH1 ) ? (~cyc_oppad_ptr) : 1'b0; 
reg		 cyc_risingsta_req;		//0:has entered in light out state 1:rising state request
reg[10:0] cyc_count_wad0,cyc_count_wad1; 
reg[5:0]	 cyc_count_gad;
reg[6:0]	 cyc_count_addr;
reg[5:0]	 cyc_count_frame;
reg[10:0] SAMP_NUM;					//sample number
reg	rising_oppdelay_finished;
reg   rising_ccsdelay_finished;
reg[3:0] dummy_str_count; 	
reg[3:0] dummy_rts_count;         //invalid data skip				
wire  cyc_group0_posedge,cyc_group1_posedge;
wire  cyc_group0_negedge,cyc_group1_negedge;
wire	cyc_risingad0_finished,cyc_wayad0_finished,cyc_groupad0_finished;
wire  cyc_wayad1_finished,cyc_groupad1_finished;
wire  cyc_frame_finished;
wire  dummy_rtsfinished_flag;
wire  dummy_strfinished_flag;

assign cyc_risingad0_finished = rising_oppdelay_finished && (cyc_current_state == CYC_RISING_ADCH0);   
assign cyc_wayad0_finished = (cyc_current_state == CYC_STABLE_ADCH0 && cyc_count_wad0 == SAMP_NUM) ? 1'b1 : 1'b0;
assign cyc_wayad1_finished = (cyc_current_state == CYC_STABLE_ADCH1 && cyc_count_wad1 == SAMP_NUM) ? 1'b1 : 1'b0;
assign cyc_groupad0_finished = (cyc_current_state == CYC_GROUP_ADCH0 && cyc_count_gad == `CCYC_STEP0_NUM) ? 1'b1 : 1'b0;
assign cyc_groupad1_finished = (cyc_current_state == CYC_GROUP_ADCH1 && cyc_count_gad == `CCYC_STEP1_NUM) ? 1'b1 : 1'b0;
assign cyc_frame_finished	  = (cyc_current_state == CYC_FRAME && cyc_count_frame == (`FRAM_ARRAY_NUM-1'b1)) ? 1'b1 : 1'b0;
assign cyc_group0_posedge = ~cyc_current_state[4] & cyc_next_state[4];
assign cyc_group1_posedge = ~cyc_current_state[6] & cyc_next_state[6];
assign cyc_group0_negedge = cyc_current_state[4]  & ~cyc_next_state[4];
assign cyc_group1_negedge = cyc_current_state[6]  & ~cyc_next_state[6];
assign dummy_rtsfinished_flag = (dummy_rts_count == 4'b0) ? 1'b1 : 1'b0;
assign dummy_strfinished_flag = (dummy_str_count == 4'b0) ? 1'b1 : 1'b0;
//frame data state
reg[3:0] frame_data_sta;
always @(posedge clk64_i or negedge rstn_i)
 if(~rstn_i)
	frame_data_sta = 4'b0000;
 else if(~status[`STATUS_LGTOUT_STA_BIT])
	frame_data_sta = 4'b0000; 			//no lightout
 else if(rising_ccsdelay_finished) 	//maybe >1ms
	begin
	if(cyc_count_wad0 == 1 || cyc_count_wad1 == 1)
		frame_data_sta = 4'b0011; //stable data
	end
 else if(rising_oppdelay_finished)
	begin
	if(cyc_count_wad0 == 1 || cyc_count_wad1 == 1)
		frame_data_sta = 4'b0010; //between opp rising and ccs rising time
	end
 else
	frame_data_sta = 4'b0001; //rising
//sample num		
always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		SAMP_NUM <= 11'b0;
	else
		SAMP_NUM <= (11'b1 << FRAM_CONVERT);
	end

//count the setup rising delay(OPP and CCS) 
parameter	DELAY_1US		=	10'd64,
				DELAY_5US		=  10'd320,
				DELAY_10US		=  10'd640;
parameter   FRAM_RTS_DUMMY	=  4'd2;

reg[9:0]	count_nus;
wire	delay_nus_finished;

always @(posedge clk64_i or negedge rstn_i)
	begin  
	if(~rstn_i)
		count_nus <= 10'd0;
	else
		if(~cyc_risingsta_req)
			if(delay_nus_finished)
				count_nus <= 10'd0;
			else
				count_nus <= count_nus + 1'b1;
		else
			count_nus <= 10'd0;
	end
	
assign delay_nus_finished = ((DELAY_5US - 1'b1) == count_nus);


reg[15:0]	count_rising_delay;
always @(posedge clk64_i or negedge rstn_i)
	begin  
	if(~rstn_i)	
		begin
		rising_oppdelay_finished <= 1'b0;
		rising_ccsdelay_finished <= 1'b0;
		count_rising_delay <= 16'b1;
		end
	else
		begin
		if(cyc_risingsta_req)   
			begin
			rising_oppdelay_finished <= 1'b0;
			rising_ccsdelay_finished <= 1'b0;
			count_rising_delay <= 16'b1;
			end
		else 
			begin
			if(delay_nus_finished)
				begin
				if(count_rising_delay < RISING_CCS_DELAY || count_rising_delay < RISING_OPP_DELAY)
					count_rising_delay 	<= count_rising_delay + 1'b1;
				if(count_rising_delay >= RISING_CCS_DELAY)
					rising_ccsdelay_finished <= 1'b1;
				if( count_rising_delay >= RISING_OPP_DELAY )
					rising_oppdelay_finished <= 1'b1;
				end
			else
				begin
				if(RISING_OPP_DELAY == 16'b0)
					rising_oppdelay_finished <= 1'b1;
				
				if(RISING_CCS_DELAY == 16'b0)	
					rising_ccsdelay_finished <= 1'b1;
				end
			end			
		end
	end

//detect data out signal
reg  spi_datao_flagr,spi_datao_flagrr;
wire spi_datao_posedge;
assign spi_datao_posedge = spi_datao_flagr & ~spi_datao_flagrr;	
always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		spi_datao_flagr  <= 1'b0;
		spi_datao_flagrr <= 1'b0;
		end
	else
		begin
		spi_datao_flagr  <= spi_datao_flag;
		spi_datao_flagrr <= spi_datao_flagr;
		end
	end
	
//data_full_negedge
reg  data_full_flag,data_full_flagr;
wire data_full_negedge;
assign data_full_negedge = data_full_flagr & ~data_full_flag;
always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		data_full_flagr <= 1'b0;
	else
		data_full_flagr <= data_full_flag;
	end

//sample cycle sta
always @(posedge clk64_i or negedge rstn_i)
	begin : CCS_OP_CYCLE_SEQ
	if (~rstn_i)
		cyc_current_state <= CYC_INIT;
	else
		cyc_current_state <= cyc_next_state;	
	end

always @(rstn_i or SAMP_PASMOD or SAMP_SCNMOD or SAMP_CONTMOD or cyc_next_state or cyc_current_state 
			or ccs_sw or data_full_negedge or cyc_step_ptr or cyc_risingsta_req or ang_da_update or da_set_mod
			or cyc_risingad0_finished or cyc_wayad0_finished or cyc_groupad0_finished  
			or cyc_wayad1_finished or cyc_groupad1_finished or cyc_frame_finished or error_sta or config_ok)
	begin
	if(~rstn_i | SAMP_PASMOD | data_full_negedge | (ang_da_update & da_set_mod) | error_sta | (~config_ok))
		cyc_next_state = CYC_INIT;
	else if(~ccs_sw & SAMP_SCNMOD)
		cyc_next_state = CYC_IDLE;
	else
		case(cyc_current_state)
			CYC_INIT		:	cyc_next_state = CYC_IDLE;
			CYC_IDLE		:  begin
								if(cyc_step_ptr)
									if(cyc_risingsta_req & SAMP_SCNMOD)
										cyc_next_state = CYC_RISING_ADCH0;
									else if(~cyc_risingsta_req & SAMP_SCNMOD)
										cyc_next_state = CYC_STABLE_ADCH1;
									else if(SAMP_CONTMOD)
										cyc_next_state <= CYC_STABLE_ADCH1;
									else 
										cyc_next_state = CYC_INIT;
								else
									if(cyc_risingsta_req & SAMP_SCNMOD)
										cyc_next_state = CYC_RISING_ADCH0;
									else if(~cyc_risingsta_req & SAMP_SCNMOD)
										cyc_next_state = CYC_STABLE_ADCH0;
									else if(SAMP_CONTMOD)
										cyc_next_state = CYC_STABLE_ADCH0;
									else 
										cyc_next_state = CYC_INIT;		
								end
			CYC_RISING_ADCH0:
								cyc_next_state = cyc_risingad0_finished ? (cyc_step_ptr ? CYC_STABLE_ADCH1:CYC_STABLE_ADCH0) : CYC_RISING_ADCH0;
			CYC_STABLE_ADCH0:	
								cyc_next_state = cyc_wayad0_finished ? CYC_GROUP_ADCH0 : CYC_STABLE_ADCH0;
			CYC_GROUP_ADCH0:
								cyc_next_state = cyc_groupad0_finished ? CYC_STABLE_ADCH1 : CYC_STABLE_ADCH0;
			CYC_STABLE_ADCH1:
								cyc_next_state = cyc_wayad1_finished ? CYC_GROUP_ADCH1 : CYC_STABLE_ADCH1;
			CYC_GROUP_ADCH1:
								cyc_next_state = cyc_groupad1_finished ? CYC_FRAME : CYC_STABLE_ADCH1;
			CYC_FRAME:
								cyc_next_state = cyc_frame_finished ? CYC_INIT : CYC_STABLE_ADCH0;
								
				default:  	cyc_next_state = CYC_INIT;
		endcase
	end

always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		begin
		cyc_count_wad0  <= 11'd0;
		cyc_count_wad1  <= 11'd0;
		cyc_count_gad  <= 6'd0;
		cyc_count_addr <= 7'd0;
		cyc_count_frame <= 6'd0;
		cyc_step_ptr  <= 1'b0;
		cyc_oppad_ptr <= 1'b0;
		cyc_ccsad_ptr <= 1'b0;
		cyc_risingsta_req <= 1'b1;
		dummy_rts_count <= 4'b10;
		dummy_str_count <= 4'b10;
		end
	else if((ang_da_update & da_set_mod) | SAMP_PASMOD)
		begin
		cyc_count_wad0 <= 11'd0;
		cyc_count_wad1 <= 11'd0;
		cyc_count_gad <= 6'd0;
		cyc_count_addr <= 7'd0;
		cyc_count_frame <= 6'd0;
		cyc_step_ptr <= 1'b0;
		cyc_ccsad_ptr <= 1'b0;
		cyc_risingsta_req <= 1'b1;
		dummy_rts_count <= FRAM_RTS_DUMMY;
		dummy_str_count <= FRAM_DUMMY;
		end
	else if(data_full_negedge)
		begin
		cyc_count_wad0 <= 11'd0;
		cyc_count_wad1 <= 11'd0;
		cyc_count_gad <= 6'd0;
		cyc_count_addr <= 7'd0;
		cyc_count_frame <= 6'd0;
		cyc_step_ptr <= 1'b0;
		cyc_ccsad_ptr <= 1'b0;
		dummy_rts_count <= FRAM_RTS_DUMMY;
		dummy_str_count <= FRAM_DUMMY;
		end
	else if(~ccs_sw & SAMP_SCNMOD)
		begin
		cyc_risingsta_req <= 1'b1;
		dummy_str_count <= FRAM_DUMMY;
		dummy_rts_count <= FRAM_RTS_DUMMY;
		cyc_ccsad_ptr <= 1'b0;
		//add 2017.11.29
		cyc_count_wad0 <= 11'd0;   
		cyc_count_wad1 <= 11'd0;
		end
	else
		case(cyc_current_state)
			CYC_INIT	:	
				begin
				cyc_count_wad0 <= 11'd0;
				cyc_count_wad1 <= 11'd0;
				cyc_count_gad  <= 6'd0;
				cyc_count_addr <= 7'd0;
				cyc_count_frame <= 6'd0;
				cyc_step_ptr  <= 1'b0;
				cyc_ccsad_ptr <= 1'b0;
				dummy_str_count <= FRAM_DUMMY;
				dummy_rts_count <= FRAM_RTS_DUMMY;
				end
			CYC_RISING_ADCH0:
				begin
				cyc_ccsad_ptr <= 1'b0;
				cyc_risingsta_req <= 1'b0;       
				if(spi_datao_posedge & (~dummy_strfinished_flag))
					dummy_str_count <= dummy_str_count - 1'b1;
				else 
					dummy_str_count <= dummy_str_count;
					
				if(adch_selwd_posedge)
					cyc_oppad_ptr <= ~cyc_oppad_ptr;
				else
					cyc_oppad_ptr <= cyc_oppad_ptr;
				end
			CYC_STABLE_ADCH0:
				begin
				cyc_step_ptr <= 1'b0;
				cyc_ccsad_ptr <= 1'b0;
				if(spi_datao_posedge && cyc_count_wad0 < SAMP_NUM)
					if(dummy_rtsfinished_flag)
						cyc_count_wad0 <= cyc_count_wad0 + 1'b1;
					else
						dummy_rts_count <= dummy_rts_count - 1'b1;
						
				if(adch_selwd_posedge)  
					cyc_oppad_ptr <= ~cyc_oppad_ptr;
				else
					cyc_oppad_ptr <= cyc_oppad_ptr;
				end
			CYC_GROUP_ADCH0:
				begin
				cyc_step_ptr <= 1'b0;
				cyc_ccsad_ptr <= 1'b0;
				cyc_count_wad0 <= 11'd0;
				cyc_count_gad <= cyc_count_gad + 1'b1;
				cyc_count_addr <= cyc_count_addr + 1'b1;
				if(cyc_count_gad == `CCYC_STEP0_NUM)     
					dummy_rts_count <= FRAM_RTS_DUMMY;
				end
			CYC_STABLE_ADCH1:
				begin
				cyc_step_ptr <= 1'b1;
				cyc_ccsad_ptr <= 1'b1;
				if(spi_datao_posedge && cyc_count_wad1 < SAMP_NUM)
					if(dummy_rtsfinished_flag)
						cyc_count_wad1 <= cyc_count_wad1 + 1'b1;
					else
						dummy_rts_count <= dummy_rts_count - 1'b1;
						
				if(adch_selwd_posedge)  
					cyc_oppad_ptr <= ~cyc_oppad_ptr;
				else
					cyc_oppad_ptr <= cyc_oppad_ptr;
				end
				
			CYC_GROUP_ADCH1:
				begin
				cyc_step_ptr <= 1'b1;
				cyc_ccsad_ptr <= 1'b1;
				cyc_count_wad1 <= 11'd0;
				cyc_count_gad <= cyc_count_gad + 1'b1;
				cyc_count_addr <= cyc_count_addr + 1'b1;
				end
			CYC_FRAME:
				begin
				cyc_count_wad0 <= 11'd0;
				cyc_count_wad1 <= 11'd0;
				cyc_count_gad <= 6'd0;
				cyc_step_ptr <= 1'b0;
				cyc_ccsad_ptr <= 1'b0;
				dummy_str_count <= FRAM_DUMMY;
				dummy_rts_count <= FRAM_RTS_DUMMY;
				cyc_count_addr <= cyc_count_addr + 1'b1;
				if(cyc_count_frame < `FRAM_ARRAY_NUM )
					cyc_count_frame <= cyc_count_frame + 1'b1;	
				end
			endcase
	end
//samp channel select
//assign ccs_ad_chsel = SCN_MD ? cyc_ccsad_ptr : adc_frame_chnl;
assign ccs_ad_chsel1 = SCN_MD ? cyc_ccsad_ptr : adc_frame_chnl;   //modify
assign ccs_ad_chsel2 = SCN_MD ? cyc_ccsad_ptr : adc_frame_chnl;   //modify
//assign opp_ad_chsel = SCN_MD ? cyc_oppad_ptr : adc_frame_chnl;
assign opp_ad_chsel = 1'b0;  //modify,sample opp ad0

//**************************---dual ram read and write------******************************/
//ram instance:ccs 6 ways,opp 1 way
wire[6:0]  ccs1ram_rdaddress,ccs2ram_rdaddress,ccs3ram_rdaddress,ccs4ram_rdaddress,ccs5ram_rdaddress,ccs6ram_rdaddress;
wire[6:0]  oppbakram_rdaddress,oppintegram_rdaddress;
wire 		  ccs1ram_rdaddr_err,ccs2ram_rdaddr_err,ccs3ram_rdaddr_err, ccs4ram_rdaddr_err,ccs5ram_rdaddr_err,ccs6ram_rdaddr_err,oppbakram_rdaddr_err,oppintegram_rdaddr_err;
wire[6:0]  ccs1ram_wraddress,ccs2ram_wraddress,ccs3ram_wraddress,ccs4ram_wraddress,ccs5ram_wraddress,ccs6ram_wraddress;
wire[6:0]  oppbakram_wraddress,oppintegram_wraddress;
reg[15:0]  ccs1ram_data,ccs2ram_data,ccs3ram_data,ccs4ram_data,ccs5ram_data,ccs6ram_data;
reg[15:0]  oppbakram_data,oppintegram_data;

wire ccs1ram_wren,ccs2ram_wren,ccs3ram_wren,ccs4ram_wren,ccs5ram_wren,ccs6ram_wren,oppbakram_wren,oppintegram_wren;

assign ccs1ram_rden = (~fsmc_csn& ~fsmc_nrd & fsmc_nwr) && (fsmc_addr >= `ADDR_IDATA_WAY0)
							&& (fsmc_addr < `ADDR_IDATA_WAY1) && (~ccs1ram_rdaddr_err);
assign ccs2ram_rden = (~fsmc_csn& ~fsmc_nrd & fsmc_nwr) && (fsmc_addr >= `ADDR_IDATA_WAY1) 
							&& (fsmc_addr < `ADDR_IDATA_WAY2) && (~ccs2ram_rdaddr_err);
assign ccs3ram_rden = (~fsmc_csn& ~fsmc_nrd & fsmc_nwr) && (fsmc_addr >= `ADDR_IDATA_WAY2) 
							&& (fsmc_addr < `ADDR_IDATA_WAY3) && (~ccs3ram_rdaddr_err);
assign ccs4ram_rden = (~fsmc_csn& ~fsmc_nrd & fsmc_nwr) && (fsmc_addr >= `ADDR_IDATA_WAY3) 
							&& (fsmc_addr < `ADDR_IDATA_WAY4) && (~ccs4ram_rdaddr_err);
assign ccs5ram_rden = (~fsmc_csn& ~fsmc_nrd & fsmc_nwr) && (fsmc_addr >= `ADDR_IDATA_WAY4) 
							&& (fsmc_addr < `ADDR_IDATA_WAY5) && (~ccs5ram_rdaddr_err);
assign ccs6ram_rden = (~fsmc_csn& ~fsmc_nrd & fsmc_nwr) && (fsmc_addr >= `ADDR_IDATA_WAY5) 
							&& (fsmc_addr <= `ADDR_IDATA_END) && (~ccs6ram_rdaddr_err);							
assign oppbakram_rden = (~fsmc_csn& ~fsmc_nrd & fsmc_nwr) && (fsmc_addr >= `ADDR_PHDATA_AD0)  
							&& (fsmc_addr < `ADDR_PHDATA_AD1) && (~oppbakram_rdaddr_err);
assign oppintegram_rden = (~fsmc_csn& ~fsmc_nrd & fsmc_nwr) && (fsmc_addr >= `ADDR_PHDATA_AD1)  
							&& (fsmc_addr <= `ADDR_PHDATA_END) && (~oppintegram_rdaddr_err);
assign {ccs1ram_rdaddr_err,ccs1ram_rdaddress} = (fsmc_addr >= `ADDR_IDATA_WAY0 && fsmc_addr < `ADDR_IDATA_WAY1) ? (fsmc_addr-`ADDR_IDATA_WAY0):8'b1000_0000;
assign {ccs2ram_rdaddr_err,ccs2ram_rdaddress} = (fsmc_addr >= `ADDR_IDATA_WAY1 && fsmc_addr < `ADDR_IDATA_WAY2) ? (fsmc_addr-`ADDR_IDATA_WAY1):8'b1000_0000;
assign {ccs3ram_rdaddr_err,ccs3ram_rdaddress} = (fsmc_addr >= `ADDR_IDATA_WAY2 && fsmc_addr < `ADDR_IDATA_WAY3) ? (fsmc_addr-`ADDR_IDATA_WAY2):8'b1000_0000;
assign {ccs4ram_rdaddr_err,ccs4ram_rdaddress} = (fsmc_addr >= `ADDR_IDATA_WAY3 && fsmc_addr < `ADDR_IDATA_WAY4) ? (fsmc_addr-`ADDR_IDATA_WAY3):8'b1000_0000;
assign {ccs5ram_rdaddr_err,ccs5ram_rdaddress} = (fsmc_addr >= `ADDR_IDATA_WAY4 && fsmc_addr < `ADDR_IDATA_WAY5) ? (fsmc_addr-`ADDR_IDATA_WAY4):8'b1000_0000;
assign {ccs6ram_rdaddr_err,ccs6ram_rdaddress} = (fsmc_addr >= `ADDR_IDATA_WAY5 && fsmc_addr <= `ADDR_IDATA_END) ? (fsmc_addr-`ADDR_IDATA_WAY5):8'b1000_0000;
assign {oppbakram_rdaddr_err,oppbakram_rdaddress} 	 = (fsmc_addr >= `ADDR_PHDATA_AD0 && fsmc_addr < `ADDR_PHDATA_AD1) ? (fsmc_addr-`ADDR_PHDATA_AD0):8'b1000_0000;
assign {oppintegram_rdaddr_err,oppintegram_rdaddress} = (fsmc_addr >= `ADDR_PHDATA_AD1 && fsmc_addr <= `ADDR_PHDATA_END) ? (fsmc_addr-`ADDR_PHDATA_AD1):8'b1000_0000;						
ram ccs1_ram(.clock(clk64_i),.data(ccs1ram_data),.rdaddress(ccs1ram_rdaddress),.rden(ccs1ram_rden),
				.wraddress(ccs1ram_wraddress),.wren(ccs1ram_wren),.q(ccs1ram_q));
ram ccs2_ram(.clock(clk64_i),.data(ccs2ram_data),.rdaddress(ccs2ram_rdaddress),.rden(ccs2ram_rden),
				.wraddress(ccs2ram_wraddress),.wren(ccs2ram_wren),.q(ccs2ram_q));
ram ccs3_ram(.clock(clk64_i),.data(ccs3ram_data),.rdaddress(ccs3ram_rdaddress),.rden(ccs3ram_rden),
				.wraddress(ccs3ram_wraddress),.wren(ccs3ram_wren),.q(ccs3ram_q));
ram ccs4_ram(.clock(clk64_i),.data(ccs4ram_data),.rdaddress(ccs4ram_rdaddress),.rden(ccs4ram_rden),
				.wraddress(ccs4ram_wraddress),.wren(ccs4ram_wren),.q(ccs4ram_q));
ram ccs5_ram(.clock(clk64_i),.data(ccs5ram_data),.rdaddress(ccs5ram_rdaddress),.rden(ccs5ram_rden),
				.wraddress(ccs5ram_wraddress),.wren(ccs5ram_wren),.q(ccs5ram_q));
ram ccs6_ram(.clock(clk64_i),.data(ccs6ram_data),.rdaddress(ccs6ram_rdaddress),.rden(ccs6ram_rden),
				.wraddress(ccs6ram_wraddress),.wren(ccs6ram_wren),.q(ccs6ram_q));				
ram oppbak_ram(.clock(clk64_i),.data(oppbakram_data),.rdaddress(oppbakram_rdaddress),.rden(oppbakram_rden),
				.wraddress(oppbakram_wraddress),.wren(oppbakram_wren),.q(oppbak_ram_q));
ram oppinteg_ram(.clock(clk64_i),.data(oppintegram_data),.rdaddress(oppintegram_rdaddress),.rden(oppintegram_rden),
				.wraddress(oppintegram_wraddress),.wren(oppintegram_wren),.q(oppinteg_ram_q));

///*-------------threshold judge and valid data save-----------------------
reg	[11:0] ccs_minadc_regr[7:0];
reg	[11:0] ccs_maxadc_regr[7:0];
reg	ccs_minlim_en[7:0];
reg	ccs_maxlim_en[7:0];
reg	[11:0] opp_minadc_regr[1:0];
reg	[11:0] opp_maxadc_regr[1:0];
reg	opp_minlim_en[1:0];
reg	opp_maxlim_en[1:0];

always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		{ccs_minlim_en[0],ccs_minadc_regr[0]} <= 13'h0000;
		{ccs_minlim_en[1],ccs_minadc_regr[1]} <= 13'h0000;
		{ccs_minlim_en[2],ccs_minadc_regr[2]} <= 13'h0000;
		{ccs_minlim_en[3],ccs_minadc_regr[3]} <= 13'h0000;
		{ccs_minlim_en[4],ccs_minadc_regr[4]} <= 13'h0000;
		{ccs_minlim_en[5],ccs_minadc_regr[5]} <= 13'h0000;
		{ccs_minlim_en[6],ccs_minadc_regr[6]} <= 13'h0000;
		{ccs_minlim_en[7],ccs_minadc_regr[7]} <= 13'h0000;
		
		{ccs_maxlim_en[0],ccs_maxadc_regr[0]} <= 13'h0000;
		{ccs_maxlim_en[1],ccs_maxadc_regr[1]} <= 13'h0000;
		{ccs_maxlim_en[2],ccs_maxadc_regr[2]} <= 13'h0000;
		{ccs_maxlim_en[3],ccs_maxadc_regr[3]} <= 13'h0000;
		{ccs_maxlim_en[4],ccs_maxadc_regr[4]} <= 13'h0000;
		{ccs_maxlim_en[5],ccs_maxadc_regr[5]} <= 13'h0000;
		{ccs_maxlim_en[6],ccs_maxadc_regr[6]} <= 13'h0000;
		{ccs_maxlim_en[7],ccs_maxadc_regr[7]} <= 13'h0000;
		{opp_minlim_en[0],opp_minadc_regr[0]} <= 13'h0000;
		{opp_minlim_en[1],opp_minadc_regr[1]} <= 13'h0000;
		
		{opp_maxlim_en[0],opp_maxadc_regr[0]} <= 13'h0000;
		{opp_maxlim_en[1],opp_maxadc_regr[1]} <= 13'h0000;
		end
	else if(SAMP_PASMOD)
		begin
		{ccs_minlim_en[0],ccs_minadc_regr[0]} <= {ccs_minadc_reg[0][15],ccs_minadc_reg[0][11:0]};
		{ccs_minlim_en[1],ccs_minadc_regr[1]} <= {ccs_minadc_reg[1][15],ccs_minadc_reg[1][11:0]};
		{ccs_minlim_en[2],ccs_minadc_regr[2]} <= {ccs_minadc_reg[2][15],ccs_minadc_reg[2][11:0]};
		{ccs_minlim_en[3],ccs_minadc_regr[3]} <= {ccs_minadc_reg[3][15],ccs_minadc_reg[3][11:0]};
		{ccs_minlim_en[4],ccs_minadc_regr[4]} <= {ccs_minadc_reg[4][15],ccs_minadc_reg[4][11:0]};
		{ccs_minlim_en[5],ccs_minadc_regr[5]} <= {ccs_minadc_reg[5][15],ccs_minadc_reg[5][11:0]};
		{ccs_minlim_en[6],ccs_minadc_regr[6]} <= {ccs_minadc_reg[6][15],ccs_minadc_reg[6][11:0]};
		{ccs_minlim_en[7],ccs_minadc_regr[7]} <= {ccs_minadc_reg[7][15],ccs_minadc_reg[7][11:0]};
		
		{ccs_maxlim_en[0],ccs_maxadc_regr[0]} <= {ccs_maxadc_reg[0][15],ccs_maxadc_reg[0][11:0]};
		{ccs_maxlim_en[1],ccs_maxadc_regr[1]} <= {ccs_maxadc_reg[1][15],ccs_maxadc_reg[1][11:0]};
		{ccs_maxlim_en[2],ccs_maxadc_regr[2]} <= {ccs_maxadc_reg[2][15],ccs_maxadc_reg[2][11:0]};
		{ccs_maxlim_en[3],ccs_maxadc_regr[3]} <= {ccs_maxadc_reg[3][15],ccs_maxadc_reg[3][11:0]};
		{ccs_maxlim_en[4],ccs_maxadc_regr[4]} <= {ccs_maxadc_reg[4][15],ccs_maxadc_reg[4][11:0]};
		{ccs_maxlim_en[5],ccs_maxadc_regr[5]} <= {ccs_maxadc_reg[5][15],ccs_maxadc_reg[5][11:0]};
		{ccs_maxlim_en[6],ccs_maxadc_regr[6]} <= {ccs_maxadc_reg[6][15],ccs_maxadc_reg[6][11:0]};
		{ccs_maxlim_en[7],ccs_maxadc_regr[7]} <= {ccs_maxadc_reg[7][15],ccs_maxadc_reg[7][11:0]};
		
		{opp_minlim_en[0],opp_minadc_regr[0]} <= {opp_minadc_reg[0][15],opp_minadc_reg[0][11:0]};
		{opp_minlim_en[1],opp_minadc_regr[1]} <= {opp_minadc_reg[1][15],opp_minadc_reg[1][11:0]};
		
		{opp_maxlim_en[0],opp_maxadc_regr[0]} <= {opp_maxadc_reg[0][15],opp_maxadc_reg[0][11:0]};
		{opp_maxlim_en[1],opp_maxadc_regr[1]} <= {opp_maxadc_reg[1][15],opp_maxadc_reg[1][11:0]};
		end
	end

//valid data save
reg[21:0]  ccs1way_rdata_sum;
reg[21:0]  ccs1way_mdata_sum;
reg[21:0]  ccs2way_rdata_sum;
reg[21:0]  ccs2way_mdata_sum;
reg[21:0]  ccs3way_rdata_sum;
reg[21:0]  ccs3way_mdata_sum;
reg[21:0]  ccs4way_rdata_sum;
reg[21:0]  ccs4way_mdata_sum;
reg[21:0]  ccs5way_rdata_sum;
reg[21:0]  ccs5way_mdata_sum;
reg[21:0]  ccs6way_rdata_sum;
reg[21:0]  ccs6way_mdata_sum;
reg[21:0]  oppway_data0_sum;
reg[21:0]  oppway_data1_sum;
wire[21:0] ccs1way_rdata_av,ccs2way_rdata_av,ccs3way_rdata_av,ccs4way_rdata_av,ccs5way_rdata_av,ccs6way_rdata_av;
wire[21:0] ccs1way_mdata_av,ccs2way_mdata_av,ccs3way_mdata_av,ccs4way_mdata_av,ccs5way_mdata_av,ccs6way_mdata_av;
wire[21:0] oppway_data0_av,oppway_data1_av;
assign ccs1way_rdata_av =  ccs1way_rdata_sum >> FRAM_CONVERT;
assign ccs2way_rdata_av =  ccs2way_rdata_sum >> FRAM_CONVERT;
assign ccs3way_rdata_av =  ccs3way_rdata_sum >> FRAM_CONVERT;
assign ccs4way_rdata_av =  ccs4way_rdata_sum >> FRAM_CONVERT;
assign ccs5way_rdata_av =  ccs5way_rdata_sum >> FRAM_CONVERT;
assign ccs6way_rdata_av =  ccs6way_rdata_sum >> FRAM_CONVERT;
assign ccs1way_mdata_av =  ccs1way_mdata_sum >> FRAM_CONVERT;
assign ccs2way_mdata_av =  ccs2way_mdata_sum >> FRAM_CONVERT;
assign ccs3way_mdata_av =  ccs3way_mdata_sum >> FRAM_CONVERT;
assign ccs4way_mdata_av =  ccs4way_mdata_sum >> FRAM_CONVERT;
assign ccs5way_mdata_av =  ccs5way_mdata_sum >> FRAM_CONVERT;
assign ccs6way_mdata_av =  ccs6way_mdata_sum >> FRAM_CONVERT;
assign oppway_data0_av =  oppway_data0_sum >> (FRAM_CONVERT - 1'b1);
assign oppway_data1_av =  oppway_data1_sum >> (FRAM_CONVERT - 1'b1);
assign ccs1ram_wren = ((cyc_current_state == CYC_GROUP_ADCH0||cyc_current_state == CYC_GROUP_ADCH1) && ~data_full_flag);   //not save data in ram when data_full_flag
assign ccs2ram_wren = ((cyc_current_state == CYC_GROUP_ADCH0||cyc_current_state == CYC_GROUP_ADCH1) && ~data_full_flag);   //not save data in ram when data_full_flag
assign ccs3ram_wren = ((cyc_current_state == CYC_GROUP_ADCH0||cyc_current_state == CYC_GROUP_ADCH1) && ~data_full_flag);   //not save data in ram when data_full_flag
assign ccs4ram_wren = ((cyc_current_state == CYC_GROUP_ADCH0||cyc_current_state == CYC_GROUP_ADCH1) && ~data_full_flag);   //not save data in ram when data_full_flag
assign ccs5ram_wren = ((cyc_current_state == CYC_GROUP_ADCH0||cyc_current_state == CYC_GROUP_ADCH1) && ~data_full_flag);   //not save data in ram when data_full_flag
assign ccs6ram_wren = ((cyc_current_state == CYC_GROUP_ADCH0||cyc_current_state == CYC_GROUP_ADCH1) && ~data_full_flag);   //not save data in ram when data_full_flag
assign oppbakram_wren  = ((cyc_current_state == CYC_GROUP_ADCH0||cyc_current_state == CYC_GROUP_ADCH1) && ~data_full_flag);   //not save data in ram when data_full_flag
assign oppintegram_wren  = ((cyc_current_state == CYC_GROUP_ADCH0||cyc_current_state == CYC_GROUP_ADCH1) && ~data_full_flag);   //not save data in ram when data_full_flag
assign ccs1ram_wraddress = cyc_count_addr;
assign ccs2ram_wraddress = cyc_count_addr;
assign ccs3ram_wraddress = cyc_count_addr;
assign ccs4ram_wraddress = cyc_count_addr;
assign ccs5ram_wraddress = cyc_count_addr;
assign ccs6ram_wraddress = cyc_count_addr;
assign oppbakram_wraddress  = cyc_count_addr;
assign oppintegram_wraddress  = cyc_count_addr;  

//reg test_flag1,test_flag2;
always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)   
		begin
		ccs1way_rdata_sum <= 22'b0;
		ccs2way_rdata_sum <= 22'b0;
		ccs3way_rdata_sum <= 22'b0;
		ccs4way_rdata_sum <= 22'b0;
		ccs5way_rdata_sum <= 22'b0;
		ccs6way_rdata_sum <= 22'b0;
		ccs1way_mdata_sum <= 22'b0;
		ccs2way_mdata_sum <= 22'b0;
		ccs3way_mdata_sum <= 22'b0;
		ccs4way_mdata_sum <= 22'b0;
		ccs5way_mdata_sum <= 22'b0;
		ccs6way_mdata_sum <= 22'b0;
		oppway_data0_sum <= 22'b0;
		oppway_data1_sum <= 22'b0;
		//test_flag1 <= 1'b0;
		//test_flag2 <= 1'b0;
		end
	else if(cyc_current_state == CYC_INIT || (~ccs_sw & SAMP_SCNMOD))//(data_full_flag) //modify,(~ccs_sw & SAMP_SCNMOD),2017.11.29
		begin
		ccs1way_rdata_sum <= 22'b0;
		ccs2way_rdata_sum <= 22'b0;
		ccs3way_rdata_sum <= 22'b0;
		ccs4way_rdata_sum <= 22'b0;
		ccs5way_rdata_sum <= 22'b0;
		ccs6way_rdata_sum <= 22'b0;
		ccs1way_mdata_sum <= 22'b0;
		ccs2way_mdata_sum <= 22'b0;
		ccs3way_mdata_sum <= 22'b0;
		ccs4way_mdata_sum <= 22'b0;
		ccs5way_mdata_sum <= 22'b0;
		ccs6way_mdata_sum <= 22'b0;
		oppway_data0_sum <= 22'b0;
		oppway_data1_sum <= 22'b0;
		end
	else if(dummy_rtsfinished_flag && cyc_next_state == CYC_STABLE_ADCH0 && spi_datao_posedge)
		begin
		ccs1way_rdata_sum  <= ccs1way_rdata_sum +  ccs1_spi_data[15:4];
		ccs2way_rdata_sum  <= ccs2way_rdata_sum +  ccs2_spi_data[15:4];
		ccs3way_rdata_sum  <= ccs3way_rdata_sum +  ccs3_spi_data[15:4];
		ccs4way_rdata_sum  <= ccs4way_rdata_sum +  ccs4_spi_data[15:4];
		ccs5way_rdata_sum  <= ccs5way_rdata_sum +  ccs5_spi_data[15:4];
		ccs6way_rdata_sum  <= ccs6way_rdata_sum +  ccs6_spi_data[15:4];
		if(~cyc_oppdata_ptr)
			oppway_data0_sum   <= oppway_data0_sum  +  opp_spi_data[15:4];
		else
			oppway_data1_sum   <= oppway_data1_sum  +  opp_spi_data[15:4];
		end
	else if(dummy_rtsfinished_flag && cyc_next_state == CYC_STABLE_ADCH1 && spi_datao_posedge)
		begin
		ccs1way_mdata_sum  <= ccs1way_mdata_sum +  ccs1_spi_data[15:4];
		ccs2way_mdata_sum  <= ccs2way_mdata_sum +  ccs2_spi_data[15:4];
		ccs3way_mdata_sum  <= ccs3way_mdata_sum +  ccs3_spi_data[15:4];
		ccs4way_mdata_sum  <= ccs4way_mdata_sum +  ccs4_spi_data[15:4];
		ccs5way_mdata_sum  <= ccs5way_mdata_sum +  ccs5_spi_data[15:4];
		ccs6way_mdata_sum  <= ccs6way_mdata_sum +  ccs6_spi_data[15:4];
		if(~cyc_oppdata_ptr)
			oppway_data0_sum   <= oppway_data0_sum  +  opp_spi_data[15:4];
		else
			oppway_data1_sum   <= oppway_data1_sum  +  opp_spi_data[15:4];
		end
	else if(cyc_current_state == CYC_STABLE_ADCH0 && cyc_group0_posedge)
		begin
		ccs1ram_data <= {frame_data_sta,ccs1way_rdata_av[11:0]};
		ccs2ram_data <= {frame_data_sta,ccs2way_rdata_av[11:0]};
		ccs3ram_data <= {frame_data_sta,ccs3way_rdata_av[11:0]};
		ccs4ram_data <= {frame_data_sta,ccs4way_rdata_av[11:0]};
		ccs5ram_data <= {frame_data_sta,ccs5way_rdata_av[11:0]};
		ccs6ram_data <= {frame_data_sta,ccs6way_rdata_av[11:0]};
		oppbakram_data <= {frame_data_sta,oppway_data0_av[11:0]};
		oppintegram_data <= {frame_data_sta,oppway_data1_av[11:0]};
		//test_flag1 <= 1'b1;
		end
	else if(cyc_current_state == CYC_STABLE_ADCH1 && cyc_group1_posedge)
		begin
		ccs1ram_data <= {frame_data_sta,ccs1way_mdata_av[11:0]};
		ccs2ram_data <= {frame_data_sta,ccs2way_mdata_av[11:0]};
		ccs3ram_data <= {frame_data_sta,ccs3way_mdata_av[11:0]};
		ccs4ram_data <= {frame_data_sta,ccs4way_mdata_av[11:0]};
		ccs5ram_data <= {frame_data_sta,ccs5way_mdata_av[11:0]};
		ccs6ram_data <= {frame_data_sta,ccs6way_mdata_av[11:0]};
		oppbakram_data  <= {frame_data_sta,oppway_data0_av[11:0]};
		oppintegram_data  <= {frame_data_sta,oppway_data1_av[11:0]};
		//test_flag2 <= 1'b1;
		end
	else if(cyc_group0_negedge)
		begin
		ccs1way_rdata_sum  <= 22'b0;
		ccs2way_rdata_sum  <= 22'b0;
		ccs3way_rdata_sum  <= 22'b0;
		ccs4way_rdata_sum  <= 22'b0;
		ccs5way_rdata_sum  <= 22'b0;
		ccs6way_rdata_sum  <= 22'b0;
		oppway_data0_sum   <= 22'b0;
		oppway_data1_sum   <= 22'b0;
		//test_flag1 <= 1'b0;
		//test_flag2 <= 1'b0;
		end
	else if(cyc_group1_negedge)
		begin
		ccs1way_mdata_sum  <= 22'b0;
		ccs2way_mdata_sum  <= 22'b0;
		ccs3way_mdata_sum  <= 22'b0;
		ccs4way_mdata_sum  <= 22'b0;
		ccs5way_mdata_sum  <= 22'b0;
		ccs6way_mdata_sum  <= 22'b0;
		oppway_data0_sum   <= 22'b0;
		oppway_data1_sum   <= 22'b0;
		//test_flag1 <= 1'b0;
		//test_flag2 <= 1'b0;
		end
	end
	
//ccs & opp data threshold judge
reg[15:0] cntccs_presamp_error[5:0];
reg[15:0] cntccs_sampmax_error[5:0];
reg[15:0] cntccs_sampmin_error[5:0];
reg[15:0] cntopp_presamp_error[1:0];
reg[15:0] cntopp_sampmax_error[1:0];
reg[15:0] cntopp_sampmin_error[1:0];
reg[15:0] ccs_presamp_check_count;
reg[15:0] ccs_samp_check_count;
reg[15:0] opp_presamp_check_count;
reg[15:0] opp_samp_check_count;

parameter CCS_CHECK_PRESAMP_NUM = 16'd128,
			 CCS_CHECK_SAMP_NUM	  = 16'd128,
			 OPP_CHECK_PRESAMP_NUM = 16'd1024,
			 OPP_CHECK_SAMP_NUM	  = 16'd1024;
			 
wire[3:0] CNT_CCS_PRELIM,CNT_OPP_PRELIM,CNT_CCS_SAMPLIM,CNT_OPP_SAMPLIM;
assign CNT_CCS_PRELIM  = err_cntlim_reg[`ERR_CNTLIM_CCSPRESAMP_END:`ERR_CNTLIM_CCSPRESAMP_START];
assign CNT_OPP_PRELIM  = err_cntlim_reg[`ERR_CNTLIM_OPPPRESAMP_END:`ERR_CNTLIM_OPPPRESAMP_START];
assign CNT_CCS_SAMPLIM = err_cntlim_reg[`ERR_CNTLIM_CCSSAMP_END:`ERR_CNTLIM_CCSSAMP_START];
assign CNT_OPP_SAMPLIM = err_cntlim_reg[`ERR_CNTLIM_OPPSAMP_END:`ERR_CNTLIM_OPPSAMP_START];

reg[15:0] CCS_PRELIM_NUM,CCS_SAMPLIM_NUM;
reg[15:0] OPP_PRELIM_NUM,OPP_SAMPLIM_NUM;
always @(rstn_i or CNT_CCS_PRELIM or CNT_CCS_SAMPLIM or CNT_OPP_PRELIM or CNT_OPP_SAMPLIM)
 begin
 if(~rstn_i)
	begin
	CCS_PRELIM_NUM  <= 16'b0;
	CCS_SAMPLIM_NUM <= 16'b0;
	OPP_PRELIM_NUM  <= 16'b0;
	OPP_SAMPLIM_NUM <= 16'b0;
	end
 else
	begin
	CCS_PRELIM_NUM  <= (16'b1 << CNT_CCS_PRELIM);
	CCS_SAMPLIM_NUM <= (16'b1 << CNT_CCS_SAMPLIM);
	OPP_PRELIM_NUM	 <= (16'b1 << CNT_OPP_PRELIM);
	OPP_SAMPLIM_NUM <= (16'b1 << CNT_OPP_SAMPLIM);
	end
 end

always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		cntccs_presamp_error[0] <= 16'b0;
		cntccs_presamp_error[1] <= 16'b0;
		cntccs_presamp_error[2] <= 16'b0;
		cntccs_presamp_error[3] <= 16'b0;
		cntccs_presamp_error[4] <= 16'b0;
		cntccs_presamp_error[5] <= 16'b0;
		cntccs_sampmax_error[0] <= 16'b0;
		cntccs_sampmax_error[1] <= 16'b0;
		cntccs_sampmax_error[2] <= 16'b0;
		cntccs_sampmax_error[3] <= 16'b0;
		cntccs_sampmax_error[4] <= 16'b0;
		cntccs_sampmax_error[5] <= 16'b0;		
		cntccs_sampmin_error[0] <= 16'b0;
		cntccs_sampmin_error[1] <= 16'b0;
		cntccs_sampmin_error[2] <= 16'b0;
		cntccs_sampmin_error[3] <= 16'b0;
		cntccs_sampmin_error[4] <= 16'b0;
		cntccs_sampmin_error[5] <= 16'b0;
		cntopp_presamp_error[0]	<= 16'b0;
		cntopp_presamp_error[1]	<= 16'b0;
		cntopp_sampmax_error[0]	<= 16'b0;
		cntopp_sampmax_error[1]	<= 16'b0;		
		cntopp_sampmin_error[0]	<= 16'b0;
		cntopp_sampmin_error[1]	<= 16'b0;
		
		ccs_presamp_check_count	<= 16'b0;
		ccs_samp_check_count		<= 16'b0;
		opp_presamp_check_count	<= 16'b0;
		opp_samp_check_count		<= 16'b0;
		end
	else 
		begin
		if(ccs_presamp_check_count < CCS_CHECK_PRESAMP_NUM) 
			//ccs	rising period
			begin
			if((cyc_current_state == CYC_RISING_ADCH0) && spi_datao_posedge && dummy_strfinished_flag) 
				begin
				ccs_presamp_check_count <= ccs_presamp_check_count + 1'b1;
				if(ccs1_spi_data[15:4] > ccs_maxadc_regr[0] && ccs_maxlim_en[0]) 
					cntccs_presamp_error[0] <= cntccs_presamp_error[0] + 1'b1;
			
				if(ccs2_spi_data[15:4] > ccs_maxadc_regr[1] && ccs_maxlim_en[1]) 
					cntccs_presamp_error[1] <= cntccs_presamp_error[1] + 1'b1;
			
				if(ccs3_spi_data[15:4] > ccs_maxadc_regr[2] && ccs_maxlim_en[2]) 
					cntccs_presamp_error[2] <= cntccs_presamp_error[2] + 1'b1;
			
				if(ccs4_spi_data[15:4] > ccs_maxadc_regr[3] && ccs_maxlim_en[3]) 
					cntccs_presamp_error[3] <= cntccs_presamp_error[3] + 1'b1;
			
				if(ccs5_spi_data[15:4] > ccs_maxadc_regr[4] && ccs_maxlim_en[4]) 
					cntccs_presamp_error[4] <= cntccs_presamp_error[4] + 1'b1;
			
				if(ccs6_spi_data[15:4] > ccs_maxadc_regr[5] && ccs_maxlim_en[5]) 
					cntccs_presamp_error[5] <= cntccs_presamp_error[5] + 1'b1;
				
				end
			end
		else			
			begin
			ccs_presamp_check_count <= 16'b0;
			cntccs_presamp_error[0] <= 16'b0;
			cntccs_presamp_error[1] <= 16'b0;
			cntccs_presamp_error[2] <= 16'b0;
			cntccs_presamp_error[3] <= 16'b0;
			cntccs_presamp_error[4] <= 16'b0;
			cntccs_presamp_error[5] <= 16'b0;
			end
		//opp
		if(opp_presamp_check_count < OPP_CHECK_PRESAMP_NUM)                 //rising period
			begin
			if((cyc_current_state == CYC_RISING_ADCH0) && spi_datao_posedge && dummy_strfinished_flag)
				begin
				opp_presamp_check_count <= opp_presamp_check_count + 1'b1;
				if((opp_spi_data[15:4] > opp_maxadc_regr[0]) && opp_maxlim_en[0] && (~cyc_oppdata_ptr))
					cntopp_presamp_error[0] <= cntopp_presamp_error[0] + 1'b1;
				else if((opp_spi_data[15:4] > opp_maxadc_regr[1]) && opp_maxlim_en[1] && cyc_oppdata_ptr)
					cntopp_presamp_error[1] <= cntopp_presamp_error[1] + 1'b1;
				end
			end
		else    
			begin
			opp_presamp_check_count <= 16'b0;
			cntopp_presamp_error[0] <= 16'b0;
			cntopp_presamp_error[1] <= 16'b0;
			end
	
		if(ccs_samp_check_count < CCS_CHECK_SAMP_NUM)
			begin
			if(cyc_current_state == CYC_STABLE_ADCH0 && spi_datao_posedge && dummy_rtsfinished_flag)
				begin  //stable period
				//ccs	
				ccs_samp_check_count <= ccs_samp_check_count + 1'b1;
				if(ccs1_spi_data[15:4] > ccs_maxadc_regr[0] && ccs_maxlim_en[0]) 
					cntccs_sampmax_error[0] <= cntccs_sampmax_error[0] + 1'b1;
				else if(ccs1_spi_data[15:4] < ccs_minadc_regr[0] && ccs_minlim_en[0])
					cntccs_sampmin_error[0] <= cntccs_sampmin_error[0] + 1'b1;
			
				if(ccs2_spi_data[15:4] > ccs_maxadc_regr[1] && ccs_maxlim_en[1]) 
					cntccs_sampmax_error[1] <= cntccs_sampmax_error[1] + 1'b1;
				else if(ccs2_spi_data[15:4] < ccs_minadc_regr[1] && ccs_minlim_en[1])
					cntccs_sampmin_error[1] <= cntccs_sampmin_error[1] + 1'b1;
			
				if(ccs3_spi_data[15:4] > ccs_maxadc_regr[2] && ccs_maxlim_en[2]) 
					cntccs_sampmax_error[2] <= cntccs_sampmax_error[2] + 1'b1;
				else if(ccs3_spi_data[15:4] < ccs_minadc_regr[2] && ccs_minlim_en[2])
					cntccs_sampmin_error[2] <= cntccs_sampmin_error[2] + 1'b1;
					
				if(ccs4_spi_data[15:4] > ccs_maxadc_regr[3] && ccs_maxlim_en[3]) 
					cntccs_sampmax_error[3] <= cntccs_sampmax_error[3] + 1'b1;
				else if(ccs4_spi_data[15:4] < ccs_minadc_regr[3] && ccs_minlim_en[3])
					cntccs_sampmin_error[3] <= cntccs_sampmin_error[3] + 1'b1;
			
				if(ccs5_spi_data[15:4] > ccs_maxadc_regr[4] && ccs_maxlim_en[4]) 
					cntccs_sampmax_error[4] <= cntccs_sampmax_error[4] + 1'b1;
				else if(ccs5_spi_data[15:4] < ccs_minadc_regr[4] && ccs_minlim_en[4])
					cntccs_sampmin_error[4] <= cntccs_sampmin_error[4] + 1'b1;
			
				if(ccs6_spi_data[15:4] > ccs_maxadc_regr[5] && ccs_maxlim_en[5]) 
					cntccs_sampmax_error[5] <= cntccs_sampmax_error[5] + 1'b1;
				else if(ccs6_spi_data[15:4] < ccs_minadc_regr[5] && ccs_minlim_en[5])
					cntccs_sampmin_error[5] <= cntccs_sampmin_error[5] + 1'b1;
				end
			end
		else  
			begin
			ccs_samp_check_count <= 16'b0;
			cntccs_sampmax_error[0] <= 16'b0;
			cntccs_sampmax_error[1] <= 16'b0;
			cntccs_sampmax_error[2] <= 16'b0;
			cntccs_sampmax_error[3] <= 16'b0;
			cntccs_sampmax_error[4] <= 16'b0;
			cntccs_sampmax_error[5] <= 16'b0;
			cntccs_sampmin_error[0] <= 16'b0;
			cntccs_sampmin_error[1] <= 16'b0;
			cntccs_sampmin_error[2] <= 16'b0;
			cntccs_sampmin_error[3] <= 16'b0;
			cntccs_sampmin_error[4] <= 16'b0;
			cntccs_sampmin_error[5] <= 16'b0;
			end
		//opp
		if(opp_samp_check_count < OPP_CHECK_SAMP_NUM)
			begin
			if((cyc_current_state == CYC_STABLE_ADCH0||cyc_current_state == CYC_STABLE_ADCH1 )&& spi_datao_posedge && dummy_rtsfinished_flag && (~cyc_oppdata_ptr))
				begin
				opp_samp_check_count <= opp_samp_check_count + 1'b1;
				if(opp_spi_data[15:4] > opp_maxadc_regr[0] && opp_maxlim_en[0]) 
					cntopp_sampmax_error[0] <= cntopp_sampmax_error[0] + 1'b1;
				else if(opp_spi_data[15:4] < opp_minadc_regr[0] && opp_minlim_en[0])
					cntopp_sampmin_error[0] <= cntopp_sampmin_error[0] + 1'b1;
				end
			else if((cyc_current_state == CYC_STABLE_ADCH0||cyc_current_state == CYC_STABLE_ADCH1 )&& spi_datao_posedge && dummy_rtsfinished_flag && cyc_oppdata_ptr)
				begin
				opp_samp_check_count <= opp_samp_check_count + 1'b1;
				if(opp_spi_data[15:4] > opp_maxadc_regr[1] && opp_maxlim_en[1]) 
					cntopp_sampmax_error[1] <= cntopp_sampmax_error[1] + 1'b1;
				else if(opp_spi_data[15:4] < opp_minadc_regr[1] && opp_minlim_en[1])
					cntopp_sampmin_error[1] <= cntopp_sampmin_error[1] + 1'b1;
				end
			end
		else     
			begin
			opp_samp_check_count <= 16'b0;
			cntopp_sampmax_error[0] <= 16'b0;
			cntopp_sampmin_error[0] <= 16'b0;
			cntopp_sampmax_error[1] <= 16'b0;
			cntopp_sampmin_error[1] <= 16'b0;
			end
		end		
	end

reg[5:0]	ccspre_error_flag;
reg[5:0]	ccsamp_maxerror_flag;
reg[5:0]	ccsamp_minerror_flag;
reg 		oppre_error_flag;
reg[1:0]	opsamp_maxerror_flag;
reg[1:0]	opsamp_minerror_flag;

always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		ccspre_error_flag	 	  <= 6'b0;
		ccsamp_maxerror_flag   <= 6'b0;
		ccsamp_minerror_flag	  <= 6'b0;
		oppre_error_flag  	  <= 1'b0;
		opsamp_maxerror_flag   <= 2'b0;
		opsamp_minerror_flag   <= 2'b0;
		end
	else if(SCN_MD)   
		begin
		//ccs rising period 
		if(ccs_presamp_check_count == CCS_CHECK_PRESAMP_NUM)
			begin
			if(cntccs_presamp_error[0] >= CCS_PRELIM_NUM)
				ccspre_error_flag[0] <= 1'b1;
			else
				ccspre_error_flag[0] <= 1'b0;
			
			if(cntccs_presamp_error[1] >= CCS_PRELIM_NUM)
				ccspre_error_flag[1] <= 1'b1;
			else
				ccspre_error_flag[1] <= 1'b0;
				
			if(cntccs_presamp_error[2] >= CCS_PRELIM_NUM)
				ccspre_error_flag[2] <= 1'b1;
			else
				ccspre_error_flag[2] <= 1'b0;
			
			if(cntccs_presamp_error[3] >= CCS_PRELIM_NUM)
				ccspre_error_flag[3] <= 1'b1;
			else
				ccspre_error_flag[3] <= 1'b0;
			
			if(cntccs_presamp_error[4] >= CCS_PRELIM_NUM)
				ccspre_error_flag[4] <= 1'b1;
			else
				ccspre_error_flag[4] <= 1'b0;
			
			if(cntccs_presamp_error[5] >= CCS_PRELIM_NUM)
				ccspre_error_flag[5] <= 1'b1;
			else
				ccspre_error_flag[5] <= 1'b0;
			end
		else 
			begin
			if(cntccs_presamp_error[0] >= CCS_PRELIM_NUM)
				ccspre_error_flag[0] <= 1'b1;
			if(cntccs_presamp_error[1] >= CCS_PRELIM_NUM)
				ccspre_error_flag[1] <= 1'b1;
			if(cntccs_presamp_error[2] >= CCS_PRELIM_NUM)
				ccspre_error_flag[2] <= 1'b1;
			if(cntccs_presamp_error[3] >= CCS_PRELIM_NUM)
				ccspre_error_flag[3] <= 1'b1;
			if(cntccs_presamp_error[4] >= CCS_PRELIM_NUM)
				ccspre_error_flag[4] <= 1'b1;
			if(cntccs_presamp_error[5] >= CCS_PRELIM_NUM)
				ccspre_error_flag[5] <= 1'b1;
			end
		//opp presamp
		if(opp_presamp_check_count == OPP_CHECK_PRESAMP_NUM)
			if(cntopp_presamp_error[0] >= OPP_PRELIM_NUM || cntopp_presamp_error[1] >= OPP_PRELIM_NUM)
				oppre_error_flag <= 1'b1;
			else
				oppre_error_flag <= 1'b0;
		else 
			begin
			if(cntopp_presamp_error[0] >= OPP_PRELIM_NUM || cntopp_presamp_error[1] >= OPP_PRELIM_NUM)
				oppre_error_flag <= 1'b1;
			end
		//ccs stable period 
		if(ccs_samp_check_count == CCS_CHECK_SAMP_NUM)
			begin
			if(cntccs_sampmax_error[0] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[0] <= 1'b1;
			else if(cntccs_sampmin_error[0] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[0] <= 1'b1;
			else
				begin
				ccsamp_maxerror_flag[0] <= 1'b0;
				ccsamp_minerror_flag[0] <= 1'b0;
				end
			
			if(cntccs_sampmax_error[1] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[1] <= 1'b1;
			else if(cntccs_sampmin_error[1] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[1] <= 1'b1;
			else
				begin
				ccsamp_maxerror_flag[1] <= 1'b0;
				ccsamp_minerror_flag[1] <= 1'b0;
				end
			
			if(cntccs_sampmax_error[2] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[2] <= 1'b1;
			else if(cntccs_sampmin_error[2] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[2] <= 1'b1;
			else
				begin
				ccsamp_maxerror_flag[2] <= 1'b0;
				ccsamp_minerror_flag[2] <= 1'b0;
				end
			
			if(cntccs_sampmax_error[3] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[3] <= 1'b1;
			else if(cntccs_sampmin_error[3] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[3] <= 1'b1;
			else
				begin
				ccsamp_maxerror_flag[3] <= 1'b0;
				ccsamp_minerror_flag[3] <= 1'b0;
				end
			
			if(cntccs_sampmax_error[4] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[4] <= 1'b1;
			else if(cntccs_sampmin_error[4] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[4] <= 1'b1;
			else
				begin
				ccsamp_maxerror_flag[4] <= 1'b0;
				ccsamp_minerror_flag[4] <= 1'b0;
				end
			
			if(cntccs_sampmax_error[5] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[5] <= 1'b1;
			else if(cntccs_sampmin_error[5] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[5] <= 1'b1;
			else
				begin
				ccsamp_maxerror_flag[5] <= 1'b0;
				ccsamp_minerror_flag[5] <= 1'b0;
				end
			end
		else 
			begin
			if(cntccs_sampmax_error[0] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[0] <= 1'b1;
			else if(cntccs_sampmin_error[0] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[0] <= 1'b1;
				
			if(cntccs_sampmax_error[1] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[1] <= 1'b1;
			else if(cntccs_sampmin_error[1] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[1] <= 1'b1;
				
			if(cntccs_sampmax_error[2] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[2] <= 1'b1;
			else if(cntccs_sampmin_error[2] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[2] <= 1'b1;
				
			if(cntccs_sampmax_error[3] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[3] <= 1'b1;
			else if(cntccs_sampmin_error[3] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[3] <= 1'b1;
			
			if(cntccs_sampmax_error[4] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[4] <= 1'b1;
			else if(cntccs_sampmin_error[4] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[4] <= 1'b1;
				
			if(cntccs_sampmax_error[5] >= CCS_SAMPLIM_NUM)
				ccsamp_maxerror_flag[5] <= 1'b1;
			else if(cntccs_sampmin_error[5] >= CCS_SAMPLIM_NUM)
				ccsamp_minerror_flag[5] <= 1'b1;
			end
		//opp samp 
		if(opp_samp_check_count == OPP_CHECK_SAMP_NUM)
			begin
			if(cntopp_sampmax_error[0] >= OPP_SAMPLIM_NUM)
					opsamp_maxerror_flag[0] <= 1'b1;
			else if(cntopp_sampmin_error[0] >= OPP_SAMPLIM_NUM)
				opsamp_minerror_flag[0] <= 1'b1;
			else
				begin
				opsamp_maxerror_flag[0] <= 1'b0;
				opsamp_minerror_flag[0] <= 1'b0;
				end
				
			if(cntopp_sampmax_error[1] >= OPP_SAMPLIM_NUM)
					opsamp_maxerror_flag[1] <= 1'b1;
			else if(cntopp_sampmin_error[1] >= OPP_SAMPLIM_NUM)
				opsamp_minerror_flag[1] <= 1'b1;
			else
				begin
				opsamp_maxerror_flag[1] <= 1'b0;
				opsamp_minerror_flag[1] <= 1'b0;
				end
			end
		else 
			begin
			if(cntopp_sampmax_error[0] >= OPP_SAMPLIM_NUM)
				opsamp_maxerror_flag[0] <= 1'b1;
			else if(cntopp_sampmin_error[0] >= OPP_SAMPLIM_NUM)
				opsamp_minerror_flag[0] <= 1'b1;
				
			if(cntopp_sampmax_error[1] >= OPP_SAMPLIM_NUM)
				opsamp_maxerror_flag[1] <= 1'b1;
			else if(cntopp_sampmin_error[1] >= OPP_SAMPLIM_NUM)
				opsamp_minerror_flag[1] <= 1'b1;
			end
		end
	end


//ccs and opp data full flag 
always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		data_full_flag <= 1'b0;
	else if(~SCN_MD | error_sta)
		data_full_flag <= 1'b0;
	else if((fsmc_addr == `ADDR_LAST_PHDATA) && ~fsmc_csn && ~fsmc_nrd && fsmc_nwr)  //read opp last data address clear data_full_flag
		data_full_flag <= 1'b0;
	else if(cyc_frame_finished)
		data_full_flag <= 1'b1;
	end
assign fsmc_full_irq_o = data_full_flag;
assign fsmc_data_irq_o = scn_valid_flag ? 1'b0 : spi_datao_flag;// | ang_spi_irq);  //ad mode,no irq ack

wire	ccspre_error_kflag;
wire	ccsamp_maxerror_kflag;
wire	ccsamp_minerror_kflag;
wire  oppre_error_kflag;
wire  opsamp_maxerror_kflag;
wire  opsamp_minerror_kflag;

assign ccspre_error_kflag = |ccspre_error_flag;
assign ccsamp_maxerror_kflag = |ccsamp_maxerror_flag;
assign ccsamp_minerror_kflag = |ccsamp_minerror_flag;
assign oppre_error_kflag = oppre_error_flag;
assign opsamp_maxerror_kflag = |opsamp_maxerror_flag;
assign opsamp_minerror_kflag = |opsamp_minerror_flag;
assign ccs_preerror_code = {2'b0,idle_ccsadc_err,2'b0,ccspre_error_flag};
assign ccs_samperror_code[`CCS_SAMPMAXERRCD_END:`CCS_SAMPMAXERRCD_START] = ccsamp_maxerror_flag;
assign ccs_samperror_code[`CCS_SAMPMINERRCD_END:`CCS_SAMPMINERRCD_START] = ccsamp_minerror_flag;
assign opp_error_code[15:9] = 7'b0;
assign opp_error_code[8] = opp_bakintegerr_flag;
assign opp_error_code[7] = 1'b0;
assign opp_error_code[3] = 1'b0;
assign opp_error_code[`OPP_ERRCD_PRESAMP1_BIT] 	 = 1'b0;								//ch1
assign opp_error_code[`OPP_ERRCD_MAXSAMP1_BIT] 	 = opsamp_maxerror_flag[1];
assign opp_error_code[`OPP_ERRCD_MINSAMP1_BIT]   = opsamp_minerror_flag[1];
assign opp_error_code[`OPP_ERRCD_PRESAMP0_BIT] 	 = oppre_error_flag;				//ch0
assign opp_error_code[`OPP_ERRCD_MAXSAMP0_BIT]   = opsamp_maxerror_flag[0];
assign opp_error_code[`OPP_ERRCD_MINSAMP0_BIT]   = opsamp_minerror_flag[0];

//***********************---- enable,mode,error,event signal detect------******************************/
/* //mode sel raycus delete 20170824
//mode select detect
reg modsel_reg,modsel_regr;
always @(posedge clk_100us or negedge rstn_i)  
	begin 
	if (~rstn_i)
		begin
		modsel_reg  <= 1'b1;   //1:rs232 mode 0: ad mode 
		modsel_regr <= 1'b1;
		end
	else
		begin
		modsel_reg  <= modsel_i;
		modsel_regr <= modsel_reg;
		end
	end

parameter MODSEL_COUNT_NUM = 8'd10,
			 MODSEL_THD_NUM	= 8'd7,
			 MODSEL_AD			= 1'b1,
			 MODSEL_RS232		= 1'b0;
			 
reg [7:0] count_modsel;
reg [7:0] count_modsel_l;
reg modsel_sta;
always @(posedge clk_100us or negedge rstn_i)  
	begin 
	if (~rstn_i)
		begin
		count_modsel <= 8'd0;
		count_modsel_l <= 8'd0;
		modsel_sta <= MODSEL_RS232;
		end
	else if(count_modsel >= MODSEL_COUNT_NUM)
		begin
		count_modsel <= 8'd0;
		count_modsel_l <= 8'd0;
		if(count_modsel_l >= MODSEL_THD_NUM)
			modsel_sta <= MODSEL_AD;
		else
			modsel_sta <= MODSEL_RS232;
		end
	else
		begin
		count_modsel <= count_modsel + 1'b1;
		if(~modsel_regr)
			count_modsel_l <= count_modsel_l + 1'b1;
		end
	end
*/
//ang mode lightout enable signal detect
reg ang_lgten_reg,ang_lgten_regr;
always @(posedge clk_100us or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		ang_lgten_reg  <= 1'b1;   //1:no 0: light out enable
		ang_lgten_regr <= 1'b1;
		end
	else
		begin
		ang_lgten_reg  <= ang_lgten_i;
		ang_lgten_regr <= ang_lgten_reg;
		end
	end

parameter ANGLGTEN_COUNT_NUM = 8'd20,
			 ANGLGTEN_THD_NUM	= 8'd15,
			 ANGLGTEN_ON		= 1'b1,
			 ANGLGTEN_OFF		= 1'b0;
			 
reg [7:0] count_lgten;
reg [7:0] count_lgten_l;
reg lgten_sta;
always @(posedge clk_100us or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		count_lgten <= 8'd0;
		count_lgten_l <= 8'd0;
		lgten_sta <= ANGLGTEN_OFF;
		end
	else if(~da_set_mod)     //not analog mode 
		begin
		count_lgten <= 8'd0;
		count_lgten_l <= 8'd0;
		lgten_sta <= ANGLGTEN_OFF;
		end
	else if(count_lgten >= ANGLGTEN_COUNT_NUM)
		begin
		count_lgten <= 8'd0;
		count_lgten_l <= 8'd0;
		if(count_lgten_l >= ANGLGTEN_THD_NUM)
			lgten_sta <= ANGLGTEN_ON;
		else
			lgten_sta <= ANGLGTEN_OFF;
		end
	else
		begin
		count_lgten <= count_lgten + 1'b1;
		if(~ang_lgten_regr)
			count_lgten_l <= count_lgten_l + 1'b1;
		end
	end

//remstart detect
reg remstart_reg,remstart_regr;
always @(posedge clk_100us or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		remstart_reg  <= 1'b1;   //1:no 0: rem start  
		remstart_regr <= 1'b1;
		end
	else
		begin
		remstart_reg  <= rem_start_i;
		remstart_regr <= remstart_reg;
		end
	end

parameter REMSTART_COUNT_NUM = 8'd20,
			 REMSTART_THD_NUM	= 8'd15,
			 REMSTART_ON		= 1'b1,
			 REMSTART_OFF		= 1'b0;
			 
reg [7:0] count_remstart;
reg [7:0] count_remstart_l;
reg remstart_sta;
always @(posedge clk_100us or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		count_remstart <= 8'd0;
		count_remstart_l <= 8'd0;
		remstart_sta <= REMSTART_OFF;
		end
	else if(~FIELD_SEL)          //remote 
		begin
		count_remstart <= 8'd0;
		count_remstart_l <= 8'd0;
		remstart_sta <= REMSTART_OFF;
		end
	else if(count_remstart >= REMSTART_COUNT_NUM)
		begin
		count_remstart <= 8'd0;
		count_remstart_l <= 8'd0;
		if(count_remstart_l >= REMSTART_THD_NUM)
			remstart_sta <= REMSTART_ON;
		else
			remstart_sta <= REMSTART_OFF;
		end
	else
		begin
		count_remstart <= count_remstart + 1'b1;
		if(~remstart_regr)
			count_remstart_l <= count_remstart_l + 1'b1;
		end
	end

//error detect and lock
reg mpiog_reg,mpiog_regr;
reg qbhlock_reg,qbhlock_regr;
reg keylock_reg,keylock_regr;
//reg interlock_reg,interlock_regr;

always @(posedge clk_100us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		//mpiog_reg	   <= 1'b1;   //1:normal state
		//mpiog_regr	   <= 1'b1;
		qbhlock_reg    <= 1'b0;	  //0:normal state
		qbhlock_regr   <= 1'b0;
		keylock_reg	   <= 1'b0;
		keylock_regr   <= 1'b0;
		//interlock_reg  <= 1'b0;
		//interlock_regr <= 1'b0;
		end
	else
		begin
		//mpiog_reg	 	<= mpwr_iog_i;
		//mpiog_regr	 	<= mpiog_reg;
		qbhlock_reg  	<= qbhlock_i;
		qbhlock_regr 	<= qbhlock_reg;
		keylock_reg	 	<= keylock_i;
		keylock_regr 	<= keylock_reg;
		//interlock_reg	<= interlock_i;
		//interlock_regr <= interlock_reg;
		end
	end
	
//modify for iog
reg mpiog_derr_reg;
always @(posedge clk_100us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		mpiog_reg	   <= 1'b1;   //1:normal state
		mpiog_regr	   <= 1'b1;
		mpiog_derr_reg <= 1'b0;
		end
	else
		begin
		mpiog_reg	 	<= mpwr_iog_i;
		mpiog_regr	 	<= mpiog_reg;
		mpiog_derr_reg <= mpiog_derr_flag;
		end
	end
	
//mpiog
wire mpiog_detect_en;
assign mpiog_detect_en = status[`STATUS_LGTOUT_STA_BIT] & MPWR_EN & dac_has_setpower;
parameter MPIOG_LIMNUM	   = 8'd200,
			 MPIOG_ERR_LIMNUM = 8'd30,
			 MPIOG_CYC_NUM		= 8'd50,
			 MPIOG_CYC_ERRLIM	= 8'd25;

reg	[7:0] count_mpiog_d;
reg	[7:0] count_mpiog_derr;
reg   mpiog_dcyc_flag;
wire	mpiog_derr_flag;
assign mpiog_derr_flag = (count_mpiog_derr >= MPIOG_CYC_ERRLIM) ? 1'b1 : 1'b0;
always @(posedge clk_100us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		count_mpiog_d <= 8'd0;
		count_mpiog_derr <= 8'd0;
		mpiog_dcyc_flag  <= 1'b0;
		end
	else if(~err_check_reg[`CHECK_MPIOG_ERR_BIT])
		begin
		count_mpiog_d <= 8'd0;
		count_mpiog_derr <= 8'd0;
		mpiog_dcyc_flag  <= 1'b0;
		end
	else if((count_mpiog_d < MPIOG_CYC_NUM) && mpiog_detect_en)
		begin
		count_mpiog_d	<= count_mpiog_d + 1'b1;
		mpiog_dcyc_flag  <= 1'b0;
		if(~mpiog_regr)
			count_mpiog_derr <= count_mpiog_derr + 1'b1;
		end
	else if(count_mpiog_d >= MPIOG_CYC_NUM)
		begin
		count_mpiog_d	<= 8'd0;
		count_mpiog_derr <= 8'd0;
		mpiog_dcyc_flag  <= 1'b1;
		end
	end

reg	[7:0] count_mpiog;
reg	[7:0] count_mpiog_err;
reg	mpiog_err_flag;
always @(posedge mpiog_dcyc_flag or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		count_mpiog <= 8'b0;
		count_mpiog_err <= 8'b0;
		mpiog_err_flag <= 1'b0;
		end
	else if(~err_check_reg[`CHECK_MPIOG_ERR_BIT])
		begin
		count_mpiog <= 8'b0;
		count_mpiog_err <= 8'b0;
		mpiog_err_flag <= 1'b0;
		end
	else if(count_mpiog < MPIOG_LIMNUM)
		begin
		count_mpiog <= count_mpiog + 1'b1;
		if(mpiog_derr_reg)
			if(count_mpiog_err < MPIOG_ERR_LIMNUM)
				count_mpiog_err <= count_mpiog_err + 1'b1;
			else
				mpiog_err_flag <= 1'b1;
		end
	else
		begin
		count_mpiog <= 8'b0;
		count_mpiog_err <= 8'b0;
		if((mpiog_derr_reg) && (count_mpiog_err == (MPIOG_ERR_LIMNUM - 1'b1)))
			mpiog_err_flag <= 1'b1;
		end
	end

//qbhlock,keylock,interlock
parameter LOCK_LIMNUM		= 8'd200,
			 LOCK_ERR_LIMNUM  = 8'd8;	
//lock detect and lock
reg[7:0]	count_qbhlock_err,count_keylock_err,count_interlock_err;
reg[7:0]	count_qbhlock,count_keylock,count_interlock;
reg  qbhlock_err_flag,keylock_err_flag,interlock_err_flag;
//qbh
always @(posedge clk_100us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		count_qbhlock_err <= 8'd0;
		count_qbhlock 	<= 8'd0;
		qbhlock_err_flag <= 1'b0;
		end
	else if(~err_check_reg[`CHECK_QBHLOCK_ERR_BIT])
		begin
		count_qbhlock_err <= 8'd0;
		count_qbhlock 	<= 8'd0;
		qbhlock_err_flag <= 1'b0;
		end
		
	else if(count_qbhlock < LOCK_LIMNUM)
		begin
		count_qbhlock <= count_qbhlock + 1'b1;
		if(qbhlock_regr)                               
			if(count_qbhlock_err < LOCK_ERR_LIMNUM)
				count_qbhlock_err <= count_qbhlock_err + 1'b1;
			else
				qbhlock_err_flag <= 1'b1;
		end
	else
		begin
		count_qbhlock_err <= 8'd0;
		count_qbhlock 	<= 8'd0;
		if(qbhlock_regr && count_qbhlock_err == (LOCK_ERR_LIMNUM - 1'b1)) 
			qbhlock_err_flag <= 1'b1;
		end
	end

//keylock
always @(posedge clk_100us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		count_keylock_err <= 8'd0;
		count_keylock 	<= 8'd0;
		keylock_err_flag <= 1'b0;
		end
	else if(~err_check_reg[`CHECK_KEYLOCK_ERR_BIT])
		begin
		count_keylock_err <= 8'd0;
		count_keylock 	<= 8'd0;
		keylock_err_flag <= 1'b0;
		end
		
	else if(count_keylock < LOCK_LIMNUM)
		begin
		count_keylock <= count_keylock + 1'b1;
		if(keylock_regr)                               
			if(count_keylock_err < LOCK_ERR_LIMNUM)
				count_keylock_err <= count_keylock_err + 1'b1;
			else
				keylock_err_flag <= 1'b1;
		end
	else
		begin
		count_keylock_err <= 8'd0;
		count_keylock 	<= 8'd0;
		if(keylock_regr && count_keylock_err == (LOCK_ERR_LIMNUM - 1'b1))
			keylock_err_flag <= 1'b1;
		end
	end

//interlock
/*
always @(posedge clk_100us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		count_interlock_err <= 8'd0;
		count_interlock 	<= 8'd0;
		interlock_err_flag <= 1'b0;
		end
	else if(~err_check_reg[`CHECK_INTERLOCK_ERR_BIT])
		begin
		count_interlock_err <= 8'd0;
		count_interlock 	<= 8'd0;
		interlock_err_flag <= 1'b0;
		end
		
	else if(count_interlock < LOCK_LIMNUM)
		begin
		count_interlock <= count_interlock + 1'b1;
		if(interlock_regr)                               
			if(count_interlock_err < LOCK_ERR_LIMNUM)
				count_interlock_err <= count_interlock_err + 1'b1;
			else
				interlock_err_flag <= 1'b1;
		end
	else
		begin
		count_interlock_err <= 8'd0;
		count_interlock 	<= 8'd0;
		if(interlock_regr && count_interlock_err == (LOCK_ERR_LIMNUM - 1'b1))
			interlock_err_flag <= 1'b1;
		end
	end
*/
//ccs limit error detect
parameter CCS_LIMNUM 		= 8'd200,
			 CCS_ERR_LIMNUM 	= 8'd16;

reg ccs_limerr_reg,ccs_limerr_regr;
wire ccs_limerr_i;
assign ccs_limerr_i=ccs_limerr1_i|ccs_limerr2_i;
always @(posedge clk_250ns or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		ccs_limerr_reg	  <= 1'b1;
		ccs_limerr_regr  <= 1'b1;
		end
	else
		begin
		ccs_limerr_reg	  <= ~ccs_limerr_i;
		ccs_limerr_regr  <= ccs_limerr_reg;
		end
	end
		
reg[7:0]	count_ccslim_err;
reg[7:0]	count_ccslim;
reg  ccs_limerr_flag;
always @(posedge clk_250ns or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		count_ccslim_err <= 8'd0;
		count_ccslim     <= 8'd0;
		ccs_limerr_flag  <= 1'b0;
		end
	else if(~err_check_reg[`CHECK_CCSLIM_ERR_BIT])
		begin
		count_ccslim_err <= 8'd0;
		count_ccslim     <= 8'd0;
		ccs_limerr_flag  <= 1'b0;
		end
	else if(count_ccslim < CCS_LIMNUM)
		begin
		count_ccslim <= count_ccslim + 1'b1;
		if(~ccs_limerr_regr)
			if(count_ccslim_err < CCS_ERR_LIMNUM)
				count_ccslim_err <= count_ccslim_err + 1'b1;
			else
				ccs_limerr_flag <= 1'b1;
		end	
	else
		begin
		count_ccslim_err <= 8'b0;
		count_ccslim <= 8'b0;
		if(~ccs_limerr_regr && count_ccslim_err == (CCS_ERR_LIMNUM - 1'b1))
			ccs_limerr_flag <= 1'b1;
		end
	end
//------------------ opp limit detect and judge------------------------
reg opp_limerr1_reg,opp_limerr1_regr;
reg opp_limerr2_reg,opp_limerr2_regr;
always @(posedge clk_1us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		opp_limerr1_reg  <= 1'b1;
		opp_limerr1_regr <= 1'b1;
		opp_limerr2_reg  <= 1'b1;
		opp_limerr2_regr <= 1'b1;
		end
	else
		begin
		opp_limerr1_reg  <= opp_limerr1_i;
		opp_limerr1_regr <= opp_limerr1_reg;
		opp_limerr2_reg  <= opp_limerr2_i;
		opp_limerr2_regr <= opp_limerr2_reg;
		end
	end
//opp bak and integrate	detect
parameter OPP_BAKINTEG_NUM = 8'd200,
			 OPP_BAKINTEG_ERRNUM = 8'd5,
			 OPP_FLICK_NUM		= 8'd200;
			 
wire[9:0] OPP_BAKINTEG_PWLMT;
wire[5:0] OPP_LMT_FLICK;
assign OPP_BAKINTEG_PWLMT = opp_pwlmt_reg[`OPPH_COUNT_END:`OPPH_COUNT_START];
assign OPP_LMT_FLICK = opp_pwlmt_reg[`OPPF_COUNT_END:`OPPF_COUNT_START];
reg[999:0]	opp_bakinteg_save;
reg[15:0]count_opp_bakinteg;
wire  opp_bakinteg_lim;  
assign opp_bakinteg_lim = (count_opp_bakinteg >= OPP_BAKINTEG_PWLMT) ? 1'b1 : 1'b0;

always @(posedge clk_1us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		opp_bakinteg_save  <= 1000'b0;
		count_opp_bakinteg <= 16'd0;
		end
	else if(~config_ok)
		begin
		opp_bakinteg_save  <= 1000'b0;
		count_opp_bakinteg <= 16'd0;
		end
	else if(~err_check_reg[`CHECK_OPPLIM_ERR_BIT])
		begin
		opp_bakinteg_save  <= 1000'b0;
		count_opp_bakinteg <= 16'd0;
		end
	else if(cyc_current_state == CYC_STABLE_ADCH0 || cyc_current_state == CYC_STABLE_ADCH1)
		begin
		opp_bakinteg_save[999:1] <= opp_bakinteg_save[998:0];
		opp_bakinteg_save[0] <= (~opp_limerr1_regr);
		
		if(~opp_limerr1_regr)
			begin
			if((~opp_bakinteg_save[999]) && (count_opp_bakinteg < 1000))
				count_opp_bakinteg <= count_opp_bakinteg + 1'b1;
			else
				count_opp_bakinteg <= count_opp_bakinteg;
			end
		else 
			begin
			if((opp_bakinteg_save[999]) && (count_opp_bakinteg >= 1'b1))
				count_opp_bakinteg <= count_opp_bakinteg - 1'b1;
			else
				count_opp_bakinteg <= count_opp_bakinteg;
			end
		end
	end
	
reg	opp_bakintegerr_flag;
reg[7:0] count_bakinteg_cyc,count_bakinteg_lim;
always @(posedge clk_1us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		count_bakinteg_cyc 	<= 8'd0;
		count_bakinteg_lim 	<= 8'd0;
		opp_bakintegerr_flag <= 1'b0;
		end
	else if(~config_ok)
		begin
		count_bakinteg_cyc 	<= 8'd0;
		count_bakinteg_lim 	<= 8'd0;
		opp_bakintegerr_flag <= 1'b0;
		end
	else if(~err_check_reg[`CHECK_OPPLIM_ERR_BIT])
		begin
		count_bakinteg_cyc 	<= 8'd0;
		count_bakinteg_lim 	<= 8'd0;
		opp_bakintegerr_flag <= 1'b0;
		end
	else if(count_bakinteg_cyc < OPP_BAKINTEG_NUM)
		begin
		count_bakinteg_cyc <= count_bakinteg_cyc + 1'b1;
		if(opp_bakinteg_lim)
			begin
			if(count_bakinteg_lim < OPP_BAKINTEG_ERRNUM)
				count_bakinteg_lim <= count_bakinteg_lim + 1'b1;
			else
				opp_bakintegerr_flag <= 1'b1;
			end
		end	
	else
		begin
		count_bakinteg_cyc <= 8'b0;
		count_bakinteg_lim <= 8'b0;
		if(opp_bakinteg_lim && (count_bakinteg_lim == (OPP_BAKINTEG_ERRNUM - 1'b1)))
			opp_bakintegerr_flag <= 1'b1;
		end
	end
	
//opp flicker detect 	
reg[7:0] count_opp_flick;
reg[7:0] count_opp_flickerr;
reg opp_flickerr_flag;
always @(posedge clk_1us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		count_opp_flickerr 	<= 8'd0;
		count_opp_flick 		<= 8'd0;
		opp_flickerr_flag 	<= 1'b0;
		end
	else if(~config_ok)
		begin
		count_opp_flickerr 	<= 8'd0;
		count_opp_flick 		<= 8'd0;
		opp_flickerr_flag 	<= 1'b0;
		end
	else if(~err_check_reg[`CHECK_OPPFLIM_ERR_BIT])
		begin
		count_opp_flickerr 	<= 8'd0;
		count_opp_flick 		<= 8'd0;
		opp_flickerr_flag 	<= 1'b0;
		end
	else if(count_opp_flick < OPP_FLICK_NUM)
		begin
		count_opp_flick <= count_opp_flick + 1'b1;
		if(~opp_limerr2_regr)
			if(count_opp_flickerr < OPP_LMT_FLICK)
				count_opp_flickerr <= count_opp_flickerr + 1'b1;
			else
				opp_flickerr_flag <= 1'b1;
		end	
	else
		begin
		count_opp_flickerr <= 8'b0;
		count_opp_flick <= 8'b0;
		if(~opp_limerr2_regr && (count_opp_flickerr == (OPP_LMT_FLICK - 1'b1)))
			opp_flickerr_flag <= 1'b1;
		end
	end
			
//error code 
assign error_code[`ERROR_MPIOG_ERR_BIT]	  = mpiog_err_flag; 
assign error_code[`ERROR_QBHLOCK_ERR_BIT]	  = qbhlock_err_flag;
assign error_code[`ERROR_KEYLOCK_ERR_BIT]	  = keylock_err_flag;
assign error_code[`ERROR_IOPPINTEG_ERR_BIT] = ioppinteg_err_flag;
assign error_code[`ERROR_OPPLIM_ERR_BIT] 	  = opp_bakintegerr_flag;  //bak and integrate opp error
assign error_code[`ERROR_OPPFLIM_ERR_BIT]	  = opp_flickerr_flag;		//flicker opp error
assign error_code[`ERROR_CCSLIM_ERR_BIT]	  = ccs_limerr_flag;
assign error_code[`ERROR_IDLECCS_ERR_BIT]	  = idle_ccsadc_kerr;
assign error_code[`ERROR_TLPW_ERR_BIT]		  = tlpw_limerr_flag;
assign error_code[`ERROR_WMT_ERR_BIT]		  = wmt_err_flag & err_check_reg[`CHECK_WMT_ERR_BIT];
assign error_code[`ERROR_IOPPBK_ERR_BIT]	  = ioppbk_err_flag;	

assign error_code[`ERROR_ANGIN_WARN_BIT]	  = angin_warn_flag & err_check_reg[`CHECK_ANGIN_WARN_BIT];
assign error_code[`ERROR_OPPSAMP_WARN_BIT]  = (opsamp_maxerror_kflag | opsamp_minerror_kflag | oppre_error_kflag) & err_check_reg[`CHECK_OPPSAMP_WARN_BIT];
assign error_code[`ERROR_CCSMAXSAMP_WARN_BIT] 	= ccsamp_maxerror_kflag & err_check_reg[`CHECK_CCSMAXSAMP_WARN_BIT];
assign error_code[`ERROR_CCSMINSAMP_WARN_BIT] 	= ccsamp_minerror_kflag & err_check_reg[`CHECK_CCSMINSAMP_WARN_BIT];
assign error_code[`ERROR_CCSPRESAMP_WARN_BIT] 	= ccspre_error_kflag & err_check_reg[`CHECK_CCSPRESAMP_WARN_BIT];
assign error_sta = (|error_code[`ERROR_END:`ERROR_START])|STM32_ERROR;
assign fpga_error_sta = |error_code[`ERROR_END:`ERROR_START];
assign warn_sta  = |error_code[`WARN_END:`WARN_START]; 


//************************************----status----*****************************************/	
//event detect and clear
reg error_star,warn_star,remstart_star;//modsel_star,wmten_star;
reg lgten_star;
always @(posedge clk64_i or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		error_star <= 1'b0;
		warn_star  <= 1'b0;
		remstart_star <= 1'b0;
		//modsel_star	  <= 1'b0;
		//wmten_star	  <= 1'b0;
		lgten_star	  <= 1'b0;
		end
	else
		begin
		error_star <= error_sta;
		warn_star  <= warn_sta;
		remstart_star <= remstart_sta;
		//modsel_star	  <= modsel_sta;
		//wmten_star	  <= wmten_sta;
		lgten_star	  <= lgten_sta;
		end
	end

reg	wrn_i_reg1,wrn_i_reg2;
reg	rdn_i_reg1;
reg	csn_i_reg1,csn_i_reg2;

always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		begin
		wrn_i_reg1 <= 1'b1;
		wrn_i_reg2 <= 1'b1;
		rdn_i_reg1 <= 1'b1;
		csn_i_reg1 <= 1'b1;
		end
	else
		begin
		wrn_i_reg1 <= fsmc_nwr;
		wrn_i_reg2 <= wrn_i_reg1;
		rdn_i_reg1 <= fsmc_nrd;
		csn_i_reg1 <= fsmc_csn;
		csn_i_reg2 <= csn_i_reg1;
		end
	end
		
reg ev_error_flag,ev_warn_flag,ev_remstart_flag;//ev_modsel_flag,ev_wmten_flag;
reg ev_lgten_flag;
always @(posedge clk64_i or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		ev_error_flag <= 1'b0;
		ev_warn_flag  <= 1'b0;
		ev_remstart_flag <= 1'b0;
		ev_lgten_flag	  <= 1'b0;
		//ev_modsel_flag	<= 1'b0;
		//ev_wmten_flag  <= 1'b0;
		end
	else if(~csn_i_reg2 & wrn_i_reg1 & ~wrn_i_reg2 & rdn_i_reg1 & fsmc_addr == `ADDR_STATUS)    			//write poseedge
		begin
		if(error_sta ^ error_star)
			ev_error_flag <= 1'b1;
		else if(status_ev_reg[`STATUS_ERROR_EV_BIT])
			ev_error_flag <= 1'b0;
		
		if(warn_sta ^ warn_star)
			ev_warn_flag  <= 1'b1;
		else if(status_ev_reg[`STATUS_WARN_EV_BIT])
			ev_warn_flag  <= 1'b0;
		
		if(remstart_sta ^ remstart_star)
			ev_remstart_flag <= 1'b1;
		else if(status_ev_reg[`STATUS_REMSTART_EV_BIT])
			ev_remstart_flag <= 1'b0;
		
		if(lgten_sta ^ lgten_star)
			ev_lgten_flag <= 1'b1;
		else if(status_ev_reg[`STATUS_LGTEN_EV_BIT])
			ev_lgten_flag <= 1'b0;
			
		/*	
		if(modsel_sta ^ modsel_star)
			ev_modsel_flag	<= 1'b1;
		else if(status_ev_reg[`STATUS_MODSEL_EV_BIT])
			ev_modsel_flag	<= 1'b0;
			
		if(wmten_sta ^ wmten_star)
			ev_wmten_flag  <= 1'b1;
		else if(status_ev_reg[`STATUS_WMTEN_EV_BIT])
			ev_wmten_flag  <= 1'b0;*/
		end
	else
		begin
		if(error_sta ^ error_star)
			ev_error_flag <= 1'b1;
		if(warn_sta ^ warn_star)
			ev_warn_flag  <= 1'b1;
		if(remstart_sta ^ remstart_star)
			ev_remstart_flag <= 1'b1;
		if(lgten_sta ^ lgten_star)
			ev_lgten_flag <= 1'b1;
		/*
		if(modsel_sta ^ modsel_star)
			ev_modsel_flag	<= 1'b1;
		if(wmten_sta ^ wmten_star)
			ev_wmten_flag  <= 1'b1;*/
		end
	end

assign status[`STATUS_ERROR_STA_BIT] 	 = error_sta;
assign status[`STATUS_WARN_STA_BIT]  	 = warn_sta;
assign status[`STATUS_LGTOUT_STA_BIT]	 = ccs_sw & CCS_RD & (~error_sta);
assign status[`STATUS_LGTRD_STA_BIT]	 = CCS_RD;
assign status[`STATUS_IDLE_STA_BIT]		 = ~ccs_sw;
assign status[`STATUS_REMSTART_STA_BIT] = remstart_sta;
assign status[`STATUS_LGTEN_STA_BIT]	 = lgten_sta;
//assign status[`STATUS_WMTEN_STA_BIT]	 = wmten_sta;
assign status[`STATUS_REDLGTREQ_STA_BIT]= redlgt_req_flag;
assign status[`STATUS_CONFIG_OK_STA_BIT]= config_ok;
assign status[`STATUS_PLC_START_STA_BIT]= plc_start_req_flag;	//20180113 LXS
assign status[`STATUS_PLC_MODE_STA_BIT] = plc_mode_req_flag;	//20180113 LXS
//assign status[6:5]							 = 2'b0;
assign status[`STATUS_ERROR_EV_BIT]		 = ev_error_flag;
assign status[`STATUS_WARN_EV_BIT]		 = ev_warn_flag;
assign status[`STATUS_REMSTART_EV_BIT]	 = ev_remstart_flag;
assign status[`STATUS_LGTEN_EV_BIT]	 	 = ev_lgten_flag;
assign status[0]							 	 = 1'b0;
//assign status[`STATUS_MODSEL_EV_BIT]	 = ev_modsel_flag;
//assign status[`STATUS_WMTEN_EV_BIT]	 = ev_wmten_flag;
assign fsmc_chg_irq_o = |status[`STATUS_EV_END : `STATUS_EV_START];

//idle state ad detect current and judge 
parameter 
	 IDLE_SAMPREQ_NUM	 = 16'd6400,		//100us
	 IDLE_SAMP_2NUMM   = 4'd4,          //2^N (N : 0~9)
	 IDLE_SAMPERR_NUM  = 8'd5,				//error count limit number
	 IDLE_SAMPCYC_NUM  = 8'd100,			//judge error cycle number
	 IDLE_DUMPDATA_NUM = 8'd3;				//dump adc data number

parameter
	 IDSAMP_IDLE	 = 4'b0001,
	 IDSAMP_SAMP	 = 4'b0010,
	 IDSAMP_FRAM	 = 4'b0100;

reg[3:0]  idle_samp_current_sta,idle_samp_next_sta;	 
reg[15:0] count_idle;
reg[7:0]  count_idledump_num;
reg[9:0]  count_idlesamp_num;
wire idle_samp_valid;
assign idle_samp_valid = (count_idledump_num == 8'd0) ? 1'b1 : 1'b0;
wire idle_samp_en = (((cyc_current_state == CYC_INIT) || (cyc_current_state == CYC_IDLE)) && SCN_MD) ? 1'b1 : 1'b0;
wire[9:0] IDLE_SAMPAV_NUM;
assign  IDLE_SAMPAV_NUM = (10'b1 << IDLE_SAMP_2NUMM);
wire idle_samp_start;
assign idle_samp_start = (count_idle >= IDLE_SAMPREQ_NUM) ? 1'b1 : 1'b0;
wire idle_sampfram_finished;
assign idle_sampfram_finished = ((idle_samp_current_sta == IDSAMP_SAMP) && (count_idlesamp_num == IDLE_SAMPAV_NUM)) ? 1'b1 : 1'b0;

//idle sample sta
always @(posedge clk64_i or negedge rstn_i)
	begin
	if (~rstn_i)
		idle_samp_current_sta <= IDSAMP_IDLE;
	else
		idle_samp_current_sta <= idle_samp_next_sta;	
	end

always @(rstn_i or idle_samp_en or idle_samp_current_sta or idle_samp_next_sta or idle_samp_start or idle_sampfram_finished)
	begin
	if(~rstn_i | (~idle_samp_en))
		idle_samp_next_sta = IDSAMP_IDLE;
	else
		case(idle_samp_current_sta)
			IDSAMP_IDLE:
				idle_samp_next_sta = idle_samp_start ? IDSAMP_SAMP : IDSAMP_IDLE;
			IDSAMP_SAMP:
				idle_samp_next_sta = idle_sampfram_finished ? IDSAMP_FRAM : IDSAMP_SAMP;
			IDSAMP_FRAM:
				idle_samp_next_sta = IDSAMP_IDLE;
			default:
				idle_samp_next_sta = IDSAMP_IDLE;
		endcase
	end
//idle n sample cycle 	
always @(posedge clk64_i or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		count_idle <= 16'b0;
		count_idledump_num <= IDLE_DUMPDATA_NUM;
		count_idlesamp_num <= 10'b0;
		end
	else if(~idle_samp_en)
		begin
		count_idle <= 16'b0;
		count_idledump_num <= IDLE_DUMPDATA_NUM;
		//count_idlesamp_num <= 10'b0;
		end
	else
		case(idle_samp_current_sta)
			IDSAMP_IDLE: 
				begin
				count_idledump_num <= IDLE_DUMPDATA_NUM;
				//count_idlesamp_num <= 10'b0;
				if(count_idle < IDLE_SAMPREQ_NUM)
					count_idle <= count_idle + 1'b1;
				else
					count_idle <= count_idle;
				end
			IDSAMP_SAMP:
				begin
				count_idle <= 16'b0;
				if(count_idlesamp_num < IDLE_SAMPAV_NUM)   //get ad sample
					begin
					if(idle_samp_valid & spi_datao_posedge)
						count_idlesamp_num <= count_idlesamp_num + 1'b1;
					else if((~idle_samp_valid) & spi_datao_posedge)
						count_idledump_num <= count_idledump_num - 1'b1;
					else
						begin
						count_idlesamp_num <= count_idlesamp_num;
						count_idledump_num <= count_idledump_num;
						end
					end
				end
			IDSAMP_FRAM:
				begin
				count_idlesamp_num <= 10'b0;
				count_idledump_num <= IDLE_DUMPDATA_NUM;
				count_idle <= 16'b0;
				end
			default:
				begin
				count_idlesamp_num <= 10'b0;
				count_idledump_num <= IDLE_DUMPDATA_NUM;
				count_idle <= 16'b0;
				end
			endcase
		end
//idle sample judge		
reg[21:0]  idle_sampadc1_sum,idle_sampadc2_sum,idle_sampadc3_sum,idle_sampadc4_sum,idle_sampadc5_sum,idle_sampadc6_sum;
wire[11:0] idle_sampadc_av[5:0];
wire idle_sampfram_negedge;
assign idle_sampfram_negedge = idle_samp_current_sta[2] & (~idle_samp_next_sta[2]);
assign idle_sampadc_av[0] = idle_sampadc1_sum[(IDLE_SAMP_2NUMM+11):IDLE_SAMP_2NUMM];
assign idle_sampadc_av[1] = idle_sampadc2_sum[(IDLE_SAMP_2NUMM+11):IDLE_SAMP_2NUMM];
assign idle_sampadc_av[2] = idle_sampadc3_sum[(IDLE_SAMP_2NUMM+11):IDLE_SAMP_2NUMM];
assign idle_sampadc_av[3] = idle_sampadc4_sum[(IDLE_SAMP_2NUMM+11):IDLE_SAMP_2NUMM];
assign idle_sampadc_av[4] = idle_sampadc5_sum[(IDLE_SAMP_2NUMM+11):IDLE_SAMP_2NUMM];
assign idle_sampadc_av[5] = idle_sampadc6_sum[(IDLE_SAMP_2NUMM+11):IDLE_SAMP_2NUMM]; 

always @(posedge clk64_i or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin		
		idle_sampadc1_sum <= 22'b0;
		idle_sampadc2_sum <= 22'b0;
		idle_sampadc3_sum <= 22'b0;
		idle_sampadc4_sum <= 22'b0;
		idle_sampadc5_sum <= 22'b0;
		idle_sampadc6_sum <= 22'b0;
		end
	else if(~err_check_reg[`ERROR_IDLECCS_ERR_BIT])
		begin		
		idle_sampadc1_sum <= 22'b0;
		idle_sampadc2_sum <= 22'b0;
		idle_sampadc3_sum <= 22'b0;
		idle_sampadc4_sum <= 22'b0;
		idle_sampadc5_sum <= 22'b0;
		idle_sampadc6_sum <= 22'b0;
		end
	else if(idle_samp_current_sta == IDSAMP_SAMP && idle_samp_valid && spi_datao_posedge)
		begin
		idle_sampadc1_sum <= idle_sampadc1_sum + ccs1_spi_data[15:4];
		idle_sampadc2_sum <= idle_sampadc2_sum + ccs2_spi_data[15:4];
		idle_sampadc3_sum <= idle_sampadc3_sum + ccs3_spi_data[15:4];
		idle_sampadc4_sum <= idle_sampadc4_sum + ccs4_spi_data[15:4];
		idle_sampadc5_sum <= idle_sampadc5_sum + ccs5_spi_data[15:4];
		idle_sampadc6_sum <= idle_sampadc6_sum + ccs6_spi_data[15:4];
		end
	else if(idle_sampfram_negedge)
		begin
		idle_sampadc1_sum	  <= 22'b0;
		idle_sampadc2_sum	  <= 22'b0;
		idle_sampadc3_sum	  <= 22'b0;
		idle_sampadc4_sum	  <= 22'b0;
		idle_sampadc5_sum	  <= 22'b0;
		idle_sampadc6_sum	  <= 22'b0;
		end
	end
			
reg[5:0] idle_ccsadc_err;
reg[7:0] idle_samperr_count[5:0];
reg[7:0] idle_ccsadc_cyc;
wire[11:0] IDLE_CCSADC_THD;
assign IDLE_CCSADC_THD = idle_current_value[11:0];	
always @(posedge clk64_i or negedge rstn_i)
	begin 
	if (~rstn_i)
		begin
		idle_ccsadc_err <= 6'b0;
		idle_ccsadc_cyc <= 8'b0;
		idle_samperr_count[0] <= 8'b0;
		idle_samperr_count[1] <= 8'b0;
		idle_samperr_count[2] <= 8'b0;
		idle_samperr_count[3] <= 8'b0;
		idle_samperr_count[4] <= 8'b0;
		idle_samperr_count[5] <= 8'b0;
		end
	else if(~err_check_reg[`ERROR_IDLECCS_ERR_BIT])
		begin
		idle_ccsadc_err <= 6'b0;
		idle_ccsadc_cyc <= 8'b0;
		idle_samperr_count[0] <= 8'b0;
		idle_samperr_count[1] <= 8'b0;
		idle_samperr_count[2] <= 8'b0;
		idle_samperr_count[3] <= 8'b0;
		idle_samperr_count[4] <= 8'b0;
		idle_samperr_count[5] <= 8'b0;
		end
	else if((idle_ccsadc_cyc < IDLE_SAMPCYC_NUM) && (idle_samp_current_sta == IDSAMP_FRAM))
		begin
		idle_ccsadc_cyc <= idle_ccsadc_cyc + 1'b1;
		if(idle_sampadc_av[0] > IDLE_CCSADC_THD && idle_samperr_count[0] < IDLE_SAMPERR_NUM)
			idle_samperr_count[0] <= idle_samperr_count[0] + 1'b1;
		else
			;
		if(idle_sampadc_av[1] > IDLE_CCSADC_THD && idle_samperr_count[1] < IDLE_SAMPERR_NUM)
			idle_samperr_count[1] <= idle_samperr_count[1] + 1'b1;
		else
			;
		if(idle_sampadc_av[2] > IDLE_CCSADC_THD && idle_samperr_count[2] < IDLE_SAMPERR_NUM)
			idle_samperr_count[2] <= idle_samperr_count[2] + 1'b1;
		else
		   ;
		if(idle_sampadc_av[3] > IDLE_CCSADC_THD && idle_samperr_count[3] < IDLE_SAMPERR_NUM)
			idle_samperr_count[3] <= idle_samperr_count[3] + 1'b1;
		else
			;
		if(idle_sampadc_av[4] > IDLE_CCSADC_THD && idle_samperr_count[4] < IDLE_SAMPERR_NUM)
			idle_samperr_count[4] <= idle_samperr_count[4] + 1'b1;
		else
			;
		if(idle_sampadc_av[5] > IDLE_CCSADC_THD && idle_samperr_count[5] < IDLE_SAMPERR_NUM)
			idle_samperr_count[5] <= idle_samperr_count[5] + 1'b1;
		else
			;
		end
	else if(idle_ccsadc_cyc < IDLE_SAMPCYC_NUM)
		begin
		if(idle_samperr_count[0] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[0] <= 1'b1;
		if(idle_samperr_count[1] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[1] <= 1'b1;
		if(idle_samperr_count[2] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[2] <= 1'b1;
		if(idle_samperr_count[3] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[3] <= 1'b1;
		if(idle_samperr_count[4] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[4] <= 1'b1;
		if(idle_samperr_count[5] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[5] <= 1'b1;
		end
	else
		begin
		if(idle_samperr_count[0] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[0] <= 1'b1;
		if(idle_samperr_count[1] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[1] <= 1'b1;
		if(idle_samperr_count[2] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[2] <= 1'b1;
		if(idle_samperr_count[3] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[3] <= 1'b1;
		if(idle_samperr_count[4] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[4] <= 1'b1;
		if(idle_samperr_count[5] >= IDLE_SAMPERR_NUM)
			idle_ccsadc_err[5] <= 1'b1;
		
		idle_ccsadc_cyc <= 8'b0;	
		idle_samperr_count[0] <= 8'b0;
		idle_samperr_count[1] <= 8'b0;
		idle_samperr_count[2] <= 8'b0;
		idle_samperr_count[3] <= 8'b0;
		idle_samperr_count[4] <= 8'b0;
		idle_samperr_count[5] <= 8'b0;	
		end
	end
	
wire idle_ccsadc_kerr;  
assign idle_ccsadc_kerr = |idle_ccsadc_err;

//total power limit protection
wire[7:0]  TLPW_LIMCOUNT_THD;
assign TLPW_LIMCOUNT_THD = tlpw_cntlim_reg[`ERR_CNTLIM_TLPW_END : `ERR_CNTLIM_TLPW_START];

parameter  TLPW_INIT 		 = 8'b0000_0001,
			  TLPW_IDLE 		 = 8'b0000_0010,
			  TLPW_ISUM        = 8'b0000_0100,
			  TLPW_JUDGE		 = 8'b0000_1000,
			  TLPW_CALTHD		 = 8'b0001_0000,
			  TLPW_FINISHED	 = 8'b0010_0000;


reg[7:0]	 tlpw_current_sta,tlpw_next_sta;
reg[15:0] tlpw_sum_reg;
reg[15:0] tlpw_oppower_reg;
reg[49:0] tlpw_stasave_reg;
reg tlpw_tbit_reg;
reg[7:0]	 tlpw_limcount_reg;

wire tlpw_isum_req;
assign tlpw_isum_req = (((cyc_current_state == CYC_RISING_ADCH0 && dummy_strfinished_flag) || (cyc_current_state == CYC_STABLE_ADCH0 && dummy_rtsfinished_flag)) && spi_datao_posedge);
wire tlpw_isum_en;
assign tlpw_isum_en  = ((cyc_current_state == CYC_RISING_ADCH0 && dummy_strfinished_flag) || (cyc_current_state == CYC_STABLE_ADCH0 && dummy_rtsfinished_flag)) && SAMP_SCNMOD;
			 
always @(posedge clk64_i or negedge rstn_i)
	begin 
	if (~rstn_i)
		tlpw_current_sta <= TLPW_INIT;
	else
		tlpw_current_sta <= tlpw_next_sta;	
	end

always @(rstn_i or tlpw_isum_req or tlpw_current_sta or tlpw_isum_en)
	begin
	if(~rstn_i)
		tlpw_next_sta = TLPW_INIT;
	else if(~tlpw_isum_en)
		tlpw_next_sta = TLPW_IDLE;
	else 
		case(tlpw_current_sta)
			TLPW_INIT	:  tlpw_next_sta = TLPW_IDLE;
			TLPW_IDLE	:  tlpw_next_sta = tlpw_isum_req ? TLPW_ISUM : TLPW_IDLE;
			TLPW_ISUM	:  tlpw_next_sta = TLPW_JUDGE;
			TLPW_JUDGE  :  tlpw_next_sta = TLPW_CALTHD;
			TLPW_CALTHD	:	tlpw_next_sta = TLPW_FINISHED;
			TLPW_FINISHED: tlpw_next_sta = TLPW_IDLE;
			default:
				tlpw_next_sta = TLPW_IDLE;
		endcase
	end
	
always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		tlpw_sum_reg	  <= 16'b0;
		tlpw_stasave_reg <= 50'b0;
		tlpw_limcount_reg<= 8'b0;
		tlpw_tbit_reg	  <= 1'b0;
		tlpw_oppower_reg <= 16'b0;
		ioppinteg_opp_result	<= 32'b0;
		end
	else if(~tlpw_isum_en)
		begin
		tlpw_sum_reg	  <= 16'b0;
		tlpw_tbit_reg	  <= 1'b0;
		tlpw_oppower_reg <= 16'b0;
		ioppinteg_opp_result	<= 32'b0;
		end
	else
		case(tlpw_current_sta)
			TLPW_INIT:
				begin
				tlpw_sum_reg	  <= 16'b0;
				tlpw_stasave_reg <= 50'b0;
				tlpw_limcount_reg<= 8'b0;
				tlpw_tbit_reg	  <= 1'b0;
				tlpw_oppower_reg <= 16'b0;
				ioppinteg_opp_result	<= 32'b0;
				end
			TLPW_IDLE:
				begin
				tlpw_sum_reg	  <= 16'b0;
				tlpw_oppower_reg <= 16'b0;
				tlpw_tbit_reg	  <= 1'b0;
				ioppinteg_opp_result	<= 32'b0;
				end
			TLPW_ISUM:
				begin
				tlpw_sum_reg 	  <= (ccs1_spi_data[15:4] + ccs2_spi_data[15:4] + ccs3_spi_data[15:4] + 
											ccs4_spi_data[15:4] + ccs5_spi_data[15:4] + ccs6_spi_data[15:4]);
				tlpw_oppower_reg <= opp_spi_data[15:4];
				ioppinteg_opp_result	<= 32'b0;
				end
			TLPW_JUDGE:
				begin
				if(tlpw_sum_reg > total_power_limit)
					begin
					if((~tlpw_stasave_reg[49]) && (tlpw_limcount_reg < 50))
						begin
						tlpw_limcount_reg <= tlpw_limcount_reg + 1'b1;
						tlpw_tbit_reg <= 1'b1;
						end
					else
						begin
						tlpw_limcount_reg <= tlpw_limcount_reg;
						tlpw_tbit_reg <= 1'b0;
						end
					end
				else
					begin
					tlpw_tbit_reg <= 1'b0;
					if((tlpw_stasave_reg[49]) && (tlpw_limcount_reg >= 1'b1))
						tlpw_limcount_reg <= tlpw_limcount_reg - 1'b1;
					else
						tlpw_limcount_reg <= tlpw_limcount_reg;
					end
				end
			TLPW_CALTHD:
				begin
				if(B_SIGN)
					ioppinteg_opp_result	<= (ioppinteg_opp_vmult - ioppinteg_b_reg);
				else
					ioppinteg_opp_result	<= (ioppinteg_opp_vmult + ioppinteg_b_reg);
				end	
			TLPW_FINISHED:
				tlpw_stasave_reg[49:0] <= {tlpw_stasave_reg[48:0],tlpw_tbit_reg};
				default: 
					begin
					tlpw_sum_reg	  <= 16'b0;
					tlpw_oppower_reg <= 16'b0;
					tlpw_tbit_reg	  <= 1'b0;
					ioppinteg_opp_result	<= 32'b0;
					end
			endcase
		end
	
reg tlpw_limerr_flag;					
always @(posedge clk64_i or negedge rstn_i)
	begin 
	if (~rstn_i)
		tlpw_limerr_flag <= 1'b0;	
	else if(~err_check_reg[`CHECK_TLPW_ERR_BIT])
		tlpw_limerr_flag <= 1'b0;	
	else if(tlpw_limcount_reg >= TLPW_LIMCOUNT_THD)
		tlpw_limerr_flag <= 1'b1;
	else
		tlpw_limerr_flag <= tlpw_limerr_flag;
	end
	
//iopp power judge protection
wire[11:0] IOPPBK_MINLMT,IOPPBK_MEDLMT;
wire[7:0]  IOPPBK_ERRCNT_THD,IOPPINTEG_ERRCNT_THD;
assign IOPPBK_MINLMT = ioppbk_oppminthd_reg[`IOPPBK_MIN_END : `IOPPBK_MIN_START];
assign IOPPBK_MEDLMT = ioppbk_oppmedthd_reg[`IOPPBK_MED_END : `IOPPBK_MED_START];
assign IOPPBK_ERRCNT_THD = iopp_cntlim_reg[`IOPPBK_ERRCNT_END : `IOPPBK_ERRCNT_START];
assign IOPPINTEG_ERRCNT_THD = iopp_cntlim_reg[`IOPPINTEG_ERRCNT_END : `IOPPINTEG_ERRCNT_START];
wire iopp_write_maxerrcount_flag;
assign iopp_write_maxerrcount_flag = (~csn_i_reg2 & wrn_i_reg1 & ~wrn_i_reg2 & rdn_i_reg1 & (fsmc_addr == `ADDR_OVERLMT_COUNT)); //write posedge

parameter 
	 IOPPBK_JDCYC_NUM	 	= 8'd128,		       
	 IOPPINTEG_JDCYC_NUM = 8'd128;

reg[7:0] ioppbk_cyc_count;
reg[7:0] ioppbk_err_count;
reg 		ioppbk_err_flag;
reg[7:0] ioppbk_err_maxcount;

always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		ioppbk_cyc_count 	<= 8'd0;
		ioppbk_err_count 	<= 8'd0;
		ioppbk_err_flag 	<= 1'b0;
		ioppbk_err_maxcount <= 8'd0;
		end
	else if(iopp_write_maxerrcount_flag)
		ioppbk_err_maxcount <= iopp_maxerr_count_reg[`IOPPBK_ERRCOUNT_END : `IOPPBK_ERRCOUNT_START];
	else if((ioppbk_cyc_count < IOPPBK_JDCYC_NUM) && (tlpw_current_sta == TLPW_FINISHED) && (cyc_oppad_ptr) && SAMP_SCNMOD)
		begin
		ioppbk_cyc_count <= ioppbk_cyc_count + 1'b1;
		if(~err_check_reg[`CHECK_IOPPBK_ERR_BIT])
			ioppbk_err_flag 	<= 1'b0;
		else if(ioppbk_err_count >= IOPPBK_ERRCNT_THD)
			ioppbk_err_flag 	<= 1'b1;
		else
			ioppbk_err_flag 	<= ioppbk_err_flag;
		
		if(tlpw_sum_reg > ioppbk_imedthd_reg && (tlpw_oppower_reg[11:0] < IOPPBK_MEDLMT))
			ioppbk_err_count <= ioppbk_err_count + 1'b1;
		else if(tlpw_sum_reg > ioppbk_iminthd_reg && (tlpw_oppower_reg[11:0] < IOPPBK_MINLMT))
			ioppbk_err_count <= ioppbk_err_count + 1'b1;
		else
			ioppbk_err_count <= ioppbk_err_count;
		end
	else if(ioppbk_cyc_count >= IOPPBK_JDCYC_NUM)
		begin
		ioppbk_cyc_count	<= 8'b0;
		ioppbk_err_count  <= 8'b0;
		if(ioppbk_err_count > ioppbk_err_maxcount)  //record the max error count number
			ioppbk_err_maxcount <= ioppbk_err_count;
		end
	else if(~err_check_reg[`CHECK_IOPPBK_ERR_BIT])
		ioppbk_err_flag 	<= 1'b0;
	end

wire	 B_SIGN;
wire [15:0] Kioppinteg;
assign B_SIGN = ioppinteg_k_reg[`B_SIGN_BIT];
assign Kioppinteg = {1'b0,ioppinteg_k_reg[`K_DATA_END	: `K_DATA_START]};
wire[31:0] ioppinteg_opp_vmult;
reg[31:0] ioppinteg_opp_result;
ioppinteg_mult ioppinteg_mult_inst(.dataa(Kioppinteg),.datab(tlpw_sum_reg),.result(ioppinteg_opp_vmult));

reg[7:0] ioppinteg_cyc_count;
reg[7:0] ioppinteg_err_count;
reg		ioppinteg_err_flag;
reg[7:0] ioppinteg_err_maxcount;

always @(posedge clk64_i or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		ioppinteg_cyc_count 	<= 8'd0;
		ioppinteg_err_count 	<= 8'd0;
		ioppinteg_err_flag 	<= 1'b0;
		ioppinteg_err_maxcount  <= 8'b0;
		end
	else if(iopp_write_maxerrcount_flag)
		ioppinteg_err_maxcount <= iopp_maxerr_count_reg[`IOPPINTEG_ERRCOUNT_END : `IOPPINTEG_ERRCOUNT_START];
	else if((ioppinteg_cyc_count < IOPPINTEG_JDCYC_NUM) && (tlpw_current_sta == TLPW_FINISHED) && (~cyc_oppad_ptr) 
			&& (tlpw_sum_reg > ioppbk_iminthd_reg) && SAMP_SCNMOD)
		begin
		ioppinteg_cyc_count <= ioppinteg_cyc_count + 1'b1;
		if(~err_check_reg[`CHECK_IOPPINTEG_ERR_BIT])
			ioppinteg_err_flag 	<= 1'b0;
		else if(ioppinteg_err_count >= IOPPINTEG_ERRCNT_THD)
			ioppinteg_err_flag 	<= 1'b1;
		else
			ioppinteg_err_flag 	<= ioppinteg_err_flag;
			
		if((tlpw_oppower_reg[11:0] < ioppinteg_opp_result[20:9]))  //less than isum half power
			ioppinteg_err_count <= ioppinteg_err_count + 1'b1;
		else
			ioppinteg_err_count <= ioppinteg_err_count;
		end
	else if(ioppinteg_cyc_count >= IOPPINTEG_JDCYC_NUM)
		begin
		ioppinteg_cyc_count	<= 8'b0;
		ioppinteg_err_count  <= 8'b0;
		if(ioppinteg_err_count > ioppinteg_err_maxcount)
			ioppinteg_err_maxcount <= ioppinteg_err_count;
		end
	else if(~err_check_reg[`CHECK_IOPPINTEG_ERR_BIT])
		ioppinteg_err_flag 	<= 1'b0;
	end
/*
parameter
	REDLGT_REQ_TIM = 26'd9600000,  //300ms
	REDLGT_REQOFF_THD = 16'd4800;  //300ms * 0.0005
	
reg redlgt_req_flag;
reg[25:0] redlgt_tcount_reg;
reg[15:0] redlgt_offcount_reg;
always @(posedge clk_in or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		redlgt_req_flag <= 1'b0;
		redlgt_tcount_reg <= 26'd0;
		redlgt_offcount_reg <= 16'd0;
		end
	else if(redlgt_tcount_reg >= REDLGT_REQ_TIM)
		begin
		redlgt_req_flag <= 1'b1;			//on redlgt request
		redlgt_tcount_reg <= 26'd0;
		redlgt_offcount_reg <= 16'd0;
		end
	else if(redlgt_offcount_reg < REDLGT_REQOFF_THD)
		begin
		redlgt_tcount_reg <= redlgt_tcount_reg + 1'b1;
		if(ccs_sw)
			redlgt_offcount_reg <= redlgt_offcount_reg + 1'b1;
		end
	else 
		begin
		redlgt_tcount_reg <= 26'd0;
		redlgt_offcount_reg <= 16'd0;
		redlgt_req_flag <= 1'b0;      //off redlgt request
		end
	end
*/

parameter 
	REDLASER_COUNT_NUM	= 8'd10,
	REDLASER_THD_NUM		= 8'd7;
reg[7:0] count_redlaser;
reg[7:0] count_redlaser_l;
reg redlgt_req_flag;
reg red_laser_reg,red_laser_regr;

always @(posedge clk_100us or negedge rstn_i)
	if(~rstn_i)
		begin
		red_laser_reg <= 1'b1;
		red_laser_regr <= 1'b1;
		end
	else
		begin
		red_laser_reg <= red_laser_i;
		red_laser_regr<= red_laser_reg;
		end
		
always @(posedge clk_100us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		count_redlaser <= 8'd0;
		count_redlaser_l <= 8'd0;
		redlgt_req_flag <= 1'b0;
		end
	else if(count_redlaser >= REDLASER_COUNT_NUM)
		begin
		count_redlaser <= 8'd0;
		count_redlaser_l <= 8'd0;
		if(count_redlaser_l >= REDLASER_THD_NUM)
			redlgt_req_flag <= 1'b1;
		else
			redlgt_req_flag <= 1'b0;
		end
	else
		begin
		count_redlaser <= count_redlaser + 1'b1;
		if(~red_laser_regr)
			count_redlaser_l <= count_redlaser_l + 1'b1;
		else
			count_redlaser_l <= count_redlaser_l;
		end
	end
	



parameter 
	PLCSTART_COUNT_NUM	= 8'd10,
	PLCSTART_THD_NUM		= 8'd7;
reg[7:0] count_plcstart;
reg[7:0] count_plcstart_l;
reg plc_start_req_flag;
reg plc_start_reg,plc_start_regr;

always @(posedge clk_100us or negedge rstn_i)
	if(~rstn_i)
		begin
		plc_start_reg <= 1'b1;
		plc_start_regr <= 1'b1;
		end
	else
		begin
		plc_start_reg <= plc_start_i;
		plc_start_regr<= plc_start_reg;
		end
		
always @(posedge clk_100us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		count_plcstart <= 8'd0;
		count_plcstart_l <= 8'd0;
		plc_start_req_flag <= 1'b0;
		end
	else if(count_plcstart >= PLCSTART_COUNT_NUM)
		begin
		count_plcstart <= 8'd0;
		count_plcstart_l <= 8'd0;
		if(count_plcstart_l >= PLCSTART_THD_NUM)
			plc_start_req_flag <= 1'b1;
		else
			plc_start_req_flag <= 1'b0;
		end
	else
		begin
		count_plcstart <= count_plcstart + 1'b1;
		if(~plc_start_regr)
			count_plcstart_l <= count_plcstart_l + 1'b1;
		else
			count_plcstart_l <= count_plcstart_l;
		end
	end	
	
		
	

parameter 
	PLCMODE_COUNT_NUM	= 8'd10,
	PLCMODE_THD_NUM		= 8'd7;
reg[7:0] count_plcmode;
reg[7:0] count_plcmode_l;
reg plc_mode_req_flag;
reg plc_mode_reg,plc_mode_regr;

always @(posedge clk_100us or negedge rstn_i)
	if(~rstn_i)
		begin
		plc_mode_reg <= 1'b1;
		plc_mode_regr <= 1'b1;
		end
	else
		begin
		plc_mode_reg <= plc_mode_i;
		plc_mode_regr<= plc_mode_reg;
		end
		
always @(posedge clk_100us or negedge rstn_i)
	begin
	if(~rstn_i)
		begin
		count_plcmode <= 8'd0;
		count_plcmode_l <= 8'd0;
		plc_mode_req_flag <= 1'b0;
		end
	else if(count_plcmode >= PLCMODE_COUNT_NUM)
		begin
		count_plcmode <= 8'd0;
		count_plcmode_l <= 8'd0;
		if(count_plcmode_l >= PLCMODE_THD_NUM)
			plc_mode_req_flag <= 1'b1;
		else
			plc_mode_req_flag <= 1'b0;
		end
	else
		begin
		count_plcmode <= count_plcmode + 1'b1;
		if(~plc_mode_regr)
			count_plcmode_l <= count_plcmode_l + 1'b1;
		else
			count_plcmode_l <= count_plcmode_l;
		end
	end	
	
	
	
	
endmodule





