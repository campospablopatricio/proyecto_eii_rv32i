`include "fn_des_izq.v"
module sim_fn_des_izq ;
    integer i;
    reg [31:0] a;
    reg [4:0] d;
    wire [31:0] Y;
    fn_des_izq dut (
        .Y (Y),
        .a (a),
        .d (d)
    );

    initial begin
        $dumpfile("fn_des_izq.vcd");
        $dumpvars(0);
        a =1 ;
     for (i=0;i<20;i = i + 5) begin
            d = i;
            #10;
     end
    
    end
endmodule
