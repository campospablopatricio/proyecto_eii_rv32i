module ram #(parameter archivo = "") (
    output reg [31:0] dout,    // Salida de datos de 32 bits
    input      [ 8:0] addr,    // Dirección de 9 bits
    input      [31:0] din,     // Entrada de datos de 32 bits
    input             write_en,// Habilitación de escritura
    input             clk      
);

    reg [31:0] mem [0:511];

    // Inicialización de la memoria desde un archivo (si se proporciona)
    initial begin
        if (archivo != "") begin
            $readmemh(archivo, mem, 0, 511);
        end
    end

 always @(posedge clk) begin
        if (write_en) begin
            mem[addr] <= din;  // Escribe el dato en la dirección especificada
        end
        dout <= mem[addr];     // Lee el dato de la dirección especificada
    end

endmodule