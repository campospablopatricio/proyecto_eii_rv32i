`include "mef.v"
module sim_mef ;
    wire esc_pc ;
    wire branch ;
    wire sel_dir ;
    wire esc_mem ;
    wire esc_inst ;
    wire esc_reg ;
    wire [2:0] sel_inmediato ;
    wire [1:0] modo_alu ;
    wire [1:0] sel_op1 ;
    wire [1:0] sel_op2 ;
    wire [1:0] sel_y ;
    reg [6:0] op ;
    reg reset ;
    reg clk ; 
             

    mef dut (
        .esc_pc (esc_pc) ,
        .branch (branch) ,
        .sel_dir (sel_dir) ,
        .esc_mem (esc_mem) ,
        .esc_inst (esc_inst) , 
        .esc_reg (esc_reg ) ,
        .sel_inmediato (sel_inmediato),
        .modo_alu (modo_alu) ,
        .sel_op1 (sel_op1) ,
        .sel_op2 (sel_op2) ,
        .sel_y (sel_y) ,
        .op (op) ,
        .reset (reset) ,
        .clk (clk)          
    );

    initial begin
        clk = 0;
        forever #10 clk = !clk;
    end

    task ciclos;
        input integer n;
        integer i;
    begin 
        for(i=0; i<n ; i=i+1)
            @(posedge clk);
        #5;
    end
    endtask

    initial begin
        $dumpfile("mef.vcd");
        $dumpvars(0);
        reset = 1; op = 7'hxx; ciclos(1);
        reset = 0;
        ciclos(1); 

        op = 3; ciclos(5); //tipo i: carga
        op = 19; ciclos(5); //tipo i: alu inm
        op = 23; ciclos(5); //tipo u: auipc
        op = 35; ciclos(5); //tipo s: store
        op = 51; ciclos(5); //tipo r: alu
        op = 55; ciclos(5); //tipo u: lui
        op = 99; ciclos(5); //tipo b:branch
        op = 103; ciclos(5); //tipo i
        op = 111; ciclos(5); //tipo j
        #10;
        $finish;
    end
endmodule