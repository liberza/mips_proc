module top(
	input wire[17:0] SW,		// toggle switches
	input wire[1:0] KEY,		// manual clock / reset
	input wire CLOCK_50,
	// hex LEDS
	output wire[6:0] HEX0,
	output wire[6:0] HEX1,
	output wire[6:0] HEX2,
	output wire[6:0] HEX3,
	output wire[6:0] HEX4,
	output wire[6:0] HEX5,
	output wire[6:0] HEX6,
	output wire[6:0] HEX7,
	// LCD outputs
	output wire[7:0] LCD_DATA,
	output wire LCD_RW,
	output wire LCD_EN,
	output wire LCD_RS,
	output wire LCD_ON,
	output wire LCD_BLON);
	
	// ====================================================
	// wires used throughout the top-level of the processor
	// ====================================================
	wire clock;	// either manual or system clock
	wire clk_100hz, clk_1hz;
	wire[15:0] cc;	// clock counter
	wire[15:0] pc;	// program counter
	wire manual_clock;
	wire manual_clock_db;
	wire reset;
	wire reset_db;
	wire[3:0] digit0;
	wire[3:0] digit1;
	wire[3:0] digit2;
	wire[3:0] digit3;
	wire[3:0] digit4;
	wire[3:0] digit5;
	wire[3:0] digit6;
	wire[3:0] digit7;
		
	wire[31:0] lcd_line1;
	wire[31:0] lcd_line2;
	
	wire[31:0] ram_out;
	wire[31:0] ram_out_dbg;
	wire[31:0] rom_out;
	wire[31:0] rom_out_dbg;
	wire[31:0] reg_out1;
	wire[31:0] reg_out2;
	wire[31:0] reg_out_dbg;

	// pull LCD_ON and LCD_BLON high.
	assign LCD_ON = 1;
	assign LCD_BLON = 1;
	
	// configure clock.
	clk_div clk_div1(CLOCK_50,,,,,clk_100hz,,clk_1hz);

	// configure pushbuttons. debounce and pulse-ify.
	debounce db1(KEY[1], clk_100hz, manual_clock);
	//onepulse op1(manual_clock_db, clk_1hz, manual_clock);
	debounce db2(KEY[0], clk_100hz, reset_db);
	onepulse op2(reset_db, clk_1hz, reset);
	
	// allow switching between manual and system clock with SW17.
	assign clock = ((SW[17] && manual_clock) || (~SW[17] && clk_1hz));
	
	// set up instruction memory access
	instr_mem rom(SW[14:10]*4,SW[14:10]*4,clock,clock,rom_out,rom_out_dbg);
	
	// set up data memory access
	data_mem ram(SW[9:5]*4,SW[9:5]*4,clock,clock,,,,,ram_out,ram_out_dbg);
	
	// lcd_line1 is always rom_out.
	assign lcd_line1 = rom_out;

	// register file instance
	register_file regfile(SW[4:0],,,,,reset,clock,SW[4:0],clock,reg_out1,reg_out2,reg_out_dbg);
	
	// set up program counter and clock counter
	counter(clock, reset, cc, pc);

	// handle ui using combinational logic, so it updates faster than the 1hz clock.
	ui_handler(SW, reset, cc, pc, reg_out_dbg, rom_out_dbg, ram_out_dbg, 
					lcd_line2, digit7, digit6, digit5, digit4, digit3, digit2, digit1, digit0);

	// create LCD driver instance
	LCD_Display lcd_driver(~reset, CLOCK_50, lcd_line1, lcd_line2, LCD_RS, LCD_EN, LCD_RW, LCD_DATA);

	// Create hexdigit instances.
	hexdigit h0(digit0, HEX0);
	hexdigit h1(digit1, HEX1);
	hexdigit h2(digit2, HEX2);
	hexdigit h3(digit3, HEX3);
	hexdigit h4(digit4, HEX4);
	hexdigit h5(digit5, HEX5);
	hexdigit h6(digit6, HEX6);
	hexdigit h7(digit7, HEX7);
	
endmodule
