//
`include "fn_cero.v"

module sim_fn_cero;
    integer i;
    reg [31:0] a; // Entrada de 32 bits
    wire Y;

    // Instancia del módulo cero
    fn_cero dut (
        .Y (Y),
        .a (a)
    );

    // Bloque inicial para generar la simulación
initial begin
    $dumpfile("fn_cero.vcd");
    $dumpvars(0, sim_fn_cero);
    
    for (i = 0; i < 8; i = i + 1) begin
        if (i % 2 == 0) begin
            a = 32'b0; // cero
        end else begin
            a = 32'hFFFFFFFF; // distinto de cero
        end
        #10; // Esperar 10 unidades de tiempo
    end
end


endmodule

