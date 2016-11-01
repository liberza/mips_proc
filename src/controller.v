module controller(input wire[5:0] op,
						input wire[5:0] func,
						input wire zero,
						input wire reset,
						output reg[6:0] muxctrl,
						output reg[2:0] memctrl,
						output reg[4:0] aluctrl
						);
// memctrl:
//  bit 0: reg write
//  bit 1: mem write
//  bit 2: mem read

// muxctrl:
//  bit 0: ALU_src
//  bit 1: mem_to_reg
//  bit 2: reg input mux bit 0
//  bit 3: reg input mux bit 1
//  bit 4: bubble mux
//  bit 5: shamt or immediate mux
//  bit 6: jump

// aluctrl:
//  00000 - AND
//  00001 - OR
//  00010 - add
//  00110 - subtract
//  00111 - pass input d2
//  01100 - NOR
//  01101 - shift left
//  01110 - shift right
//  01111 - shift right, sign extend
//  10000 - less than
//  10001 - less than or equal to

	always @(*) begin
		if (reset == 1'b1) begin
			muxctrl <= 7'b0000000;
			memctrl <= 3'b000;
			aluctrl <= 5'b00000;
		end else if (op == 6'b000000 && func == 6'b100000) begin
            // ADD
			muxctrl <= 7'b0000000;
			memctrl <= 3'b001;
			aluctrl <= 5'b00010;
        end else if (op == 6'b000000 && func == 6'b100001) begin
            // ADDU
            muxctrl <= 7'b0000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b00010;
        end else if (op == 6'b000000 && func == 6'b100010) begin
            // SUB
            muxctrl <= 7'b0000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b00110;
        end else if (op == 6'b000000 && func == 6'b100011) begin
            // SUBU
            muxctrl <= 7'b0000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b00110;
        end else if (op == 6'b000000 && func == 6'b100011) begin
            // AND
            muxctrl <= 7'b0000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b00000;
        end else if (op == 6'b000000 && func == 6'b100011) begin
            // OR
            muxctrl <= 7'b0000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b00001;
        end else if (op == 6'b000000 && func == 6'b100011) begin
            // NOR
            muxctrl <= 7'b0000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b01100;
        end else if (op == 6'b000000 && func == 6'b000000) begin
            // SLL
            muxctrl <= 7'b0000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b01101;
        end else if (op == 6'b000000 && func == 6'b000010) begin
            // SRL
            muxctrl <= 7'b0000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b01110;
        end else if (op == 6'b000000 && func == 6'b000011) begin
            // SRA
            muxctrl <= 7'b0000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b01111;
        end else if (op == 6'b000000 && func == 6'b101010) begin
            // SLT
            muxctrl <= 7'b0000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b10000;
        end else if (op == 6'b000000 && func == 6'b101010) begin
            // JR
            muxctrl <= 7'b1000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b01101;
        end else if (op == 6'b000000 && func == 6'b100011) begin
            // LW
            muxctrl <= 7'b0000010;
            memctrl <= 3'b100;
            aluctrl <= 5'b00010;
		end else begin
            // NOOP
			muxctrl <= 7'b0000000;
			memctrl <= 3'b000;
			aluctrl <= 5'b01101;
		end
	end

endmodule

