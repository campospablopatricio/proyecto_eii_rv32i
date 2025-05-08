// Diseño del bloques de valor inmediato
module valor_inmediato (
    output reg [31:0] inmediato,
    input  [31:0] inst,
    input  [2:0] tipo
);
    always @(*) begin
        case(tipo)
        3'b000: //Tipo I 12bits 11:0
        inmediato = {{21{inst[31]}},inst[30:20]};

        3'b001: //Tipo S 12bits 11:0
        inmediato = {{21{inst[31]}},inst[30:25],inst[11:7]};

        3'b010: //Tipo B 13bits
        inmediato = {{20{inst[31]}},inst[7],inst[30:25],inst[11:8],1'b0};

        3'b011: //Tipo U 20bits
        inmediato = {inst[31],inst[30:12],12'b0};

        3'b100: //Tipo J 21bits
        inmediato = {{12{inst[31]}},inst[19:12],inst[20],inst[30:21],1'b0};

        endcase
    
    end
endmodule