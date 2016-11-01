module sign_extender(input wire[15:0] a, output reg[31:0] b);

	always @(*) begin
		b <= $signed(a);
	end

endmodule
