module mux3(
    input wire[1:0] ctrl,
    input wire[31:0] s0,
    input wire[31:0] s1,
    input wire[31:0] s2,
    output wire[31:0] out);

    always @(*) begin
        if (ctrl == 0) begin
            out = s0;
        end else if (ctrl == 1) begin
            out = s1;
        end else begin
            out = s2;
        end
    end
endmodule

