//simulacion control_alu
//el modo 00 hace la suma, modo 01 instruccion tipo 19, modo 10 instruccion tipo 51 y modo 11 instuccion tipo 99

`include "control_alu.v"

module sim_control_alu;
    integer i;
    reg  [1:0] modo; 
    reg  [2:0] funct3;
    reg  [6:0] funct7;
    wire [3:0] sel_alu;

    control_alu dut (
        .modo (modo),
        .funct3 (funct3),
        .funct7 (funct7),
        .sel_alu (sel_alu)
    );

    initial begin
        $dumpfile("control_alu.vcd");
        $dumpvars(0);
        
        modo = 2'b00;
        funct7 = 7'bxxxxxxx;
        funct3 = 3'bxxx;
        #10;

        modo = 2'b01;
        funct3 = 3'b000;funct7[5]=1'bx;#10;
        funct3 = 3'b001;funct7[5]=1'b0;#10;
        funct3 = 3'b010;funct7[5]=1'bx;#10;
        funct3 = 3'b011;funct7[5]=1'bx;#10;
        funct3 = 3'b100;funct7[5]=1'bx;#10;
        funct3 = 3'b101;funct7[5]=1'b0;#10;
        funct3 = 3'b101;funct7[5]=1'b1;#10;
        funct3 = 3'b110;funct7[5]=1'bx;#10;
        funct3 = 3'b111;funct7[5]=1'bx;#10;

        modo = 2'b10;
        funct3 = 3'b000;funct7[5]=1'b0;#10;
        funct3 = 3'b000;funct7[5]=1'b1;#10;
        funct3 = 3'b001;funct7[5]=1'b0;#10;
        funct3 = 3'b010;funct7[5]=1'b0;#10;
        funct3 = 3'b011;funct7[5]=1'b0;#10;
        funct3 = 3'b100;funct7[5]=1'b0;#10;
        funct3 = 3'b101;funct7[5]=1'b0;#10;
        funct3 = 3'b101;funct7[5]=1'b1;#10;
        funct3 = 3'b110;funct7[5]=1'b0;#10;
        funct3 = 3'b111;funct7[5]=1'b0;#10;

        modo = 2'b11;
        funct7[5]=1'bx;
        funct3 = 3'b000;#10;
        funct3 = 3'b001;#10;
        funct3 = 3'b100;#10;
        funct3 = 3'b101;#10;
        funct3 = 3'b110;#10;
        funct3 = 3'b111;#10;
        #10;
    end
endmodule