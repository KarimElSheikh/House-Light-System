module seven_segment_decoder2(output reg [6:0] segments, input [3:0] num);

always @ (num)
	case (num)
		0: segments <= ~7'b0111111;
		1: segments <= ~7'b0000110;
		2: segments <= ~7'b1011011;
		3: segments <= ~7'b1001111;
		4: segments <= ~7'b1100110;
		5: segments <= ~7'b1101101;
		6: segments <= ~7'b1111101;
		7: segments <= ~7'b0000111;
		8: segments <= ~7'b1111111;
		9: segments <= ~7'b1101111;
		10: segments <= ~7'b1110111;
		11: segments <= ~7'b1111100;
		12: segments <= ~7'b0111001;
		13: segments <= ~7'b1011110;
		14: segments <= ~7'b1111001;
		15: segments <= ~7'b1110001;
		default: segments <= ~7'b0000000;
	endcase

endmodule