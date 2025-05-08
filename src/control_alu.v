//DISEÑO DEL BLOQUE CONTROL ALU, PARA ESTE BLOQUE TENEMOS EN CUENTA LAS INSTRUCCIONES 19,51,99
//

module control_alu (
    output reg [3:0] sel_alu,
    input      [1:0] modo,
    input      [2:0] funct3,
    input      [6:0] funct7
);

    always @(*) begin
        case(modo)
        2'b00: sel_alu = 4'b0000;                      //suma
        2'b01: sel_alu = {funct3,funct3[0]&funct7[5]}; //Instrucciones 19
        2'b10: sel_alu = {funct3,funct7[5]};           //instrucciones 51
        2'b11: sel_alu = {1'b0,funct3[2:1],1'b1};      //instrucciones 99    
        endcase
    end

endmodule