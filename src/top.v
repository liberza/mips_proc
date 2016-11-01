module top(
    input wire[17:0] SW,		// toggle switches

    input wire[2:0] KEY,		// manual clock / reset
    input wire CLOCK_50,
	 output wire[17:0] LEDR,
    output wire[7:0] LEDG,
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

    // ==========================
    // Clock/reset initialization
    // ==========================
    wire clock;	// either manual or system clock
    wire clock_debug;
    wire clk_100hz, clk_1hz;
    wire manual_clock;
    wire manual_clock_debug;
    wire reset;

    // configure clock.
    clk_div clk_div1(CLOCK_50,,,,,clk_100hz,,clk_1hz);

    // configure pushbuttons. debounce and pulse-ify.
    debounce db3(KEY[2], clk_100hz, manual_clock_debug);
    debounce db2(KEY[1], clk_100hz, manual_clock);
    debounce db1(KEY[0], clk_100hz, reset);

    // allow switching between manual and system clock with SW17.
    assign clock = ((SW[17] && manual_clock) || (~SW[17] && clk_1hz));
    assign clock_debug = (clock || manual_clock_debug);

    // =================
    // Instruction fetch
    // =================
    wire[15:0] cc;	// clock counter
    wire[15:0] pc;	// program counter
    wire[31:0] rom_out;
    wire[31:0] rom_out_dbg;
    wire[31:0] instr;
    wire[15:0] pc_offset;
    wire bubble;

    // set up program counter and clock counter
    counter counter_inst(clock, reset, pc_offset, bubble, cc, pc);

    // set up instruction memory access
    // negate clock to make memory do stuff on falling edge
    instr_mem rom(pc,SW[14:10]*4,~clock,~clock_debug,rom_out,rom_out_dbg);

    pipeline IF_ID(clock,reset,rom_out,,,,,,,,instr);

    // ==================
    // Instruction decode
    // ==================
    wire[31:0] reg_out1;
    wire[31:0] reg_out2;
    wire[31:0] reg_out_dbg;
    wire[6:0] id_muxctrl;
    wire[2:0] id_memctrl;
    wire[3:0] id_aluctrl;

    // setup controller. combinational logic.
    controller(instr[31:26], instr[6:0], alu_zero, reset, id_muxctrl, id_memctrl, id_aluctrl);

    bubbler(instr[25:21], instr[20:16], ex_rd, ex_memctrl[2], bubble, pc_offset);

    assign LEDR[17] = bubble;

	 //assign lcd_line2 = wb_out;

    // register file instance
    register_file regfile(instr[25:21],
                          instr[20:16],
                          wb_out,
                          wb_rd,
                          wb_memctrl[0],
                          reset,
                          clock,
                          SW[4:0],
                          clock_debug,
                          reg_out1,
                          reg_out2,
                          reg_out_dbg);

    // ==================
    // Execution
    // ==================
    wire[31:0] ex_d1_in, ex_d2_in, ex_d1_out;
    wire ex_zero;
    wire[31:0] alu_d1, alu_d2;
    wire[4:0] ex_rs, ex_rt, ex_rd;
    wire[6:0] ex_muxctrl;
    wire[2:0] ex_memctrl;
    wire[3:0] ex_aluctrl;
    wire[1:0] fwd_d1_ctrl, fwd_d2_ctrl;

    pipeline ID_EX(clock, reset,
                   reg_out1, reg_out2, instr[25:21], instr[20:16], instr[15:11], id_muxctrl, id_memctrl, id_aluctrl,
                   ex_d1_in, ex_d2_in, ex_rs, ex_rt, ex_rd, ex_muxctrl, ex_memctrl, ex_aluctrl);

    assign LEDR[16:13] = ex_aluctrl[3:0];

    // Forward values if we have a RAW
    forwarder fwd(wb_rd, mem_rd, ex_rs, ex_rt, fwd_d1_ctrl, fwd_d2_ctrl);

    mux3 d1_mux(fwd_d1_ctrl[0], fwd_d1_ctrl[1], ex_d1_in, mem_addr_in, wb_out, alu_d1);
    mux3 d2_mux(fwd_d2_ctrl[0], fwd_d2_ctrl[1], ex_d2_in, mem_addr_in, wb_out, alu_d2);

    execution(alu_d1, alu_d2, ex_aluctrl, ex_d1_out, ex_zero);

    // =============
    // Memory access
    // =============
    wire[31:0] mem_data_in;
    wire[31:0] mem_addr_in;
    wire[31:0] mem_data_out;
    wire[4:0] mem_rs;
    wire[4:0] mem_rt;
    wire[4:0] mem_rd;
    wire[6:0] mem_muxctrl;
    wire[2:0] mem_memctrl;
    wire[31:0] ram_out;
    wire[31:0] ram_out_dbg;

    pipeline EX_MEM(clock, reset,
                    ex_d1_out, alu_d2, ex_rs, ex_rt, ex_rd, ex_muxctrl, ex_memctrl,,
                    mem_addr_in, mem_data_in, mem_rs, mem_rt, mem_rd, mem_muxctrl, mem_memctrl );

    // set up data memory access
    // negate clock to make memory do stuff on falling edge
    data_mem ram(mem_addr_in,SW[9:5]*4,~clock,~clock_debug,mem_data_in,,mem_memctrl[1],,ram_out,ram_out_dbg);

    // ==========
    // Write-back
    // ==========
    wire[31:0] wb_d1_in, wb_d2_in, wb_d1_out, wb_d2_out, wb_out;
    wire[4:0] wb_rs, wb_rt, wb_rd;
    wire[6:0] wb_muxctrl;
    wire[2:0] wb_memctrl;

    assign LEDG[6:0] = wb_muxctrl[6:0];
    assign LEDR[2:0] = wb_memctrl[2:0];

    pipeline MEM_WB(clock, reset,
                    ram_out, mem_addr_in, mem_rs, mem_rt, mem_rd,mem_muxctrl,mem_memctrl,,
                    wb_d1_out, wb_d2_out, wb_rs, wb_rt, wb_rd,wb_muxctrl,wb_memctrl);

    mux2(wb_muxctrl[1], wb_d2_out, wb_d1_out, wb_out);

    //assign lcd_line2 = wb_d2_out;

    // ==============
    // User interface
    // ==============
    wire[31:0] lcd_line1;
    wire[31:0] lcd_line2;
    wire[3:0] digit0;
    wire[3:0] digit1;
    wire[3:0] digit2;
    wire[3:0] digit3;
    wire[3:0] digit4;
    wire[3:0] digit5;
    wire[3:0] digit6;
    wire[3:0] digit7;

	 wire[31:0] fake_lcd;

    // handle ui using combinational logic, so it updates as fast as it can.
    ui_handler ui_inst(SW, reset, cc, pc, reg_out_dbg, rom_out_dbg, ram_out_dbg,
                       lcd_line2, digit7, digit6, digit5, digit4, digit3, digit2, digit1, digit0);

    // lcd_line1 is always rom_out.
    assign lcd_line1 = rom_out;

    // pull LCD_ON and LCD_BLON high.
    assign LCD_ON = 1;
    assign LCD_BLON = 1;

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
