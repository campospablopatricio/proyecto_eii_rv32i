`include "fn_and.v"
`include "fn_cero.v"
`include "fn_des_der.v"
`include "fn_des_izq.v"
`include "fn_menor.v"
`include "fn_or.v"
`include "fn_suma.v"
`include "fn_xor.v"

module alu (
    input  a,
    input  b,
    input  sel,
    output Y
);
    assign Y = a & b;
endmodule
