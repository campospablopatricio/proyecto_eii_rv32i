// Conjunto de registros 32x32, 2 puertos de lectura y 1 de escritura
// Compatible EBR iCE40
module conjunto_reg32x32 (
    input             clk,
    input             rst,      

    // Puerto de escritura
    input             hab_w,    // write enable
    input      [4:0]  addr_w,   // dirección de escritura (0..31)
    input      [31:0] data_w,   // dato a escribir

    // Puerto de lectura 1
    input             hab_r1,   // read enable 1
    input      [4:0]  addr_r1,  // dirección lectura 1 (0..31)
    output reg [31:0] data_r1,  // dato leído 1

    // Puerto de lectura 2
    input             hab_r2,   // read enable 2
    input      [4:0]  addr_r2,  // dirección lectura 2 (0..31)
    output reg [31:0] data_r2   // dato leído 2
);

    // Dos bancos de memoria: cada uno termina siendo una EBR (SB_RAM40_4K)
    reg [31:0] mem_a [0:31];    // banco para lectura 1
    reg [31:0] mem_b [0:31];    // banco para lectura 2

    // --- ESCRITURA SINCRÓNICA (replicada en ambos bancos) ---
    always @(posedge clk) begin
        if (hab_w && (addr_w != 5'd0)) begin
            mem_a[addr_w] <= data_w;
            mem_b[addr_w] <= data_w;
        end
    end

    // --- LECTURA SINCRÓNICA PUERTO 1 ---
    always @(posedge clk) begin
        if (rst) begin
            data_r1 <= 32'b0;
        end else if (hab_r1) begin
            if (addr_r1 == 5'd0)
                data_r1 <= 32'b0;      // registro 0 siempre 0
            else
                data_r1 <= mem_a[addr_r1];
        end
        // si hab_r1 = 0, data_r1 mantiene su valor anterior
    end

    // --- LECTURA SINCRÓNICA PUERTO 2 ---
    always @(posedge clk) begin
        if (rst) begin
            data_r2 <= 32'b0;
        end else if (hab_r2) begin
            if (addr_r2 == 5'd0)
                data_r2 <= 32'b0;      // registro 0 siempre 0
            else
                data_r2 <= mem_b[addr_r2];
        end
        // si hab_r2 = 0, data_r2 mantiene su valor anterior
    end

endmodule

