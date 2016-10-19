module bubbler(
    input wire[4:0] rs,
    input wire[4:0] rt,
    input wire[1:0] mem_ctrl,
    input wire[4:0] ex_rd,
    output wire bubble,
    );

    always @(*) begin
        // if reading from mem and ex_rd = (rs or rt)
        //      do bubble
    end
endmodule

