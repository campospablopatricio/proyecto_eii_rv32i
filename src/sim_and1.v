`include "and1.v"
module sim_and1 ;
    integer i;
    reg a,b;
    wire Y;
    and1 dut (
        .Y (Y),
        .a (a),
        .b (b)
    );

    initial begin
        $dumpfile("and1.vcd");
        $dumpvars(0);
        for (i=0;i<4;i = i + 1) begin
            {a,b} = i[1:0];
            #10;
        end
    end
endmodule
