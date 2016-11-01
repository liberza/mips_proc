// takes care of ALU operations for: ADD, SUB, AND, OR, pass input d2, NOR
//			including subu, andu
// according to page 313, these are all that's needed

module execution(
	input wire[31:0] d1_in,
	input wire[31:0] d2_in,
	input wire[3:0] aluctrl,
	output wire[31:0] d1_out,
	output wire d2_out
	);
	if (aluctrl == 4'b0010) begin
		// add
		assign d1_out = d1_in + d2_in;

	end else if (aluctrl == 4'b0010) begin
		// addu THIS IS SUPPOSED TO SET SOME EXCEPTION FLAG???
		assign d1_out = d1_in + d2_in;

	end else if (aluctrl == 4'b0110) begin
		// sub
		assign d1_out = d1_in - d2_in;

	end else if (aluctrl == 4'b0110) begin
		// subu SAME WEIRD EXCEPTION STUFF
		assign d1_out = d1_in - d2_in;

	end else if (aluctrl == 4'b0000) begin
		// AND
		assign d1_out = d1_in & d2_in;

	end else if (aluctrl == 4'b0001) begin
		// OR
		assign d1_out = d1_in | d2_in;

	end else if (aluctrl == 4'b1100) begin
		// NOR
		assign d1_out = d1_in ~| d2_in;
	end else if (aluctrl == 4'b0111) begin
		// pass input d2
		assign d1_out = d2_in;
	end
endmodule
