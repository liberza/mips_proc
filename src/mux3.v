module mux3(
    input wire ctrl0,
    input wire ctrl1
    input wire[31:0] s0,
    input wire[31:0] s1,
    input wire[31:0] s2,
    output reg[31:0] out);

    always @(*) begin
        if (ctrl1 == 0 and ctrl0 == 0) begin
            out = s0;
        end else if (ctrl1 == 0 and ctrl0 == 1) begin
            out = s1;
        end else begin
            out = s2;
        end
    end
endmodule

