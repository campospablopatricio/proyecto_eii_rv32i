`include "valor_inmediato.v"
module sim_valor_inmediato ;
    integer i;
    wire [31:0] inmediato;
    reg  [31:0] inst;               // instrucción de prueba
    reg  [ 2:0] tipo;               // tipo de inmediato a decodificar
    reg  [31:0] inmediato_esperado; // valor inmediato esperado

    valor_inmediato dut (
        .inmediato (inmediato),
        .inst      (inst),
        .tipo      (tipo)
    );

    initial begin
        $dumpfile("valor_inmediato.vcd");
        $dumpvars(0, sim_valor_inmediato);
        // tipo I 
        tipo = 3'b000;
           inmediato_esperado =  32'd2000;
        inst = {inmediato_esperado[11:0], {20{1'bx}}};
        #10;

        inmediato_esperado = -32'd2000;
        inst = {inmediato_esperado[11:0], {20{1'bx}}};
        #10;
        // tipo S
        tipo = 3'b001;
         inmediato_esperado =  32'd2000;
        inst = {inmediato_esperado[11:5], {13{1'bx}}, inmediato_esperado[4:0], {7{1'bx}}};
        #10;

        inmediato_esperado = -32'd2000;
        inst = {inmediato_esperado[11:5], {13{1'bx}}, inmediato_esperado[4:0], {7{1'bx}}};
        #10;
        // tipo B
        tipo = 3'b010;
        inmediato_esperado =  32'd3000;
        inst = {inmediato_esperado[12], inmediato_esperado[10:5], {13{1'bx}},
                inmediato_esperado[4:1], inmediato_esperado[11], {7{1'bx}}};
        #10;

        inmediato_esperado = -32'd3000;
        inst = {inmediato_esperado[12], inmediato_esperado[10:5], {13{1'bx}},
                inmediato_esperado[4:1], inmediato_esperado[11], {7{1'bx}}};
        #10;

        // tipo U
        tipo = 3'b011;
        inmediato_esperado =  32'd409600;
        inst = {inmediato_esperado[31:12], {12{1'bx}}};
        #10;

        inmediato_esperado = -32'd409600;
        inst = {inmediato_esperado[31:12], {12{1'bx}}};
        #10;
        // tipo J
        tipo = 3'b100;
        inmediato_esperado =  32'd1000000;
        inst = {inmediato_esperado[20], inmediato_esperado[10:1],
                inmediato_esperado[11], inmediato_esperado[19:12], {12{1'bx}}};
        #10;

        inmediato_esperado = -32'd1000000;
        inst = {inmediato_esperado[20], inmediato_esperado[10:1],
                inmediato_esperado[11], inmediato_esperado[19:12], {12{1'bx}}};
        #10;
    end
endmodule