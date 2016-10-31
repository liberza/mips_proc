module execution(
	input wire[31:0] d1_in,
	input wire[31:0] d2_in,
	input wire[3:0] aluctrl,
	output wire[31:0] d1_out,
	output wire[31:0] d2_out
	);

	assign d2_out = d1_in + d2_in;

endmodule
