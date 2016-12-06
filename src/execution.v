// takes care of ALU operations for: ADD, SUB, AND, OR, pass input d2, NOR
//									 Shift right/extend, shift left
//			including subu, andu. They do the same as add and sub rgiht now

module execution(
	input wire[31:0] d1_in,
	input wire[31:0] d2_in,
    input wire[31:0] imm_in,
    input wire i_type,
	input wire[4:0] aluctrl,
	output reg[31:0] d1_out,
	output reg zero			// this is the zero flag.. is ONE if result is ZERO
	);
	
	wire signed [31:0] signed_d1_in;
	wire signed [31:0] signed_d2_in;
    wire signed [31:0] signed_imm_in;
	
	assign signed_d1_in = d1_in;
	assign signed_d2_in = d2_in;
    assign signed_imm_in = imm_in;
	
	always @(*) begin
		if (aluctrl == 5'b00010) begin
			// add
			if (i_type == 1'b1) begin
                d1_out <= d1_in + imm_in;
            end else begin
                d1_out <= d1_in + d2_in;
            end
			zero <= 0;
		end else if (aluctrl == 5'b00110) begin
			// sub
			if (i_type == 1'b1) begin
                zero <= d1_in - imm_in ? 1'b0: 1'b1;
                d1_out <= d1_in - imm_in;
            end else begin
                zero <= d1_in - d2_in ? 1'b0 : 1'b1; // set zero flag = 1 if result is 0
                d1_out <= d1_in - d2_in;
            end
		end else if (aluctrl == 5'b00000) begin
			// AND
			if (i_type == 1'b1) begin
                d1_out <= d1_in & imm_in;
            end else begin
                d1_out <= d1_in & d2_in;
            end
			zero <= 0;
		end else if (aluctrl == 5'b00001) begin
			// OR
			if (i_type == 1'b1) begin
                d1_out <= d1_in | imm_in;
            end else begin
                d1_out <= d1_in | d2_in;
            end
			zero <= 0;
		end else if (aluctrl == 5'b01100) begin
			// NOR
			if (i_type == 1'b1) begin
                d1_out <= ~(d1_in | imm_in);
            end else begin
                d1_out <= ~(d1_in | d2_in);
            end
			zero <= 0;
		end else if (aluctrl == 5'b00111) begin
			// pass input (either d2 or imm)
			if (i_type == 1'b1) begin
                d1_out <= imm_in;
            end else begin
                d1_out <= d2_in;
            end
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
			if (i_type) begin
                d1_out <= signed_d1_in < signed_imm_in ? 1 : 0;
                zero <= signed_d1_in < signed_imm_in ? 1'b1 : 1'b0; // zero flag for branch on less than
            end else begin
                d1_out <= signed_d1_in < signed_d2_in ? 1 : 0;
                zero <= signed_d1_in < signed_d2_in ? 1'b1 : 1'b0; // zero flag for branch on less than
            end
        end else if (aluctrl == 5'b10110) begin
            // BNE
            d1_out <= (d1_in != d2_in);
            zero <= (d1_in != d2_in);
        end else if (aluctrl == 5'b10010) begin
            // BEQ
            d1_out <= (d1_in == d2_in);
            zero <= (d1_in == d2_in);
        end else if (aluctrl == 5'b10011) begin
            // BGTZ
            d1_out <= (d1_in > 0);
            zero <= (d1_in > 0);
        end else if (aluctrl == 5'b10100) begin
            // BGEZ
            d1_out <= (d1_in >= 0);
            zero <= (d1_in >= 0);
        end else if (aluctrl == 5'b10101) begin
            // LUI
            d1_out <= (imm_in << 16);
            zero <= 0;
		end else begin
			d1_out <= 0;
			zero <= 1'b0;
		end
	end
endmodule


