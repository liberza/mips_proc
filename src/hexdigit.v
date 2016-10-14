// file hexdigit.v
module hexdigit(
	input wire[3:0] in,
	output reg[6:0] out);
	
	always @* begin
		if (in == 4'h0) begin
			out = ~7'b0111111;
			
		end else if (in == 4'h1) begin
			out = ~7'b0000110;
			
		end else if (in == 4'h2) begin
			out = ~7'b1011011;
			
		end else if (in == 4'h3) begin
			out = ~7'b1001111;
			
		end else if (in == 4'h4) begin
			out = ~7'b1100110;
			
		end else if (in == 4'h5) begin
			out = ~7'b1101101;
			
		end else if (in == 4'h6) begin
			out = ~7'b1111101;
			
		end else if (in == 4'h7) begin
			out = ~7'b0000111;
			
		end else if (in == 4'h8) begin
			out = ~7'b1111111;
			
		end else if (in == 4'h9) begin
			out = ~7'b1101111;
		
		end else if (in == 4'hA) begin
			out = ~7'b1110111;
			
		end else if (in == 4'hB) begin
			out = ~7'b1111100;
			
		end else if (in == 4'hC) begin
			out = ~7'b0111001;
			
		end else if (in == 4'hD) begin
			out = ~7'b1011110;
			
		end else if (in == 4'hE) begin
			out = ~7'b1111001;
			
		end else if (in == 4'hF) begin
			out = ~7'b1110001;
		end else begin
			out = ~7'b1001001;
		end
	end
endmodule
