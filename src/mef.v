//- Diseñar una unidad de control (máquina de estado finito) capaz de ejecutar las instrucciones mencionadas en el 
//apartado anterior.

module mef (
    output reg esc_pc,
    output reg branch,
    output reg sel_dir,
    output reg esc_mem,
    output reg esc_inst,
    output reg esc_reg,
    output reg [2:0] sel_inmediato,
    output reg [1:0] modo_alu,
    output reg [1:0] sel_op1,
    output reg [1:0] sel_op2,
    output reg [1:0] sel_y,
    input      [6:0] op,
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
            ESCRIBE : estado_sig = CARGA;
            CARGA : estado_sig = DECODIFICA;
            DECODIFICA : estado_sig = DIRECCION;
            DIRECCION : estado_sig = MEMORIA_EJECUTA;
            MEMORIA_EJECUTA : estado_sig = ESCRIBE;
            default : estado_sig = ESCRIBE; 
        endcase
    end

      always @ (*) begin
        //valores por defecto
            esc_pc = 0;
            branch = 0;
            sel_dir = 0;
            esc_mem = 0;
            esc_reg = 0;
            esc_inst = 0;
            sel_inmediato = 0;
            modo_alu = 0;
            sel_op1 = 0;
            sel_op2 = 0;
            sel_y = 0;            
            
            case(estado)
            CARGA: begin 
                esc_inst = 1'b1 ;  
                sel_op1  = 2'b00;  
                sel_op2  = 2'b10;  
                esc_pc   = 1'b1 ;  
                sel_y    = 2'b01;  
                modo_alu = 2'b00;  
            end

            DECODIFICA: ;          //se mantienen los valores por defecto y espero un ciclo para que se carguen los registros
            DIRECCION: 
                case(op)
                19,23,51,55: ;                //No hacen nada

                //Para los que acceden a memoria
                3,103: begin                   //instruccion 3 y 103 tipo I
                    sel_inmediato = 3'b000;    //selecciono el tipo I
                    sel_op2       =  2'b01;    //valor inmediato
                    sel_op1       =  2'b10;    //selecciono Rs1
                    modo_alu      =  2'b00;    //modo suma
                end
                35: begin                      //instruccion 35 tipo S
                    sel_inmediato = 3'b001;    //selecciono el tipo S
                    sel_op2       =  2'b01;    //valor inmediato
                    sel_op1       =  2'b10;    //selecciono Rs1
                    modo_alu      =  2'b00;    //modo suma
                end
                99: begin                       //instruccion 99 tipo B
                    sel_inmediato = 3'b010;    //selecciono el tipo B
                    sel_op2       = 2'b01;     //valor inmediato
                    sel_op1       =  2'b01;    //valor actual
                    modo_alu      =  2'b00;    //modo suma
                end
                111: begin                     //instruccion 111 tipo J
                    sel_inmediato = 3'b100;    //selecciono el tipo J
                    sel_op2       =  2'b01;    //valor inmediato
                    sel_op1       =  2'b01;    //valor actual
                    modo_alu      =  2'b00;    //modo suma 
                end
                endcase
            MEMORIA_EJECUTA:
                case(op)
                3 : begin                       //instruccion 3 tipo B, acceso a memoria
                    sel_y   = 2'b10;            //para tener la direccion del ciclo retardado    
                    sel_dir = 1'b1;             //seleccion el resultado que habia quedado en sel_y y no el PC
                                                // espero un ciclo para que lea al estar en la direccion
                end  
                35 : begin                      //acceso a memoria
                    sel_y   = 2'b10;            //para tener la direccion del ciclo retardado
                    sel_dir = 1'b1; 
                    esc_mem = 1'b1;             //para habilitar el acceso a memoria, 
                end                             //el dat_escritura esta en dat_2 es RS2 porque ya esta cableado directo
                99: begin                       //actualiza el pc, no siempre actualizan el PC necesita de la ALU
                    sel_y = 2'b10;
                                                //habilita el PC si z_branchi es igual a Z (XNOR)
                    branch = 1;
                    sel_op1  = 2'b10;           //este va a la ALU
                    sel_op2  = 2'b00;           //este va a la ALU
                    modo_alu = 2'b11;           //instruccion 99
                end
                19: begin                       //instruccion 19 tipo I, Modo especial
                    sel_inmediato = 3'b000;     //selecciono el tipo I
                    sel_op2  = 2'b01;           //salida del valor inmediato
                    sel_op1  = 2'b10;           //Rs1
                    modo_alu = 2'b01;           
                end 
                51: begin                       //instruccion 51 tipo S
                    sel_op2  = 2'b00;           //RS2
                    sel_op1  = 2'b10;           //RS1
                    modo_alu = 2'b10;
                end   
                23: begin                      //instruccion 23 tipo U
                    sel_inmediato = 3'b011;    //selecciono el tipo U
                    sel_op1       = 2'b01;     //pc_inst
                    sel_op2       = 2'b01;     //valor inmediato
                    modo_alu      = 2'b00;     //modo suma
                end   
                55: begin                      //intruccion 55 tipo U
                    sel_inmediato = 3'b011;    //selecciono el tipo U
                    sel_op1       = 2'b11;     //valor 0
                    sel_op2       = 2'b01;     //valor inmediato
                    modo_alu      = 2'b00;     //modo suma
                end   
                103,111: begin
                    sel_y    = 2'b10;          //la salida de la ALU del ciclo anterior
                    esc_pc   = 1'b1;           //para habilitar escritura en PC
                    sel_op2  = 2'b10;          //es la suma de 4
                    sel_op1  = 2'b01;          //valor anterior,calcula la direccion sig y lo guarda
                    modo_alu = 2'b00;          //suma
                end
                endcase
            ESCRIBE:
                case(op)
                19,23,51,55,103,111 : begin
                   sel_y   = 2'b10;             //salida retardada
                   esc_reg = 1'b1;              //habilitacion, guarda el valor del paso anterior de la ALU en el reg de destino
                end
                3: begin
                   sel_y   = 2'b00;
                   esc_reg = 1'b1; 
                end
                endcase
            endcase
        end
endmodule