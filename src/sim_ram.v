`include "ram.v"
module sim_ram ;
    reg          clk;
    reg  [8:0]  dir_w;
    reg         hab_w;
    reg  [31:0] dat_w;

    reg         hab_r;
    reg  [8:0]  dir_r;
    wire [31:0] dat_r;

    ram dut (
        .clk   (clk),
        .dir_w (dir_w),
        .hab_w (hab_w),
        .dat_w (dat_w),
        .dir_r (dir_r),
        .hab_r (hab_r),
        .dat_r (dat_r)
    );

    initial begin
        clk = 0;
        forever #10 clk = !clk;
    end

    initial begin
        $dumpfile("ram.vcd");
        $dumpvars(0, sim_ram);

// inicializo variables en 0
dir_w = 0;
hab_w = 0;
dat_w = 0;
dir_r= 0;
hab_r= 0;

@(posedge clk);
//escribo un valor
dir_w = 9'd511;
dat_w = 32'hAAAA_AAAA;
hab_w = 1;
@(posedge clk); //se escribe en la posicion 511 el davor de dat_w
hab_w = 0;


// --- LEO PARA CONFIRMAR QUE SE ESCRIBIÓ ---
dir_r = 9'd511;
hab_r = 1;
@(posedge clk);   // dat_r = 0xAAAA_AAAA 

// --- AHORA PRUEBO "NO ESCRITURA" ---
// cambio el dato, pero DEJO hab_w = 0
dir_w = 9'd511;
dat_w = 32'hBBBB_BBBB;
hab_w = 0;
@(posedge clk);   // NO debería escribirse nada

// --- VUELVO A LEER LA MISMA DIRECCIÓN ---
dir_r = 9'd511;
@(posedge clk);   // dat_r DEBE seguir siendo 0xAAAA_AAAA

#10; 
$finish;
        

    end
endmodule