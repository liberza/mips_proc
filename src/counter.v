module counter(
	input wire clock,
	input wire reset,
	output reg[15:0] clock_count,
	output reg[15:0] prog_count);

	initial begin
		prog_count = 0;
		clock_count = 0;
	end
		
	always @(posedge clock or posedge reset) begin
		if (reset == 1'b1) begin
			prog_count <= 0;
			clock_count <= 0;
		end else begin
			prog_count <= prog_count + 4;
			clock_count <= clock_count + 1;
		end
	end
endmodule
