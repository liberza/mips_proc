module ui_handler(input wire[17:0] SW,
	input wire reset,
	input wire[15:0] clock_counter,
	input wire[15:0] pc,
	input wire[31:0] reg_out,
	input wire[31:0] rom_out,
	input wire[31:0] ram_out,
	
	output reg[31:0] lcd_data,
	output reg[3:0] digit7,
	output reg[3:0] digit6,
	output reg[3:0] digit5,
	output reg[3:0] digit4,
	output reg[3:0]digit3,
	output reg[3:0] digit2,
	output reg[3:0] digit1,
	output reg[3:0] digit0);
	
	reg[7:0] addr;
	
	always @(*) begin
		if (reset == 1'b1) begin
			digit0 <= 0;
			digit1 <= 0;
			digit2 <= 0;
			digit3 <= 0;
			digit4 <= 0;
			digit5 <= 0;
			digit6 <= 0;
			digit7 <= 0;
			lcd_data <= 0;
			addr <= 0;
		end else begin
			// Figure out what to put on the LCD
			if (SW[16:15] == 1'b00) begin	// register
				//LCD_DATA1 <= SW[4:0];
				addr <= SW[4:0]*4;
				lcd_data <= reg_out;
			end else if (SW[16:15] == 1'b01) begin	// data
				//LCD_DATA1 <= SW[9:5]*4;
				addr <= SW[9:5]*4;
				lcd_data <= ram_out;
			end else begin	// instruction
				//LCD_DATA1 <= program_counter;
				addr <= SW[14:10]*4;
				lcd_data <= rom_out;
			end
			// set hex values.
			// address to display
			digit7 <= addr[7:4];
			digit6 <= addr[3:0];

			// program counter
			digit5 <= pc[7:4];
			digit4 <= pc[3:0];

			// clock counter
			digit3 <= clock_counter[15:12];
			digit2 <= clock_counter[11:8];
			digit1 <= clock_counter[7:4];
			digit0 <= clock_counter[3:0];
		end
	end
endmodule
