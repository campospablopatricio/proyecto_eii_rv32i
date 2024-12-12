//- Función *AND* de dos entradas de 32 bit. Las entradas y la salida son señales de 32 bit. 
//Cada bit de la salida es el producto lógico de los bits correspondientes de las entradas.
module fn_and (
    output [31 : 0] Y,
    input  [31 : 0] a,
    input  [31 : 0] b
);
    assign Y = a & b;
endmodule
