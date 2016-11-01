// takes care of ALU operations for: ADD, SUB, AND, OR, pass input d2, NOR
//									 Shift right/extend, shift left
//			including subu, andu. They do the same as add and sub rgiht now

module execution(
	input wire[31:0] d1_in,
	input wire[31:0] d2_in,
	input wire[4:0] aluctrl,
	output wire[31:0] d1_out,
	output wire d2_out			// this is the zero flag.. is ONE if result is ZERO
	);
	if (aluctrl == 5'b00010) begin
		// add
		assign d1_out = d1_in + d2_in;

	end else if (aluctrl == 5'b00010) begin
		// addu THIS IS SUPPOSED TO SET SOME EXCEPTION FLAG???
		assign d1_out = d1_in + d2_in;

	end else if (aluctrl == 5'b00110) begin
		// sub
		assign d2_out = d1_in - d2_in ? 0 : 1; // set zero flag = 1 if result is 0
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

	end else if (aluctrl == 5'b01101) begin
		// shift left
		assign d1_out = d1_in << d2_in;

	end else if (aluctrl == 5'b01110) begin
		// shift right
		assign d1_out = d1_in >> d2_in;

	end else if (aluctrl == 5'b01111) begin
		// shift right, sign extend
		assign d1_out = d1_in >>> d2_in;

	end else if (aluctrl == 5'b10000) begin
		// slt -- set less than. R[rd] = (R[rs] < R[rt] ? 1 : 0
		assign d1_out = d1_in < d2_in ? 1 : 0;
		assign d2_out = d1_in < d2_in ? 1 : 0; // zero flag for branch on less than

	end
endmodule


