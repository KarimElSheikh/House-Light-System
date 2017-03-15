module DE2_115_Synthesizer(
input CLOCK_50,
input CLOCK2_50,
input AUD_ADCDAT,
inout AUD_ADCLRCK,
inout AUD_BCLK,
output AUD_DACDAT,
inout AUD_DACLRCK,
output AUD_XCK,
input [31:0] inIR,
input key0,
input key1,
output		        		I2C_SCLK,
inout		          		I2C_SDAT,
input		          		TD_CLK27,
input flag,
input ir
);

/*reg y = 1'b1;
initial y = 1'b1;
integer a = 0;
wire z;
assign z = y;

always @ (posedge CLOCK_50, negedge ir) begin
	if (~ir) begin
		if (inIR[15:0] == 16'hFF00)
			if (inIR[31:16] == 16'hBB44) begin
				y = 1'b0; a = 10000000;
			end
	end
	else if (a > 0) begin a = a - 1; if (a == 0) y = 1'b1; end
end*/

wire			            I2C_END;
wire					      AUD_CTRL_CLK;
reg			 [31:0]		VGA_CLKo;

assign PS2_DAT2 = 1'b1;	
assign PS2_CLK2 = 1'b1;

assign AUD_ADCLRCK = AUD_DACLRCK;
assign AUD_XCK = AUD_CTRL_CLK;

//  TV DECODER ENABLE 
	
assign TD_RESET_N =1'b1;

//  I2C

	I2C_AV_Config 		u7	(	//	Host Side
								 .iCLK		( CLOCK_50),
								 .iRST_N		( key0 ),
								 .o_I2C_END	( I2C_END ),
								   //	I2C Side
								 .I2C_SCLK	( I2C_SCLK ),
								 .I2C_SDAT	( I2C_SDAT )	
								);

//  AUDIO PLL

	VGA_Audio_PLL 	u1	(	
							 .areset ( ~I2C_END ),
							 .inclk0 ( TD_CLK27 ),
							 .c1		( AUD_CTRL_CLK )	
							);

// Music Synthesizer Block //

// TIME & CLOCK Generater //

	assign keyboard_sysclk = VGA_CLKo[12];
	assign demo_clock      = VGA_CLKo[18]; 
	assign VGA_CLK         = VGA_CLKo[0];

	always @( posedge CLOCK_50 )
		begin
			VGA_CLKo <= VGA_CLKo + 1;
		end
								
// DEMO SOUND //

// DEMO Sound (CH1) //



	demo_sound1	dd1(
						 .clock   ( demo_clock ),
						 .key_code( demo_code1 ),
					    .k_tr    ( flag )
					   );

// DEMO Sound (CH2) //

	wire [7:0]demo_code2;

	demo_sound2	dd2(
						 .clock   ( demo_clock ),
						 .key_code( demo_code2 ),
						 .k_tr    ( flag )
						);

////////////Sound Select/////////////	

	wire [15:0]	sound1;
	wire [15:0]	sound2;
	wire [15:0]	sound3;
	wire [15:0]	sound4;
	wire 			sound_off1;
	wire 			sound_off2;
	wire 			sound_off3;
	wire 			sound_off4;

	wire [7:0]sound_code1 = /*( !SW[9] )? */demo_code1;/* : key1_code ; //SW[9]=0 is DEMO SOUND,otherwise key*/

	wire [7:0]sound_code2 = /*( !SW[9] )? */demo_code2;/* : key2_code ; //SW[9]=0 is DEMO SOUND,otherwise key*/

	wire [7:0]sound_code3 = 8'hf0;

	wire [7:0]sound_code4 = 8'hf0;

	staff st1(
		
			  // VGA output //
		
			 .VGA_CLK   		( VGA_CLK ),   
			 .vga_h_sync		( VGA_HS ), 
			 .vga_v_sync		( VGA_VS ), 
			 .vga_sync  		( VGA_SYNC_N ),	
			 .inDisplayArea	    ( VGA_BLANK_N ),
			 .vga_R				( VGA_R1 ), 
			 .vga_G				( VGA_G1 ), 
			 .vga_B				( VGA_B1 ),
		
			 // Key code-in //
		
			 .scan_code1		( sound_code1 ),
			 .scan_code2		( sound_code2 ),
			 .scan_code3      ( sound_code3 ), // OFF
			 .scan_code4		( sound_code4 ), // OFF
		
			 //Sound Output to Audio Generater//
		
			 .sound1				( sound1 ),
			 .sound2				( sound2 ),
			 .sound3				( sound3 ), // OFF
			 .sound4				( sound4 ), // OFF
		
			 .sound_off1		( sound_off1 ),
			 .sound_off2		( sound_off2 ),
			 .sound_off3		( sound_off3 ), //OFF
			 .sound_off4		( sound_off4 )	 //OFF	
	        );	
	
// 2CH Audio Sound output -- Audio Generater //

	adio_codec ad1	(	
	        
					// AUDIO CODEC //
		
					.oAUD_BCK 	( AUD_BCLK ),
					.oAUD_DATA	( AUD_DACDAT ),
					.oAUD_LRCK	( AUD_DACLRCK ),																
					.iCLK_18_4	( AUD_CTRL_CLK ),
			
					// KEY //
		
					.iRST_N	  	( key0 ),							
					.iSrc_Select( 2'b00 ),

					// Sound Control //

					.key1_on		( sound_off1 ),//CH1 ON / OFF		
					.key2_on		( sound_off2 ),//CH2 ON / OFF
					.key3_on		( 1'b0 ),			    	// OFF
					.key4_on		( 1'b0 ), 					// OFF							
					.sound1		( sound1 ),					// CH1 Freq
					.sound2		( sound2 ),					// CH2 Freq
					.sound3		( sound3 ),					// OFF,CH3 Freq
					.sound4		( sound4 ),					// OFF,CH4 Freq							
					.instru		( 1'b0 )  					// Instruction Select
					);

// TEST DeBUG

DeBUG_TEST 		u6	(
						 .iCLK(CLOCK_50),
						 .isound_off1(sound_off1),
						 .isound_off2(sound_off2),
						 .iRST_N(key0),
					 );

endmodule