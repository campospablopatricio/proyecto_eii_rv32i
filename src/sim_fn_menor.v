`include "fn_menor.v"
module sim_fn_menor ;
    integer i;
    reg a,b;
    wire Y;
    fn_menor dut (
        .Y (Y),
        .a (a),
        .b (b)
    );

    initial begin
        $dumpfile("fn_menor.vcd");
        $dumpvars(0);
        for (i=0;i<4;i = i + 1) begin
            {a,b} = i[1:0];
            #10;
        end
    end
endmodule
