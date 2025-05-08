module reg32 (
    output reg [31:0] q,  // Salida del registro de 32 bits
    input  [31:0] d,      // Entrada de datos de 32 bits
    input  clk,           // Señal de reloj
    input  rst,           // Señal de reset
    input  load           // Señal de carga
);

    always @(posedge clk) begin   
        if (rst)       q <= 32'b0;
        else if (load) q <= d;
    end
endmodule