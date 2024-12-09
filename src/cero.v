module cero(
    input [31:0] a,     // Entrada de 32 bits
    output Y         // Salida de un bit
);
    assign Y = (a == 32'b0); //el resultado de esto me devuelve 1 si es correcto, sino cero.
endmodule
