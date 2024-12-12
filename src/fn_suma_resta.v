 //- Función *SUMA/RESTA* de dos entradas de 32 bit. Incluye una entrada de selección, 
 //$0$ para suma y $1$ para resta, dos entradas de 32 bit y una salida de 32 bit. 
 //La salida es la suma o resta de las entradas según la entrada de selección.
module fn_suma_resta (
    input  [31 : 0] a,
    input  [31 : 0] b,
    input           S,
    output [31 : 0] Y
);
    assign Y = (S == 0) ? a+b : a-b;
endmodule
