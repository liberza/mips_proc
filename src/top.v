module top(
    input wire[17:0] SW,		// toggle switches

    input wire[3:0] KEY,		// manual clock / reset
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
    debounce db1(KEY[3], clk_100hz, reset);
    debounce db3(KEY[2], clk_100hz, manual_clock_debug);
    debounce db2(KEY[1], clk_100hz, manual_clock);

    // allow switching between manual and system clock with SW17.
    assign clock = ((SW[17] && manual_clock) || (~SW[17] && clk_1hz));
    assign clock_debug = (clock || manual_clock_debug);

    // =================
    // Instruction fetch
    // =================
    wire[15:0] cc;	// clock counter
    wire[32:0] pc;	// program counter
    wire[31:0] rom_out;
    wire[31:0] rom_out_dbg;
    wire[31:0] instr;
    wire[32:0] next_pc;
    wire bubble;

    // set up program counter and clock counter
    counter counter_inst(clock, reset, next_pc, ~bubble, cc, pc);

    // set up instruction memory access
    // negate clock to make memory do stuff on falling edge
    instr_mem rom(pc,SW[14:10]*4,(~clock),(~clock_debug),rom_out,rom_out_dbg);

    pipeline IF_ID(clock,reset,rom_out,,,,,,,,,instr);

    // ==================
    // Instruction decode
    // ==================
    wire[31:0] reg_out1;
    wire[31:0] reg_out2;
	wire[31:0] id_mux_in1, id_mux_in2, id_mux_in3;
    wire[31:0] reg_out_dbg;
    wire[5:0] id_reg_dest;
	wire alu_zero;
	wire[31:0] imm_mux_out;
    wire[15:0] id_muxctrl;
    wire[2:0] id_memctrl;
    wire[4:0] id_aluctrl;

    // setup controller. combinational logic.
    controller cont_inst(instr[31:26], instr[5:0], alu_zero, reset, id_muxctrl, id_memctrl, id_aluctrl);


    // FIXME: won't work for I-type. need control lines designating what type?
    bubbler bub_inst(instr[25:21], instr[20:16], ex_rd, ex_memctrl[2], bubble);

	assign id_mux_in1 = {22'd0, instr[10:6]};
	sign_extender se_inst(instr[15:0], id_mux_in2);
	assign id_mux_in3 = {6'd0, instr[25:0]};
	 

    mux3 imm_src(id_muxctrl[0], id_muxctrl[1],
                 id_mux_in1,  // shamt, 0-padded
                 id_mux_in2,  // imm, sign-extended
                 id_mux_in3,  // address, 0-padded
                 imm_mux_out);

    assign LEDR[17] = bubble;
    assign LEDR[16:12] = id_aluctrl[4:0];
    //assign LEDR[11:9] = id_memctrl[2:0];
    assign LEDR[10:0] = id_muxctrl[10:0];
    assign LEDG[1:0] = fwd_d1_ctrl[1:0];
    assign LEDG[3:2] = fwd_d2_ctrl[1:0];

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
    wire[31:0] ex_d1_in, ex_d2_in, ex_d2, ex_d1_out, ex_imm;
    wire ex_zero;
    wire[31:0] alu_d1, alu_d2;
	wire[31:0] ex_reg_dest;
    wire[4:0] ex_rs, ex_rt, ex_rd;
    wire[15:0] ex_muxctrl;
    wire[2:0] ex_memctrl;
    wire[4:0] ex_aluctrl;
    wire[1:0] fwd_d1_ctrl, fwd_d2_ctrl;

    pipeline ID_EX(clock, reset,
                   reg_out1, reg_out2, imm_mux_out, instr[25:21], instr[20:16], instr[15:11], id_muxctrl, id_memctrl, id_aluctrl,
                   ex_d1_in, ex_d2_in, ex_imm,  ex_rs, ex_rt, ex_rd, ex_muxctrl, ex_memctrl, ex_aluctrl);

    // Forward values if we have a RAW
    forwarder fwd(wb_rd, mem_rd, ex_rs, ex_rt, fwd_d1_ctrl, fwd_d2_ctrl);

    mux3 d1_mux(fwd_d1_ctrl[0], fwd_d1_ctrl[1], ex_d1_in, mem_addr_in, wb_out, alu_d1);
    mux3 d2_mux(fwd_d2_ctrl[0], fwd_d2_ctrl[1], ex_d2_in, mem_addr_in, wb_out, alu_d2);

    mux3 ex_rd_src(ex_muxctrl[3], ex_muxctrl[4],
                   ex_rd, // rd
                   ex_rt, // rt
                   ex_rs, // rs
                   ex_reg_dest);

    execution ex_inst(alu_d1, alu_d2, ex_imm, ex_muxctrl[0], ex_aluctrl, ex_d1_out, ex_zero);

    mux3 pc_src(ex_muxctrl[7], (ex_zero & ex_muxctrl[9]), 
                (pc + 4),               // normal
                ex_imm,                 // jump
                ((ex_imm << 2) + pc),   // branch
                next_pc);
                

    // =============
    // Memory access
    // =============
    wire[31:0] mem_data_in;
    wire[31:0] mem_addr_in;
    wire[31:0] mem_data_out;
    wire[4:0] mem_rs;
    wire[4:0] mem_rt;
    wire[4:0] mem_rd;
    wire[15:0] mem_muxctrl;
    wire[2:0] mem_memctrl;
    wire[31:0] ram_out;
    wire[31:0] ram_out_dbg;

    pipeline EX_MEM(clock, reset,
                    ex_d1_out, alu_d2, , ex_rs, ex_rt, ex_reg_dest, ex_muxctrl, ex_memctrl,,
                    mem_addr_in, mem_data_in, , mem_rs, mem_rt, mem_rd, mem_muxctrl, mem_memctrl );

    // set up data memory access
    // negate clock to make memory do stuff on falling edge
    data_mem ram(mem_addr_in,SW[9:5]*4,~clock,~clock_debug,mem_data_in,,mem_memctrl[1],,ram_out,ram_out_dbg);

    // ==========
    // Write-back
    // ==========
    wire[31:0] wb_d1_in, wb_d2_in, wb_d1_out, wb_d2_out, wb_out;
    wire[4:0] wb_rs, wb_rt, wb_rd;
    wire[15:0] wb_muxctrl;
    wire[2:0] wb_memctrl;


    pipeline MEM_WB(clock, reset,
                    ram_out, mem_addr_in, , mem_rs, mem_rt, mem_rd,mem_muxctrl,mem_memctrl,,
                    wb_d1_out, wb_d2_out, , wb_rs, wb_rt, wb_rd,wb_muxctrl,wb_memctrl);

    // FIXME: rename shit
    mux2 wb_mux(wb_muxctrl[2], wb_d2_out, wb_d1_out, wb_out);

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
