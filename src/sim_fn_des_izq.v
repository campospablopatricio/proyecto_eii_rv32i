`include "fn_des_izq.v"
module sim_fn_des_izq ;
    integer i;
    reg  [31:0] a;
    reg  [4:0]  b;
    wire [31:0] Y;
    fn_des_izq dut (
        .Y (Y),
        .a (a),
        .b (b)
    );

    initial begin
        $dumpfile("fn_des_izq.vcd");
        $dumpvars(0, sim_fn_des_izq);
        a =1;
     for (i=0;i<20;i = i + 5) begin
            b = i;
            #10;
     end
    
    end
endmodule
