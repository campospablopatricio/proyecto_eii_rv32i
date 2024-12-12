module fn_or (
    output [31 : 0] Y,
    input  [31 : 0] a,
    input  [31 : 0] b
);
    assign Y = a | b;
endmodule