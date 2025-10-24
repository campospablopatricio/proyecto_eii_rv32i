 //- Función *desplazamiento a la derecha* de un valor de 32 bit por la cantidad de bits indicada por un valor 
 //de 5 bit. Cuenta con un selector de modo *con signo*. En modo sin signo ingresa ceros por la izquierda, 
 //en modo con signo copia el bit de signo (extensión de signo).
module fn_des_der (
    input  [31 : 0] a,
    input  [4 : 0]  b,
    input   con_signo,
    output [31 : 0] Y
   
    
);
    assign Y = con_signo? $unsigned($signed(a) >>> b) : a >> b ;
endmodule
