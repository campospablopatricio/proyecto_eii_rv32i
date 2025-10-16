//Función *cero* de 32 bit. La entrada es una señal de 32 bit y la salida una señal de un bit, 
//que vale $1$ cuando la señal de entrada vale cero.

module fn_cero(
    input [31:0] a,     // Entrada de 32 bits
    output       Y      // Salida: 1 si a==0
);
    assign Y = (a == 32'b0); //el resultado de esto me devuelve 1 si es correcto, sino cero.
endmodule
