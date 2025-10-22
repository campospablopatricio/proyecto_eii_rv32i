`include "fn_xor.v"
module sim_fn_xor ;
    integer i;
    reg [31:0]a;
    reg [31:0]b;
    wire [31:0]Y;
    fn_xor dut (
        .Y (Y),
        .a (a),
        .b (b)
    );

    initial begin
        $dumpfile("fn_xor.vcd");
        $dumpvars(0);
       a = 32'h0000_0000; b = 32'h0000_0000; #10;
       a = 32'h0000_0000; b = 32'hFFFF_FFFF; #10;
       a = 32'hFFFF_FFFF; b = 32'h0000_0000; #10;
       a = 32'hFFFF_FFFF; b = 32'hFFFF_FFFF; #10;      
        
    end
endmodule
