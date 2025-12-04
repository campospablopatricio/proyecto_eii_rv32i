// Diseño del bloques de valor inmediato
module valor_inmediato (
    output reg [31:0] inmediato,
    input      [31:0] inst,      // instrucción completa
    input      [ 2:0] tipo       // selector de tipo de inmediato (I/S/B/U/J)
);
    always @(*) begin
        case (tipo)

            3'b000: 
                // Tipo I -> inmediato[11:0] = inst[31:20]
                // Se extiende el bit de signo inst[31] a 32 bits
                inmediato = {{21{inst[31]}}, inst[30:20]};
   3'b001: 
                // Tipo S -> inmediato[11:5] = inst[31:25]
                //           inmediato[4:0]  = inst[11:7]
                // Extensión de signo con inst[31]
                inmediato = {{21{inst[31]}}, inst[30:25], inst[11:7]};

       3'b010: 
                // Tipo B -> inmediato de 13 bits con LSB = 0
                // Armado según formato B:
                //   imm[12]   = inst[31]
                //   imm[10:5] = inst[30:25]
                //   imm[4:1]  = inst[11:8]
                //   imm[11]   = inst[7]
                //   imm[0]    = 1'b0
                inmediato = {{20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
       3'b011: 
                // Tipo U  -> inmediato[31:12] = inst[31:12]
                // Se completa con 12 bits en cero (shift << 12)
                inmediato = {inst[31], inst[30:12], 12'b0};

           3'b100: 
                // Tipo J  -> inmediato de 21 bits con LSB = 0
                // Armado según formato J:
                //   imm[20]   = inst[31]
                //   imm[10:1] = inst[30:21]
                //   imm[11]   = inst[20]
                //   imm[19:12]= inst[19:12]
                //   imm[0]    = 1'b0
                inmediato = {{12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
        endcase
    
    end
endmodule