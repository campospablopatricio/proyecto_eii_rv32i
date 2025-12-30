`include "valor_inmediato.v"
`include "control_ALU.v"
`include "condicion_branch.v"
`include "reg32.v"
`include "mef.v"
`include "alu.v"
`include "conjunto_reg32x32.v"

module cpu (
    input               clk,
    input               reset,
    input       [31:0]  dat_lectura,

    output              hab_escritura,
    output      [31:0]  dir,
    output      [31:0]  dat_escritura
   
); 

wire        esc_pc;
wire        branch;
wire        sel_dir;
wire        esc_inst;
wire        esc_reg;

wire [2:0]  sel_inmediato;
wire [1:0]  modo_alu;
wire [1:0]  sel_y;
wire [1:0]  sel_op1;
wire [1:0]  sel_op2;


wire        z_branch;     // condición de branch (según funct3)
wire        z;            // flag zero de la ALU
wire        hab_pc;       // habilitación real del PC (esc_pc o branch tomado)


wire [31:0] pc;           // PC actual
wire [31:0] pc_inst;      // PC latcheado de la instrucción (para saltos/branches)
wire [31:0] inst;         // instrucción latcheada (IR)

wire [31:0] rs1;          // salida regfile puerto 1
wire [31:0] rs2;          // salida regfile puerto 2

wire [31:0] inmediato;    // inmediato extendido según tipo
wire [3:0]  fn_alu;       // función ALU (salida control_alu)

wire [31:0] y_alu;        // salida ALU 
wire [31:0] y_alu_r;      // salida ALU  (retardada 1 ciclo)

reg  [31:0] y;            // resultado final hacia PC
reg  [31:0] op1;          // operando A a la ALU 
reg  [31:0] op2;          // operando B a la ALU 

  
// - Si esc_pc: el control pide actualizar PC (fetch / jump, etc.)
// - Si branch: depende del match entre z_branch y z (por ~^)
// --------------------------------------------------------
assign hab_pc = (esc_pc | (branch & (z_branch ~^ z)));


reg32 R_pc (
        .rst  (reset),
        .clk  (clk),
        .load (hab_pc),
        .q    (pc),
        .d    (y)
);


// MUX de dirección a memoria
// - sel_dir = 0 => dir = PC        (fetch instrucción)
// - sel_dir = 1 => dir = Y         (acceso a datos / dirección efectiva)
// --------------------------------------------------------
assign dir = sel_dir ? y : pc;

// PC de instrucción (latchea el PC cuando se carga la instrucción)
    
reg32 R_pc_inst (
        .rst  (1'b0),
        .clk  (clk),
        .load (esc_inst),
        .q    (pc_inst),
        .d    (pc)
);


// Registro de instrucción (IR)
// - Carga dat_lectura cuando esc_inst está activo
// --------------------------------------------------------
reg32 R_inst (
        .rst  (1'b0),
        .clk  (clk),
        .load (esc_inst),
        .q    (inst),
        .d    (dat_lectura)
);

// Banco de registros (x0..x31)
// - Lecturas: rs1, rs2
conjunto_reg32x32 dut (
        .clk     (clk),
        .rst     (reset),

        // Escritura
        .hab_w   (esc_reg),
        .addr_w  (inst[11:7]),
        .data_w  (y),

        // Lectura 1 (rs1)
        .hab_r1  (1'b1),
        .addr_r1 (inst[19:15]),
        .data_r1 (rs1),

        // Lectura 2 (rs2)
        .hab_r2  (1'b1),
        .addr_r2 (inst[24:20]),
        .data_r2 (rs2)
    );
// Dato a escribir en memoria (store)
assign dat_escritura = rs2;


valor_inmediato valor_inmediato (
        .inst      (inst),
        .tipo      (sel_inmediato),
        .inmediato (inmediato)
);

// Control de ALU (decodifica funct3/funct7 según modo)
control_alu control_alu (
        .sel_alu (fn_alu),
        .funct3  (inst[14:12]),
        .funct7  (inst[31:25]),
        .modo    (modo_alu)
    );

condicion_branch condicion_branch (
        .z_branch (z_branch),
        .funct3   (inst[14:12])
    );

mef mef_control (
        .esc_pc        (esc_pc),
        .branch        (branch),
        .sel_dir       (sel_dir),
        .esc_mem       (hab_escritura),
        .esc_reg       (esc_reg),
        .esc_inst      (esc_inst),
        .sel_inmediato (sel_inmediato),
        .modo_alu      (modo_alu),
        .sel_op1       (sel_op1),
        .sel_op2       (sel_op2),
        .sel_y         (sel_y),
        .op            (inst[6:0]),
        .reset         (reset),
        .clk           (clk)
    );

alu alu (
        .Y    (y_alu),
        .zero (z),
        .a    (op1),
        .b    (op2),
        .sel  (fn_alu)
    );

// MUX operando 1 de ALU (sel_op1)
// 00: PC
// 01: PC_INST
// 10: RS1
// 11: (constante / no usado)
// --------------------------------------------------------
always @(*) begin
        case (sel_op1)
            2'b00: op1 = pc;
            2'b01: op1 = pc_inst;
            2'b10: op1 = rs1;
            2'b11: op1 = 2'b00;
        endcase
end

// MUX operando 2 de ALU (sel_op2)
// 00: RS2
// 01: INMEDIATO
// 10: 4
// --------------------------------------------------------
always @(*) begin
        case (sel_op2)
            2'b00: op2 = rs2;
            2'b01: op2 = inmediato;
            2'b10: op2 = 4;
            2'b11: op2 = 2'b00;
        endcase
end

reg32 R_y_retardado (
        .rst  (1'b0),
        .clk  (clk),
        .load (1'b1),
        .q    (y_alu_r),
        .d    (y_alu)
    );
// MUX final hacia bus Y (sel_y)
// 00: dat_lectura (LW / lectura de memoria)
// 01: y_alu       (resultado ALU directo)
// 10: y_alu_r     (resultado ALU registrado)
// --------------------------------------------------------
always @(*) begin
        case (sel_y)
            2'b00: y = dat_lectura;
            2'b01: y = y_alu;
            2'b10: y = y_alu_r;
            2'b11: y = 2'b00;
        endcase
end

endmodule