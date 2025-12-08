//DISEÑO DEL BLOQUE CONTROL ALU, PARA ESTE BLOQUE TENEMOS EN CUENTA LAS INSTRUCCIONES 19,51,99
//

module control_alu (
   output reg [3:0] sel_alu,  // Código de operación para la ALU
    input      [1:0] modo,     // Tipo de instrucción (depende del opcode)
    input      [2:0] funct3,   // Campo funct3 de la instrucción
    input      [6:0] funct7    // Campo funct7 de la instrucción (bit 5 se usa en ALU)
);

    always @(*) begin
        case(modo)
        // modo = 2'b00
        // Operaciones donde la ALU solo debe hacer SUMA
        2'b00: sel_alu = 4'b0000;                      //suma

        // modo = 2'b01  -> instrucciones con opcode 19 (0010011)
        2'b01: sel_alu = {funct3,funct3[0]&funct7[5]}; //Instrucciones 19

         // modo = 2'b10  -> instrucciones con opcode 51 (0110011)
        2'b10: sel_alu = {funct3,funct7[5]};           //instrucciones 51

         // modo = 2'b11  -> instrucciones con opcode 99 (1100011)
        2'b11: sel_alu = {1'b0,funct3[2:1],1'b1};      //instrucciones 99    
        endcase
    end

endmodule