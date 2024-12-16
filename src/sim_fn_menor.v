`include "fn_menor.v"
module sim_fn_menor ;
    integer i;
    reg [31:0] a, b;  
    reg sin_signo;          
    wire Y;   
    fn_menor dut (
        .a (a),
        .b (b),
        .sin_signo (sin_signo),
        .Y (Y)
        
    );

    initial begin
        $dumpfile("fn_menor.vcd");
        $dumpvars(0);
       for (i=0;i<4;i = i + 1) begin
         
         a = {$random}%2001 - 1000; // $random genera un integer aleatorio {} es una concatenacion, su resultado es sin signo
         b = {$random}%2001 - 1000; // numero aleatorio entre -1000 y 1000
            sin_signo = 0;
            #10; // espera 10 unidades de tiempo
            sin_signo = 1;
            #10;
        end
    end

endmodule
