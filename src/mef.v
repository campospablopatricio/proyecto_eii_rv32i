//- Diseñar una unidad de control (máquina de estado finito) capaz de ejecutar las instrucciones mencionadas en el 
//apartado anterior.
//     ESCRIBE -> CARGA -> DECODIFICA -> DIRECCION -> MEMORIA_EJECUTA -> ESCRIBE 

module mef (
    output reg       esc_pc,         // habilita escritura en PC
    output reg       branch,         // habilita actualización condicional de PC (branch)
    output reg       sel_dir,        // 0: dirección = PC, 1: dirección = resultado ALU (Y)
    output reg       esc_mem,        // habilita escritura en memoria de datos
    output reg       esc_inst,       // habilita escritura en registro de instrucción (IR)
    output reg       esc_reg,        // habilita escritura en banco de registros (rd)

    output reg [2:0] sel_inmediato,  // selecciona tipo de inmediato (I, S, B, U, J)
    output reg [1:0] modo_alu,       // modo para control_alu (00: suma, 01: I, 10: R, 11: branch)
    output reg [1:0] sel_op1,
    output reg [1:0] sel_op2,
    output reg [1:0] sel_y,

    input      [6:0] op,             // opcode de la instrucción (inst[6:0])
    input       reset,
    input       clk
); 

//Definincion de estados
    parameter [2:0] ESCRIBE = 0;
    parameter [2:0] CARGA = 1;
    parameter [2:0] DECODIFICA = 2;
    parameter [2:0] DIRECCION = 3;
    parameter [2:0] MEMORIA_EJECUTA = 4;

    reg [2:0] estado_sig, estado;

    //Registro de estado
    always @ (posedge clk)
    begin
        if(reset)
            estado <= ESCRIBE;
        else
            estado <= estado_sig;
    end

    //logica estado siguiente
    always @(*)
    begin
        case (estado)

            ESCRIBE         : estado_sig = CARGA;
            CARGA           : estado_sig = DECODIFICA;
            DECODIFICA      : estado_sig = DIRECCION;
            DIRECCION       : estado_sig = MEMORIA_EJECUTA;
            MEMORIA_EJECUTA : estado_sig = ESCRIBE;
            default         : estado_sig = ESCRIBE; 

        endcase
    end

      always @ (*) begin
// Lógica de salidas (combinacional)
// - Primero: valores por defecto (todo en cero)
// - Luego, según el estado (y a veces el opcode),
//   se activan las señales que correspondan.            
            esc_pc        = 0;
            branch        = 0;
            sel_dir       = 0;
            esc_mem       = 0;
            esc_reg       = 0;
            esc_inst      = 0;
            sel_inmediato = 0;
            modo_alu      = 0;
            sel_op1       = 0;
            sel_op2       = 0;
            sel_y         = 0;    

// Comportamiento según el estado

            case(estado)
            CARGA: begin 
            // - inst* = mem[PC]
            // - pc_inst* = PC        
            // - PC* = PC + 4
                  esc_inst = 1'b1;    // cargar registro de instrucción con dat_lectura
                sel_op1  = 2'b00;   // A = PC
                sel_op2  = 2'b10;   // B = 4
                modo_alu = 2'b00;   // suma
                sel_y    = 2'b01;   // Y = salida de la ALU (PC + 4)
                esc_pc   = 1'b1;    // PC* = PC + 4
            end

            DECODIFICA: ;
             // - Lectura de rs1 y rs2 desde el banco de registros
            //se mantienen los valores por defecto y espero un ciclo para que se carguen los registros
       
            DIRECCION: 
            // - Cálculo de direcciones / PC + inmediato
            //   según tipo de instrucción.
                case(op)
                19,23,51,55: ;                //I aritmetica, AUIPC, R, LUI, No hacen nada

                //Para los que acceden a memoria
                 // LOAD (3) y JALR (103)
                 // - I: dir = rs1 + imm_I
                3,103: begin                // instrucciones tipo I
                   sel_inmediato = 3'b000;  // inmediato tipo I
                   sel_op2       = 2'b01;   // B = valor inmediato
                   sel_op1       = 2'b10;   // A = Rs1
                   modo_alu      = 2'b00;   // suma (dir = rs1 + imm)
                end
                
                // STORE (35)
                // - S: dir = rs1 + imm_S
                35: begin               // instrucción tipo S
                    sel_inmediato = 3'b001;  // inmediato tipo S
                    sel_op2       = 2'b01;   // B = valor inmediato
                    sel_op1       = 2'b10;   // A = Rs1
                    modo_alu      = 2'b00;   // suma
                end
                
                // BRANCH (99)
                // - B: target = PC + imm_B
                99: begin                       // instrucción tipo B
                    sel_inmediato = 3'b010;  // inmediato tipo B
                    sel_op2       = 2'b01;   // B = valor inmediato
                    sel_op1       = 2'b01;   // A = PC actual
                    modo_alu      = 2'b00;   // suma (PC + imm_B)
                end
                
                // JAL (111)
                // - J: target = PC + imm_J
                111: begin                 // instrucción tipo J
                    sel_inmediato = 3'b100;  // inmediato tipo J
                    sel_op2       = 2'b01;   // B = valor inmediato
                    sel_op1       = 2'b01;   // A = PC actual
                    modo_alu      = 2'b00;   // suma (PC + imm_J)
                end
                endcase

            MEMORIA_EJECUTA:            
            // - LOAD/STORE: usan la dirección calculada
            // - BRANCH: comparan rs1/rs2 y, si corresponde, actualizan PC
            // - R/I/U: hacen operación ALU
            // - JAL/JALR: actualizan PC y preparan PC+4 para link

                case(op)

                
                // LOAD (3) (INSTRUCCION 3 TIPO B)
                // - usa dirección calculada
                //   en el estado DIRECCION
                3 : begin                       
                    sel_y   = 2'b10;            //Y = salida retardada    
                    sel_dir = 1'b1;             //dirección memoria = Y (no PC)
                                                // Se espera un ciclo para que la RAM coloque el dato en dat_lectura.
                end  
                
                // STORE (35)
                // - usa dirección calculada
                //   y escribe rs2 en memoria
                35 : begin                     
                    sel_y   = 2'b10;            // Y = salida retardada
                    sel_dir = 1'b1;             // dirección memoria = Y
                    esc_mem = 1'b1;             // habilita escritura en memoria 
                end                             //el dat_escritura esta en dat_2 es RS2 porque ya esta cableado directo
                
                
                // BRANCH (99)
                // - decide si actualizar PC
                99: begin                       
                    sel_y = 2'b10;              // Y = PC + imm_B
                        branch  = 1'b1;         // habilita lógica condicional de PC
                        sel_op1 = 2'b10;        // A = RS1   (para comparar)
                        sel_op2 = 2'b00;        // B = RS2   (para comparar)
                        modo_alu= 2'b11;        // modo branch en control_alu
                end


                // OP-IMM (19) - tipo I aritmético
                19: begin      
                        sel_inmediato = 3'b000;  // tipo I
                        sel_op2       = 2'b01;   // B = inmediato
                        sel_op1       = 2'b10;   // A = RS1
                        modo_alu      = 2'b01;   // modo especial I    
                end 

                // OP (51) - tipo R
                51: begin         
                        sel_op2  = 2'b00; // B = RS2
                        sel_op1  = 2'b10; // A = RS1
                        modo_alu = 2'b10; // modo R
                end  
                
                // AUIPC (23) - tipo U
                // - resultado = PC + imm_U
                23: begin                 
                        sel_inmediato = 3'b011;  // tipo U
                        sel_op1       = 2'b01;   // A = PC (pc_inst)
                        sel_op2       = 2'b01;   // B = inmediato U
                        modo_alu      = 2'b00;   // suma
                end   

                
                // LUI (55) - tipo U
                // - resultado = imm_U
                55: begin      
                        sel_inmediato = 3'b011;  // tipo U
                        sel_op1       = 2'b11;   // A = 0
                        sel_op2       = 2'b01;   // B = inmediato U
                        modo_alu      = 2'b00;   // suma
                end   

                
                // JALR (103) y JAL (111)
                103,111: begin
                        sel_y    = 2'b10;  // Y = salida de la ALU del ciclo anterior
                        esc_pc   = 1'b1;   // habilita escritura en PC
                        sel_op2  = 2'b10;  // B = 4
                        sel_op1  = 2'b01;  // A = PC actual
                        modo_alu = 2'b00;  // suma 
                end
                endcase
            ESCRIBE:            
            // - Escribe en banco de registros (rd)
            //    resultados de ALU (R, I, U, J)
            //    resultados de memoria (LOAD)

                case(op)
                
                19,23,51,55,103,111 : begin
                        sel_y   = 2'b10; // Y = salida retardada (resultado ALU)
                        esc_reg = 1'b1;  // escribe en registro destino (rd)
                        end
                
            // LOAD (3)
            // - escribe en rd el dato de memoria
                3: begin
                        sel_y   = 2'b00; // Y = dato de memoria (dat_lectura)
                        esc_reg = 1'b1;  // escribe en rd
                        
            // STORE (35) y BRANCH (99) no escriben rd

                end
                endcase
            endcase
        end
endmodule