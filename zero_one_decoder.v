module zero_one_decoder(output reg [6:0] segments, input bit);

always @ (bit)
	case (bit)
		1'b0: segments <= ~7'b0111111;
		1'b1: segments <= ~7'b0000110;
		default: segments <= ~7'b0000000;
	endcase

endmodule