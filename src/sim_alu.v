`include "alu.v"
module sim_alu ;
    integer i;
    reg [31:0]   a;
    reg [31:0]   b;
    reg [ 3:0] sel;
    wire[31:0]   Y;
    wire      zero;

    alu dut (
        .Y (Y),
        .a (a),
        .b (b),
        .sel(sel),
        .zero (zero)
    );

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, sim_alu);
        a = 3; b = 6; sel = 4'b0000; #5; //Suma
        a = 3; b = 6; sel = 4'b0001; #5; //Resta
        a = 3; b = 3; sel = 4'b0001; #5; //Resta igual a cero
        a = 3; b = 6; sel = 4'b001x; #5; //Desplazamiento izquierda
        a = 3; b = 6; sel = 4'b010x; #5; //Menor que complemento a 2
        a = 3; b = 6; sel = 4'b011x; #5; //Menor que binario natural
        a = 3; b = 6; sel = 4'b100x; #5; //Funcion xor
        a = 32'h80000000; b = 4; sel = 4'b1010; #5; //Desplazamiento derecha binario natural
        a = 32'h80000000; b = 4; sel = 4'b1011; #5; //Desplazamiento derecha completo a 2
        a = 3; b = 6; sel = 4'b110x; #5; //Funcion or
        a = 3; b = 6; sel = 4'b111x; #5; //Funcion and
    end
endmodule