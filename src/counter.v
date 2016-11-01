module counter(
	input wire clock,
	input wire reset,
	input wire[31:0] next_pc,
	input wire pc_write,
	output reg[15:0] clock_count,
	output reg[31:0] prog_count
	);

	initial begin
		prog_count <= 0;
		clock_count <= 0;
	end
		
	always @(posedge clock or posedge reset) begin
		if (reset == 1'b1) begin
			// handle resets
			prog_count <= 0;
			clock_count <= 0;
		end else if (pc_write == 1'b1) begin
			// handle branches / jumps / normal incrementing
			prog_count <= next_pc;
			clock_count <= clock_count + 1;
		end else begin
			// handle bubbles
			prog_count <= prog_count;
			clock_count <= clock_count + 1;
		end
	end
endmodule
