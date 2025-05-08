module condicion_branch (
    output z_branch,
    input  [2:0] funct3
);
    assign z_branch = funct3[2] ~^ funct3[0];
endmodule
