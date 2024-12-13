`include "fn_suma_resta.v"

module sim_fn_suma_resta;
    // Declaración de señales
    reg [31:0] a, b;  
    reg resta;          
    wire [31:0] Y;   
    wire [31 : 0] aux;
    fn_suma_resta dut (
        .a(a),
        .b(b),
        .resta(resta),
        .Y(Y)
    );

    // Bloque de simulación
    initial begin
       
        $dumpfile("fn_suma_resta.vcd");
        $dumpvars(0, sim_fn_suma_resta);

        // Caso 1: Suma (resta = 0)
        a = 32'd15; b = 32'd10; resta = 0;  // 15 + 10
        #10 
        // Caso 2: Resta (resta = 1)
        a = 32'd15; b = 32'd10; resta = 1;  // 15 - 10
        #10 

        $finish;
    end
endmodule

