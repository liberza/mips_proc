module bubbler(
    input wire[4:0] rs,
    input wire[4:0] rt,
    input wire[4:0] ex_rd,
    input wire ex_mem_read,
    output reg bubble
    );

    always @(*) begin
        // check for mem_read
        if (ex_mem_read == 1'b1) begin
            if ((rs == ex_rd) || (rt == ex_rd)) begin
                bubble <= 1;
            end else begin
                bubble <= 0;
            end
        end else begin
            bubble <= 0;
        end
    end
endmodule

