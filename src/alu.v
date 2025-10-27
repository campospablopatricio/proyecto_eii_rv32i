//A partir de los componentes desarrollados en el punto anterior, diseña, describe a nivel estructural y 
//evalúa mediante simulación una unidad aritmética-lógica de 32 bit con dos entradas de operando, una 
//entrada de selección, una salida de resultado y una salida de cero, con las funciones dadas por la Tabla 1

`include "fn_and.v"
`include "fn_cero.v"
`include "fn_des_der.v"
`include "fn_des_izq.v"
`include "fn_menor.v"
`include "fn_or.v"
`include "fn_suma_resta.v"
`include "fn_xor.v"

module alu (
    input [31:0] a,
    input [31:0] b,
    input [3:0] sel,
    output reg [31:0] Y,
    output zero
);

    wire [31:0] y_and;
    wire [31:0] y_des_der;
    wire [31:0] y_des_izq;
    wire y_menor;
    wire [31:0] y_or;
    wire [31:0] y_suma_resta;
    wire [31:0] y_xor;

        fn_and U_and(
        .Y(y_and),
        .a(a),
        .b(b)
    );

        fn_des_der U_des_der(
        .Y (y_des_der),
        .con_signo(sel[0]),
        .a (a),
        .b (b[4:0])
    );

        fn_des_izq U_des_izq (
        .Y (y_des_izq),
        .a (a),
        .b (b[4:0])
    );

        fn_menor U_menor (
        .Y (y_menor),
        .a (a),
        .b (b),
        .sin_signo (sel[1])
    );

        fn_or U_or (
        .Y (y_or),
        .a (a),
        .b (b)
    );

        fn_suma_resta U_suma_resta (
        .Y(y_suma_resta),
        .a(a),
        .b(b),
        .resta(sel[0])
        
    );

        fn_xor U_xor (
        .Y (y_xor),
        .a (a),
        .b (b)
    );

        fn_cero U_cero (
        .Y (zero),
        .a (Y)
    );

    
    always @(*) begin
        case (sel[3:1]) //el orden de las funciones fueron establecidas por el enunciado
        3'b000: Y = y_suma_resta;
        3'b001: Y = y_des_izq;
        3'b010: Y = y_menor;
        3'b011: Y = y_menor;
        3'b100: Y = y_xor;
        3'b101: Y = y_des_der;
        3'b110: Y = y_or;
        3'b111: Y = y_and;
        endcase
    end

endmodule
