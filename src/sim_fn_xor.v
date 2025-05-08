`include "fn_xor.v"
module sim_fn_xor ;
    integer i;
    reg [31:0] a,b;
    wire [31:0] Y;
    fn_xor dut (
        .Y (Y),
        .a (a),
        .b (b)
    );

    initial begin
        $dumpfile("fn_xor.vcd");
        $dumpvars(0);
        //Caso 1 (0 y 0)
        a = 32'b0; b = 32'b0;
        #10;
       

        // Caso 2: a = 32'b0, b = 32'b1 (0 y 1)
        a = 32'b0; b = 32'b1;
        #10;
       

        // Caso 3: a = 32'b1, b = 32'b0 (1 y 0)
        a = 32'b1; b = 32'b0;
        #10;
       

        // Caso 4: a = 32'b1, b = 32'b1 (1 y 1)
        a = 32'b1; b = 32'b1;
        #10;
      

        $finish; 
        
    end
endmodule
