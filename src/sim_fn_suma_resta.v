`include "fn_suma_resta.v"

module sim_fn_suma_resta;
    // Declaración de señales
    reg [31:0] a, b;  // Entradas de 32 bits
    reg S;            // Entrada de selección (0: suma, 1: resta)
    wire [31:0] Y;    // Salida de 32 bits

    // Instanciación del módulo bajo prueba (DUT: Device Under Test)
    fn_suma_resta dut (
        .a(a),
        .b(b),
        .S(S),
        .Y(Y)
    );

    // Bloque de simulación
    initial begin
        // Configuración para volcado de ondas
        $dumpfile("fn_suma_resta.vcd");
        $dumpvars(0, sim_fn_suma_resta);

        // Caso 1: Suma (S = 0)
        a = 32'd15; b = 32'd10; S = 0;  // 15 + 10
        #10 
        // Caso 2: Resta (S = 1)
        a = 32'd15; b = 32'd10; S = 1;  // 15 - 10
        #10 

        $finish;
    end
endmodule

