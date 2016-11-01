module pipeline(
	input wire clock,
	input wire reset,
	input wire[31:0] d1_in,
	input wire[31:0] d2_in,
	input wire[4:0] rs_in,
	input wire[4:0] rt_in,
	input wire[4:0] rd_in,
	input wire[15:0] muxctrl_in,
	input wire[2:0] memctrl_in,
	input wire[3:0] aluctrl_in,
	output reg[31:0] d1_out,
	output reg[31:0] d2_out,
	output reg[4:0] rs_out,
	output reg[4:0] rt_out,
	output reg[4:0] rd_out,
	output reg[15:0] muxctrl_out,
	output reg[2:0] memctrl_out,
	output reg[3:0] aluctrl_out
	);

	always @(posedge clock) begin
		if (reset == 1'b1) begin
			d1_out <= 0;
			d2_out <= 0;
			rd_out <= 0;
			rs_out <= 0;
			rt_out <= 0;
			muxctrl_out <= 0;
			memctrl_out <= 0;
			aluctrl_out <= 0;
		end else begin
			d1_out <= d1_in;
			d2_out <= d2_in;
			rd_out <= rd_in;
			rs_out <= rs_in;
			rt_out <= rt_in;
			muxctrl_out <= muxctrl_in;
			memctrl_out <= memctrl_in;
			aluctrl_out <= aluctrl_in;
		end
	end
endmodule
