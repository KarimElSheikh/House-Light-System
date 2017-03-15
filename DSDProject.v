module DSDProject (
output [6:0] segments0, segments1, segments2, segments3,
segments4, segments5, segments6, segments7,
output reg [3:0] led,
output AUD_DACDAT, AUD_XCK,
input x, y, key0, key1, key2, key3, clk, clk2, ir, ps2_data, ps2_clk, AUD_ADCDAT,
inout AUD_ADCLRCK, AUD_BCLK, AUD_DACLRCK,
output		        		I2C_SCLK,
inout		          		I2C_SDAT,
input TD_CLK27);

DE2_115_Synthesizer DEAUDIO (clk, clk2, AUD_ADCDAT, AUD_ADCLRCK, AUD_BCLK, AUD_DACDAT, AUD_DACLRCK, AUD_XCK, inIR, key0, key1, I2C_SCLK, I2C_SDAT, TD_CLK27, flag, ir);

parameter s0 = 4'b0000, s1 = 4'b0001, s2 = 4'b0010, s3 = 4'b0011,
s4 = 4'b0100, s5 = 4'b0101, s6 = 4'b0110, s7 = 4'b0111;

reg flag = 1'b1;
reg [3:0] state;
integer count = 0, n = 0, a = 0;
assign c0 = count % 10;
assign c1 = count / 10;
wire [7:0] inKB; //key0board
wire [3:0] c0, c1;
wire [31:0] inIR; //infrared input

kb1 KB (clk, ps2_data, ps2_clk, inKB);
DE2_115_IR IR0 (clk, ir, inIR);

//seven segments order Left-to-Right: 7, 4, 2, 3, 6, 5, 1, 0

zero_one_decoder M7 (segments7, x);
zero_one_decoder M4 (segments4, y);
seven_segment_decoder M2 (segments2, 4'b1010);
seven_segment_decoder M3 (segments3, state);
//zero_one_decoder M6 (segments6, flag);
seven_segment_decoder M6 (segments6, n);
seven_segment_decoder M5 (segments5, 4'b1010);
seven_segment_decoder M1 (segments1, c1);
seven_segment_decoder M0 (segments0, c0);

/*seven_segment_decoder2 M0 (segments0, inIR[3:0]);
seven_segment_decoder2 M1 (segments1, inIR[7:4]);
seven_segment_decoder2 M5 (segments5, inIR[11:8]);
seven_segment_decoder2 M6 (segments6, inIR[15:12]);
seven_segment_decoder2 M3 (segments3, inIR[19:16]);
seven_segment_decoder2 M2 (segments2, inIR[23:20]);
seven_segment_decoder2 M4 (segments4, inIR[27:24]);
seven_segment_decoder2 M7 (segments7, inIR[31:28]);*/

initial begin
	state = s0;
end

always @ (n)
	case (n)
		1: led = 4'b0000;
		2: led = 4'b0001;
		3: led = 4'b0011;
		4: led = 4'b0111;
		5: led = 4'b1111;
		default: led = 4'b0000;
	endcase
		
always @ (posedge clk) begin
	if (~ir) begin
		if (count > 0 && inIR[15:0] == 16'hFF00)
			case (inIR[31:16])
				16'hF30C: n = 1;
				16'hE718: n = 2;
				16'hA15E: n = 3;
				16'hF708: n = 4;
				16'hE31C: n = 5;
				16'hA55A: flag <= 1'b0;
				16'hBD42: flag <= 1'b1;
			endcase
	end
	else if (~key3)
		begin
			state = s0;
			count = 0;
			n = 0;
		end
	else begin
		//if (a > 0) begin a = a - 1; if (a == 0) flag2 = 1'b1; end
		case (state)
			s0: if (~x) state = s1; else if (~y) state = s4;
			s1: if (x) state = s2;
			s2: if (~y) state = s3;
			s3: if (y) begin state = s0; if (count != 99) count = count + 1; if (count == 1) n = 3; end
			s4: if (y) state = s5;
			s5: if (~x) state = s6;
			default: if (x) begin state = s0; if (count != 0) count = count - 1; if (count == 0) n = 0; end
		endcase
	end
end

endmodule