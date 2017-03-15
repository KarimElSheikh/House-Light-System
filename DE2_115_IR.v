module DE2_115_IR (input CLOCK_50, IRDA_RXD, output wire [31:0] hex_data);

wire data_ready; //IR data_ready flag
//reg data_read; //read
//hex_data seg data input
wire clk50; //pll 50M output for irda

pll1 u0(
.inclk0(CLOCK_50),
//irda clock 50M
.c0(clk50),
.c1());

IR_RECEIVE u1(
///clk 50MHz////
.iCLK(clk50),
//reset
.iRST_n(1'b1),
//IRDA code input
.iIRDA(IRDA_RXD),
//read command
//.iREAD(data_read),
//data ready
.oDATA_READY(data_ready),
//decoded data 32bit
.oDATA(hex_data)
);

endmodule

	