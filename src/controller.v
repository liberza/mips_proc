module controller(input wire[5:0] op,
						input wire[5:0] func,
						input wire zero,
						input wire reset,
						output reg[15:0] muxctrl,
						output reg[2:0] memctrl,
						output reg[4:0] aluctrl
						);
// memctrl:
//  bit 0: reg write
//  bit 1: mem write
//  bit 2: mem read

// muxctrl:
//  bit 0: imm_src bit 0
//  bit 1: imm_src bit 1
//  bit 2: mem_to_reg
//  bit 3: reg2_loc bit 0
//  bit 4: reg2_loc mux bit 1
//  bit 5: bubble mux
//  bit 6: shamt or immediate mux
//  bit 7: jump
//  bit 8: alu_src
//  bit 9: branch
//  bit 10: jal

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
//  10010 - equal to
//  10011 - greater than zero
//  10100 - equal to zero
//  10101 - shift immediate 16 bits left

	always @(*) begin
		if (reset == 1'b1) begin
			muxctrl <= 16'b0000000000000000;
			memctrl <= 3'b000;
			aluctrl <= 5'b01101;
        //* R-TYPE *//
		end else if (op == 6'b000000 && func == 6'b100000) begin
           // ADD
			muxctrl <= 16'b0000000000000000;
			memctrl <= 3'b001;
			aluctrl <= 5'b00010;
        end else if (op == 6'b000000 && func == 6'b100001) begin
            // ADDU
            muxctrl <= 16'b0000000000000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b00010;
        end else if (op == 6'b000000 && func == 6'b100010) begin
            // SUB
            muxctrl <= 16'b0000000000000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b00110;
        end else if (op == 6'b000000 && func == 6'b100011) begin
            // SUBU
            muxctrl <= 16'b0000000000000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b00110;
        end else if (op == 6'b000000 && func == 6'b100100) begin
            // AND
            muxctrl <= 16'b0000000000000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b00000;
        end else if (op == 6'b000000 && func == 6'b100101) begin
            // OR
            muxctrl <= 16'b0000000000000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b00001;
        end else if (op == 6'b000000 && func == 6'b100111) begin
            // NOR
            muxctrl <= 16'b0000000000000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b01100;
        end else if (op == 6'b000000 && func == 6'b000000) begin
            // SLL (shift left logical)
            muxctrl <= 16'b0000000101000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b01101;
        end else if (op == 6'b000000 && func == 6'b000010) begin
            // SRL (shift right logical)
            muxctrl <= 16'b0000000101000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b01110;
        end else if (op == 6'b000000 && func == 6'b000011) begin
            // SRA (shift right arithmetic)
            muxctrl <= 16'b0000000101000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b01111;
        end else if (op == 6'b000000 && func == 6'b101010) begin
            // SLT (set less than)
            muxctrl <= 16'b0000000000000000;
            memctrl <= 3'b001;
            aluctrl <= 5'b10000;
        end else if (op == 6'b000000 && func == 6'b001000) begin
            // JR
            muxctrl <= 16'b0000100010000000;
            memctrl <= 3'b000;
            aluctrl <= 5'b01101;

        //* I-TYPE *//
		end else if (op == 6'b001100) begin
            // ANDI
            muxctrl <= 16'b0000000000000001;
            memctrl <= 3'b001;
            aluctrl <= 5'b00000;
		end else if (op == 6'b001101) begin
            // ORI
            muxctrl <= 16'b0000000000000001;
            memctrl <= 3'b001;
            aluctrl <= 5'b00001;
        end else if (op == 6'b001010) begin
            // SLTI
            muxctrl <= 16'b0000000000000001;
            memctrl <= 3'b001;
            aluctrl <= 5'b10000;
        end else if (op == 6'b001000) begin
            // ADDI
            muxctrl <= 16'b0000000000000001;
            memctrl <= 3'b001;
            aluctrl <= 5'b00010;
        end else if (op == 6'b001001) begin
            // ADDIU
            muxctrl <= 16'b0000000000000001;
            memctrl <= 3'b001;
            aluctrl <= 5'b00010;
        end else if (op == 6'b000100) begin
            // BEQ
            muxctrl <= 16'b0000001000000001;
            memctrl <= 3'b000;
            aluctrl <= 5'b10010;
        end else if (op == 6'b000101) begin
            // BNE
            muxctrl <= 16'b0000001000000001;
            memctrl <= 3'b000;
            aluctrl <= 5'b10110;
        end else if (op == 6'b000111) begin
            // BGTZ
            muxctrl <= 16'b0000001000000001;
            memctrl <= 3'b000;
            aluctrl <= 5'b10011;
        end else if (op == 6'b000001) begin
            // BGEZ
            muxctrl <= 16'b0000001000000001;
            memctrl <= 3'b000;
            aluctrl <= 5'b10111;
        end else if (op == 6'b100011) begin
            // LW
            muxctrl <= 16'b0000000000000101;
            memctrl <= 3'b101;
            aluctrl <= 5'b00010;
        end else if (op == 6'b101011) begin
            // SW
            muxctrl <= 16'b0000000000000001;
            memctrl <= 3'b010;
            aluctrl <= 5'b00010;
        end else if (op == 6'b001111) begin
            // LUI
            muxctrl <= 16'b0000000000000001;
            memctrl <= 3'b001;
            aluctrl <= 5'b10101;

        //* J-TYPE *//
        end else if (op == 6'b000010) begin
            // J
            muxctrl <= 16'b0000000010000010;
            memctrl <= 3'b000;
            aluctrl <= 5'b01101;
        end else if (op == 6'b000011) begin
            // JAL
            muxctrl <= 16'b0000010010000010;
            memctrl <= 3'b001;
            aluctrl <= 5'b01101;
        end else begin
            // NOOP
			muxctrl <= 16'b0000000000000000;
			memctrl <= 3'b000;
			aluctrl <= 5'b01101;
        end
    end
endmodule

