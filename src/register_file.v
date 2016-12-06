// file register.v

module register_file(
	input wire[4:0] read_address_1,
	input wire[4:0] read_address_2,
	input wire[31:0] write_data_in,
	input wire[4:0] write_address,
	input wire write_enable,
	input wire reset,
	input wire clock,
	input wire[4:0] read_address_debug,
	input wire clock_debug,
	
	output reg[31:0] data_out_1,
	output reg[31:0] data_out_2,
	output reg[31:0] data_out_debug);
	
	reg[31:0] registers [0:31];
	
	integer i;
	
	initial begin
		for (i=0; i<32; i=i+1) begin
            registers[i] <= i;
		end
	
		data_out_1 <= 32'h0;
		data_out_2 <= 32'h0;
		data_out_debug <= 32'h0;
	end

    always @(negedge clock or posedge reset) begin
        if (reset == 1'b1) begin
			for (i=0; i<32; i=i+1) begin
                registers[i] = i;
			end
            data_out_1 = 32'h0;
            data_out_2 = 32'h0;
        end else begin
            //end else if (clock == 1'b1) begin
            // save previous reg values
            for (i=0; i<32; i=i+1) begin
                registers[i] = registers[i];
            end
            if (write_enable == 1'b1) begin
                // set new register value
                registers[write_address] = write_data_in;
            end else begin
                registers[write_address] = registers[write_address];
            end
            //end else begin
            // set data_out_* values
            data_out_1 = registers[read_address_1];
            data_out_2 = registers[read_address_2];

        end
    end

    always @(*) begin
        data_out_debug = registers[read_address_debug];
    end
            
	
    /*
	// write on rising edge
    always @(posedge clock or posedge reset) begin

        if (reset == 1'b1) begin
            // set registers to i
            for (i=0; i<32; i=i+1) begin
                registers[i] <= i;
            end
        end else begin

            // save previous reg values
            for (i=0; i<32; i=i+1) begin
                registers[i] <= registers[i];
            end
            if (write_enable == 1'b1) begin
                // set new register value
                registers[write_address] <= write_data_in;
            end
        end
    end
	
	// read on falling edge
	// FIXME: can't infer register for assignment because clock isn't obvious. this gets combinational logic right now.
	//always @(negedge clock or negedge reset) begin
	always @(negedge clock) begin
        if (clock == 1'b0) begin
            // set data_out_* values
            data_out_1 <= registers[read_address_1];
            data_out_2 <= registers[read_address_2];
            data_out_debug <= registers[read_address_debug];
        end else begin
            data_out_1 <= data_out_1;
            data_out_2 <= data_out_2;
            data_out_debug <= data_out_debug;
        end
	end
	
	always @(negedge clock or negedge reset) begin
		data_out_debug <= registers[read_address_debug];
	end
    */
	
endmodule

