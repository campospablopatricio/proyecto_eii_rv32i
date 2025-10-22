`include "fn_and.v"
module sim_fn_and ;
    integer i;
    reg [31:0]a;
    reg [31:0]b;
    wire [31:0]Y;
    fn_and dut (
        .Y (Y),
        .a (a),
        .b (b)
    );

    initial begin
        $dumpfile("fn_and.vcd");
        $dumpvars(0);
       a = 32'hFFFF0000; b = 32'h0F0F0F0F; #10;
       a = 32'hAAAAAAAA; b = 32'h55555555; #10;
       a = 32'h12345678; b = 32'h87654321; #10;
       a = 32'h0000000F; b = 32'h000000F0; #10;
        end
    
endmodule
