`include "cpu.v"
`include "ram.v"
module sim_cpu ;
    integer i;
   
    wire        hab_escritura;   // write enable hacia memoria
    wire [31:0] dir;             // dirección (byte address, se usa dir[10:2] como word)
    wire [31:0] dat_escritura;   // dato a escribir (SW)
    wire [31:0] dat_lectura;     // dato leído (instrucción o dato)

    reg clk;
    reg reset;

    cpu dut (
        .hab_escritura (hab_escritura),
        .dir           (dir),
        .dat_escritura (dat_escritura),
        .dat_lectura   (dat_lectura),
        .clk           (clk),
        .reset         (reset)
    );

// RAM: lectura y escritura sincrónicas (iCE40 BRAM)

     ram #(.archivo("../src/programa_prueba.mem")) ram (
        .clk   (clk),

        // Escritura
        .dir_w (dir[10:2]),
        .hab_w (hab_escritura),
        .dat_w (dat_escritura),

        // Lectura (siempre habilitada)
        .dir_r (dir[10:2]),
        .hab_r (1'b1),
        .dat_r (dat_lectura)
    );
//reloj
    initial begin
        clk = 0;
        forever #10 clk = !clk;
    end

    initial begin
        $dumpfile("cpu.vcd");
        $dumpvars(0);
        for (i = 0; i < 17; i = i + 1)
            $dumpvars(0, ram.mem[i]);

        // Reset
        reset = 1;
        @(posedge clk) #5 reset = 0;

        // Ejecución
        for (i = 0; i < 500; i = i + 1)
            @(posedge clk);

        $finish;
    end

endmodule