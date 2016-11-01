// takes care of ALU operations for: ADD, SUB, AND, OR, pass input d2, NOR
//			including subu, andu
// according to page 313, these are all that's needed

module execution(
	input wire[31:0] d1_in,
	input wire[31:0] d2_in,
	input wire[4:0] aluctrl,
	output wire[31:0] d1_out,
	output wire d2_out			// this is the zero flag
	);
	if (aluctrl == 5'b00010) begin
		// add
		assign d1_out = d1_in + d2_in;

	end else if (aluctrl == 5'b00010) begin
		// addu THIS IS SUPPOSED TO SET SOME EXCEPTION FLAG???
		assign d1_out = d1_in + d2_in;

	end else if (aluctrl == 5'b00110) begin
		// sub
		assign d1_out = d1_in - d2_in;

	end else if (aluctrl == 5'b00110) begin
		// subu SAME WEIRD EXCEPTION STUFF
		assign d1_out = d1_in - d2_in;

	end else if (aluctrl == 5'b00000) begin
		// AND
		assign d1_out = d1_in & d2_in;

	end else if (aluctrl == 5'b00001) begin
		// OR
		assign d1_out = d1_in | d2_in;

	end else if (aluctrl == 5'b01100) begin
		// NOR
		assign d1_out = d1_in ~| d2_in;

	end else if (aluctrl == 5'b00111) begin
		// pass input d2
		assign d1_out = d2_in;

	end
endmodule

01101 - shift left
01110 - shift right
01111 - shift right, sign extend
