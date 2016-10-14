module counter(
	input wire clock,
	input wire reset,
	input wire signed[15:0] pc_offset,
	input wire pc_src,
	output reg[15:0] clock_count,
	output reg[15:0] prog_count
	);

	initial begin
		prog_count = 0;
		clock_count = 0;
	end
		
	always @(posedge clock or posedge reset) begin
		if (reset == 1'b1) begin
			// handle resets
			prog_count <= 0;
			clock_count <= 0;
		end else if (pc_src == 1'b1) begin
			// handle branches / jumps
			prog_count <= prog_count + 4 + pc_offset;
			clock_count <= clock_count + 1;
		end else begin
			// handle normal incrementing of pc and cc
			prog_count <= prog_count + 4;
			clock_count <= clock_count + 1;
		end
	end
endmodule
