`include "valor_inmediato.v"
`include "control_ALU.v"
`include "condicion_branch.v"
`include "reg32.v"
`include "mef.v"
`include "alu.v"
`include "conjunto_reg32x32.v"

module cpu (
    input clk,
    input reset,        
    input [31:0] dat_lectura,
    output hab_escritura,
    output [31:0] dir,
    output [31:0] dat_escritura
   
);

wire        esc_pc;
wire        branch;
wire        z_branch;
wire        sel_dir;
wire        esc_inst;
wire        z;
wire        hab_pc;
wire        esc_reg;
wire [31:0] pc;
wire [31:0] pc_inst;
wire [31:0] inst;
wire [31:0] rs1;
wire [31:0] rs2;
wire [2:0 ] sel_inmediato;
wire [31:0] inmediato;
wire [1:0 ] modo_alu;
wire [3:0 ] fn_alu;
wire [31:0] y_alu;
wire [31:0] y_alu_r;
wire [1:0 ] sel_y;
reg [31:0] y;
wire [1:0 ] sel_op1;
wire [1:0 ] sel_op2;
reg  [31:0] op1;
reg  [31:0] op2;
   
assign hab_pc = (esc_pc | (branch&(z_branch~^z)));

reg32 R_pc(
    .rst(reset),
    .clk(clk),
    .load(hab_pc),
    .q(pc),
    .d(y)
);

assign dir = sel_dir? y : pc;

reg32 R_pc_inst(
    .rst(1'b0),
    .clk(clk),
    .load(esc_inst),
    .q(pc_inst),
    .d(pc)
);

reg32 R_inst(
    .rst(1'b0),
    .clk(clk),
    .load(esc_inst),
    .q(inst),
    .d(dat_lectura)
);

conjunto_reg32x32 conjunto_registros(
    .addr1(inst[19:15]),
    .addr2(inst[24:20]),
    .write_addr(inst[11:7]),
    .write_data(y),
    .clk(clk),
    .write_enable(esc_reg),
    .dato1(rs1),
    .dato2(rs2)
);

assign dat_escritura = rs2;

valor_inmediato valor_inmediato(
    .inst(inst),
    .tipo(sel_inmediato),
    .inmediato(inmediato)
);

control_ALU control_alu(
    .sel_alu(fn_alu),
    .funct3(inst[14:12]),
    .funct7(inst[31:25]),
    .modo(modo_alu)
);
condicion_branch condicion_branch(
    .z_branch(z_branch),
    .funct3(inst[14:12])
);
mef mef_control(
    .esc_pc       (esc_pc),    
    .branch       (branch),
    .sel_dir      (sel_dir),
    .esc_mem      (hab_escritura),
    .esc_reg      (esc_reg),
    .esc_inst     (esc_inst),
    .sel_inmediato(sel_inmediato),
    .modo_alu     (modo_alu),
    .sel_op1      (sel_op1),
    .sel_op2      (sel_op2),
    .sel_y        (sel_y),
    .op           (inst[6:0]),
    .reset        (reset),
    .clk          (clk)
);

alu alu(
    .Y  (y_alu),
    .z  (z),
    .a  (op1),
    .b  (op2),
    .sel(fn_alu)
);

always @(*)begin
    case(sel_op1)
    2'b00: op1 = pc; 
    2'b01: op1 = pc_inst;
    2'b10: op1 = rs1;
    2'b11: op1 = 2'b00;
    endcase
end

always @(*)begin
    case(sel_op2)
    2'b00: op2 = rs2;    
    2'b01: op2 = inmediato; 
    2'b10: op2 = 4;
    endcase
end

reg32 R_y_retardado(
    .rst(1'b0),
    .clk(clk),
    .load(1'b1),
    .q(y_alu_r),
    .d(y_alu)
);

always @(*) begin
       case(sel_y)
        2'b00: y = dat_lectura; 
        2'b01: y = y_alu; 
        2'b10: y = y_alu_r;
       endcase
    end

endmodule