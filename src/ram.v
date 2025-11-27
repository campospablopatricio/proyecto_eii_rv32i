module ram #(parameter archivo = "") (
    input             clk,    // reloj de escritura
    input      [8:0]  dir_w,    // dirección de escritura (0..511)
    input             hab_w,    // habilitación de escritura
    input      [31:0] dat_w,    // dato a escribir (32 bits)
    //input             clk_r,    // reloj de lectura
    input      [8:0]  dir_r,    // dirección de lectura (0..511)
    input             hab_r,    // habilitación de lectura
    output reg [31:0] dat_r     // dato leído (32 bits)
);

    reg [31:0] mem [0:511];

    // Inicialización de la memoria desde un archivo
    initial begin
        if (archivo != "") begin
            $readmemh(archivo, mem, 0, 511);
        end
    end

// ESCRITURA SINCRÓNICA (puerto write)
    always @(posedge clk) begin
        if (hab_w) begin
            mem[dir_w] <= dat_w;
        end
    end
 // LECTURA SINCRÓNICA (puerto read)
    always @(posedge clk) begin
        if (hab_r) begin
            dat_r <= mem[dir_r];
        end
        // Si hab_r = 0, dat_r mantiene su valor anterior
    end
endmodule
