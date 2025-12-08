    //simulacion control_alu
//   - modo = 2'b00 : operaciones que usan solo SUMA
//   - modo = 2'b01 : instrucciones tipo 19 (0010011, tipo I aritmético)
//   - modo = 2'b10 : instrucciones tipo 51 (0110011, tipo R aritmético)
//   - modo = 2'b11 : instrucciones tipo 99 (1100011, branches)
    `include "control_alu.v"

    module sim_control_alu;
    integer i;
    reg  [1:0] modo;        // Instrucciones (00, 01, 10, 11)
    reg  [2:0] funct3;      // Campo funct3 de la instrucción
    reg  [6:0] funct7;      // Campo funct7 de la instrucción (solo se usa el bit 5)
    wire [3:0] sel_alu;     

        control_alu dut (
            .modo (modo),
            .funct3 (funct3),
            .funct7 (funct7),
            .sel_alu (sel_alu)
        );

        initial begin
            $dumpfile("control_alu.vcd");
            $dumpvars(0, sim_control_alu);
            
            modo = 2'b01;

            funct3    = 3'b000;  // ADDI
            funct7[5] = 1'bx;
            #10;

            modo = 2'b01;
            funct3    = 3'b000;  // ADDI
            funct7[5] = 1'bx;
            #10;

            funct3    = 3'b001;  // SLLI
            funct7[5] = 1'b0;
            #10;


           funct3    = 3'b010;  // SLTI
           funct7[5] = 1'bx;
           #10;            
           

           funct3    = 3'b011;  // SLTIU
           funct7[5] = 1'bx;
           #10;            
           
           funct3    = 3'b100;  // XORI
           funct7[5] = 1'bx;
           #10;            
           
           funct3    = 3'b101;  // SRLI
           funct7[5] = 1'b0;
           #10;
           
           funct3    = 3'b101;  // SRAI
           funct7[5] = 1'b1;
           #10;

           funct3    = 3'b110;  // ORI
           funct7[5] = 1'bx;
           #10;

           funct3    = 3'b111;  // ANDI
           funct7[5] = 1'bx;
           #10;

        // 3) PRUEBAS MODO = 2'b10 -> instrucciones tipo 51 (0110011)

            modo = 2'b10;
            funct3    = 3'b000;  // ADD
            funct7[5] = 1'b0;
            #10;

            funct3    = 3'b000;  // SUB
            funct7[5] = 1'b1;
            #10;

            funct3    = 3'b001;  // SLL
            funct7[5] = 1'b0;
            #10;

            funct3    = 3'b010;  // SLT
            funct7[5] = 1'b0;
            #10;

            funct3    = 3'b011;  // SLTU
            funct7[5] = 1'b0;
            #10;

            funct3    = 3'b100;  // XOR
            funct7[5] = 1'b0;
            #10;

            funct3    = 3'b101;  // SRL
            funct7[5] = 1'b0;
            #10;

            funct3    = 3'b101;  // SRA
            funct7[5] = 1'b1;
            #10;

            funct3    = 3'b110;  // OR
            funct7[5] = 1'b0;
            #10;

            funct3    = 3'b111;  // AND
            funct7[5] = 1'b0;
            #10;

        // 4) PRUEBAS MODO = 2'b11 -> instrucciones tipo 99 (1100011)

            modo = 2'b11;
            funct7[5] = 1'bx;    // ignorado

            funct3 = 3'b000;     // BEQ
            #10;

            funct3 = 3'b001;     // BNE
            #10;

            funct3 = 3'b100;     // BLT
            #10;

            funct3 = 3'b101;     // BGE
            #10;

            funct3 = 3'b110;     // BLTU
            #10;

            funct3 = 3'b111;     // BGEU
            #10;
            #10;
        end
    endmodule