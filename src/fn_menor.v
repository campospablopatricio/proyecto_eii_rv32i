//Función *MENOR QUE* de 32 bit para valores en binario natural y con signo complemento a dos. Incluye 
//una entrada de selección, $0$ con signo y $1$ sin signo, dos entradas, $A$ y $B$, de 32 bit y una 
//salida de un bit. 
//La salida es $1$ si la entrada $A$ es menor que la entrada $B$ y $0$ caso contrario. 
//La comparación se realiza considerando valores en binario natural o en complemento a dos según indique 
//la entrada de selección.
  
module fn_menor (
    input  [31 : 0] a,
    input  [31 : 0] b,
    input           sin_signo,
    output          Y
);
 
  assign Y = sin_signo ? (a < b) : ($signed(a) < $signed(b));
  
endmodule
