`include "cpu.v"
`include "ram.v"
module sim_cpu ;
    integer i;
    wire hab_escritura;
    wire [31:0] dir;    
    wire [31:0] dat_escritura;
    wire [31:0] dat_lectura;
    reg clk;        
    reg reset;

    cpu dut (
        .hab_escritura(hab_escritura),
        .dir(dir),
        .dat_escritura(dat_escritura),
        .dat_lectura(dat_lectura),
        .clk(clk),
        .reset(reset)
    );

    ram #(.archivo("../src/programa_prueba.mem")) ram (
        .dout(dat_lectura),    
        .addr(dir[10:2]),    
        .din (dat_escritura),    
        .write_en(hab_escritura),
        .clk (clk)    

    );

//reloj
    initial begin
        clk = 0;
        forever #10 clk = !clk;
    end

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0);
        for(i=0;i<17;i=i+1) $dumpvars(0,ram.mem[i]);
        reset=1;
        @(posedge clk) #5 reset=0;
        for (i=0;i<500;i = i + 1) @(posedge clk);
        $finish;
    end

endmodule