module mux2(
    input wire[1:0] ctrl,
    input wire[31:0] s0,
    input wire[31:0] s1,
    output reg[31:0] out);

    always @(*) begin
        if (ctrl == 1'b0) begin
            out = s0;
        end else begin
            out = s1;
        end
    end
endmodule

