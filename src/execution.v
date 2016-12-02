// takes care of ALU operations for: ADD, SUB, AND, OR, pass input d2, NOR
//									 Shift right/extend, shift left
//			including subu, andu. They do the same as add and sub rgiht now

module execution(
	input wire[31:0] d1_in,
	input wire[31:0] d2_in,
    input wire[31:0] imm_in,
	input wire[4:0] aluctrl,
	output reg[31:0] d1_out,
	output reg zero			// this is the zero flag.. is ONE if result is ZERO
	);
	
	wire signed [31:0] signed_d1_in;
	wire signed [31:0] signed_d2_in;
	
	assign signed_d1_in = d1_in;
	assign signed_d2_in = d2_in;
	
	always @(*) begin
		if (aluctrl == 5'b00010) begin
			// add
			d1_out <= d1_in + d2_in;
			zero <= 0;
		end else if (aluctrl == 5'b00010) begin
			// addu THIS IS SUPPOSED TO SET SOME EXCEPTION FLAG???
			d1_out <= d1_in + d2_in;
			zero <= 0;
		end else if (aluctrl == 5'b00110) begin
			// sub
			zero <= d1_in - d2_in ? 1'b0 : 1'b1; // set zero flag = 1 if result is 0
			d1_out <= d1_in - d2_in;

		end else if (aluctrl == 5'b00110) begin
			// subu SAME WEIRD EXCEPTION STUFF
			d1_out <= d1_in - d2_in;
			zero <= 0;
		end else if (aluctrl == 5'b00000) begin
			// AND
			d1_out <= d1_in & d2_in;
			zero <= 0;
		end else if (aluctrl == 5'b00001) begin
			// OR
			d1_out <= d1_in | d2_in;
			zero <= 0;
		end else if (aluctrl == 5'b01100) begin
			// NOR
			d1_out <= ~(d1_in | d2_in);
			zero <= 0;
		end else if (aluctrl == 5'b00111) begin
			// pass input d2
			d1_out <= d2_in;
			zero <= 0;
		end else if (aluctrl == 5'b01101) begin
			// shift left
			d1_out <= (d2_in << imm_in);
			zero <= 0;
		end else if (aluctrl == 5'b01110) begin
			// shift right
			d1_out <= (d2_in >> imm_in);
			zero <= 0;
		end else if (aluctrl == 5'b01111) begin
			// shift right, sign extend
			d1_out <= (d2_in >>> imm_in);
			zero <= 0;
		end else if (aluctrl == 5'b10000) begin
			// slt -- set less than. R[rd] = (R[rs] < R[rt] ? 1 : 0
			d1_out <= signed_d1_in < signed_d2_in ? 1 : 0;
			zero <= signed_d1_in < signed_d2_in ? 1'b1 : 1'b0; // zero flag for branch on less than
		end else begin
			d1_out <= 0;
			zero <= 1'b0;
		end
	end
endmodule


