module controller(input wire[5:0] op,
						input wire[5:0] func,
						input wire zero,
						input wire reset,
						output reg[6:0] muxctrl,
						output reg[2:0] memctrl,
						output reg[3:0] aluctrl
						);
// memctrl:
//  bit 0: reg write
//  bit 1: mem write
//  bit 2: mem read

// muxctrl:
//  bit 0: 
//  bit 1: mem_to_reg
//  bit 2:
//  bit 3:
//  bit 4:
//  bit 5:
//  bit 6:

// aluctrl:
//  0000 - AND
//  0001 - OR
//  0010 - add
//  0110 - subtract
//  0111 - pass input d2
//  1100 - NOR

	always @(*) begin
		if (reset == 1'b1) begin
			muxctrl <= 7'b0000000;
			memctrl <= 3'b000;
			aluctrl <= 4'b0000;
		end else if (op == 6'b000000 && func == 6'b100000) begin
            // ADD
			muxctrl <= 7'b0000010;
			memctrl <= 3'b001;
			aluctrl <= 4'b0010;
        end else if (op == 6'b000000 && func == 6'b100001) begin
            // ADDU
            muxctrl <= 7'b0000010;
            memctrl <= 3'b001;
            aluctrl <= 4'b0010;
        end else if (op == 6'b000000 && func =0 6'b100010) begin
            // SUB
            muxctrl <= 7'b0000010;
            memctrl <= 3'b001;
            aluctrl <= 4'b0110;
        end else if (op == 6'b000000 && func == 6'b100011) begin
            // LW
            muxctrl <= 7'b0000010;
            memctrl <= 3'b100;
            aluctrl <= 4'b0010;
		end else begin
			muxctrl <= 7'b0000000;
			memctrl <= 3'b000;
			aluctrl <= 4'b0000;
		end
	end

endmodule

