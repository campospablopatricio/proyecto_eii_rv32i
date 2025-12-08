// Simulación de condicion_branch.
`include "condicion_branch.v"
module sim_condicion_branch ;
    wire z_branch;
    reg [2:0] funct3;

    condicion_branch dut (
        .z_branch (z_branch),
        .funct3 (funct3)
    );

    initial begin
        $dumpfile("condicion_branch.vcd");
        $dumpvars(0, sim_condicion_branch);
        funct3 = 000; #10; // 000 -> BEQ
        funct3 = 001; #10; // 001 -> BNE
        funct3 = 100; #10; // 100 -> BLT
        funct3 = 101; #10; // 101 -> BGE
        funct3 = 110; #10; // 110 -> BLTU
        funct3 = 111; #10; // 111 -> BGEU
        #10;
        end
endmodule
