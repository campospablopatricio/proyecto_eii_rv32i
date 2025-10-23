//- Función *desplazamiento a la izquierda* de un valor de 32 bit por la cantidad de bits indicada por 
//un valor de 5 bit. Ingresa ceros por la derecha.
module fn_des_izq (
    input  [31 : 0] a,
    input  [4 : 0]  b,
    output [31 : 0] Y
   
    
);
    assign Y = a << b; //desplazamiento a la izquierda
endmodule
