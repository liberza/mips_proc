module controller(input wire[5:0] op,
						input wire[5:0] func,
						input wire zero,
						input wire reset,
						output reg[6:0] muxctrl,
						output reg[2:0] memctrl,
						output reg[2:0] aluctrl
						);
	always @(*) begin 
		if (reset == 1'b1) begin
			muxctrl <= 7'b0000000;
			memctrl <= 3'b000;
			aluctrl <= 3'b000;
		end else if (op == 6'b000000 && func == 6'b100000) begin
            // add
			muxctrl <= 7'b0000010;
			memctrl <= 3'b001;
			aluctrl <= 3'b010;
        end else if (op == 6'b000000 && func == 6'b100011) begin
            // lw
            muxctrl <= 7'b0000010;
            memctrl <= 3'b100;
            aluctrl <= 3'b010;
		end else begin
			muxctrl <= 7'b0000000;
			memctrl <= 3'b000;
			aluctrl <= 3'b000;
		end
	end
	
endmodule
	
