`include "fn_or.v"
module sim_fn_or ;
    integer i;
    reg [31:0] a,b;
    wire [31:0] Y;

    fn_or dut (
        .Y (Y),
        .a (a),
        .b (b)
    );

    initial begin
        $dumpfile("fn_or.vcd");
        $dumpvars(0);
       a = 32'h0000_0000; b = 32'h0000_0000; #10;
       a = 32'h0000_0000; b = 32'hFFFF_FFFF; #10;
       a = 32'hFFFF_FFFF; b = 32'h0000_0000; #10;
       a = 32'hFFFF_FFFF; b = 32'hFFFF_FFFF; #10;
        
    end
endmodule
