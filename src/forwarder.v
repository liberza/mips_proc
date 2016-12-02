module forwarder(
    input wire[5:0] wb_rd,
    input wire[5:0] mem_rd,
    input wire[5:0] ex_rs,
    input wire[5:0] ex_rt,
    output reg[1:0] d1_mux,
    output reg[1:0] d2_mux);

    initial begin
        d1_mux = 2'b00;
        d2_mux = 2'b00;
    end

    always @(*) begin
        if (ex_rs == mem_rd) begin
            d1_mux = 2'b01;
        end else if (ex_rs == wb_rd) begin
            d1_mux = 2'b10;
		  end else begin
			d1_mux = 2'b00;
		  end
		  
        if (ex_rt == mem_rd) begin
            d2_mux = 2'b01;
        end else if (ex_rt == wb_rd) begin
            d2_mux = 2'b10;
        end else begin
            d2_mux = 2'b00;
        end
    end
endmodule

