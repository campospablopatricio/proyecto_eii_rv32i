`include "mef.v"
module sim_mef ;
    wire       esc_pc;
    wire       branch;
    wire       sel_dir;
    wire       esc_mem;
    wire       esc_inst;
    wire       esc_reg;
    wire [2:0] sel_inmediato;
    wire [1:0] modo_alu;
    wire [1:0] sel_op1;
    wire [1:0] sel_op2;
    wire [1:0] sel_y;

   
    reg  [6:0] op;
    reg        reset;
    reg        clk;

    mef dut (
        .esc_pc        (esc_pc),
        .branch        (branch),
        .sel_dir       (sel_dir),
        .esc_mem       (esc_mem),
        .esc_inst      (esc_inst),
        .esc_reg       (esc_reg),
        .sel_inmediato (sel_inmediato),
        .modo_alu      (modo_alu),
        .sel_op1       (sel_op1),
        .sel_op2       (sel_op2),
        .sel_y         (sel_y),
        .op            (op),
        .reset         (reset),
        .clk           (clk)
    );


    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    // Tarea para avanzar 'n' ciclos de reloj
    task ciclos;
        input integer n;
        integer i;
    begin 
        for (i = 0; i < n; i = i + 1)
            @(posedge clk);
        #5;
    end
    endtask

    initial begin
        $dumpfile("mef.vcd");
        $dumpvars(0, sim_mef);

        reset = 1'b1;
        op    = 7'hxx;   // opcode indefinido durante el reset
        ciclos(1);       // un ciclo con reset activo

        reset = 1'b0;    // saco el reset
        ciclos(1);       // dejo correr 1 ciclo sin reset

        op = 3;          // tipo I: LOAD (lw)
        ciclos(5);

        op = 19;         // tipo I: ALU inmediato (addi, etc.)
        ciclos(5);

        op = 23;         // tipo U: AUIPC
        ciclos(5);

        op = 35;         // tipo S: STORE (sw)
        ciclos(5);

        op = 51;         // tipo R: ALU entre registros
        ciclos(5);

        op = 55;         // tipo U: LUI
        ciclos(5);

        op = 99;         // tipo B: BRANCH (beq/bne...)
        ciclos(5);

        op = 103;        // tipo I: JALR
        ciclos(5);

        op = 111;        // tipo J: JAL
        ciclos(5);
        
        #10;
        $finish;
    end
endmodule