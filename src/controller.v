module controller(input wire[5:0] op,
						input wire[5:0] func,
						input wire zero,
						input wire reset,
						output reg[6:0] muxctrl,
						output reg[1:0] memctrl,
						output reg[2:0] aluctrl
						);
	always @(*) begin 
		if (reset == 1'b1) begin
			muxctrl <= 7'b0000000;
			memctrl <= 2'b00;
			aluctrl <= 3'b000;
		end else if (op == 6'b000000 && func == 6'b100000) begin
			muxctrl <= 7'b0000000;
			memctrl <= 2'b01;
			aluctrl <= 3'b000;
		end else begin
			muxctrl <= 7'b0000000;
			memctrl <= 2'b00;
			aluctrl <= 3'b000;
		end
	end
	
endmodule
	