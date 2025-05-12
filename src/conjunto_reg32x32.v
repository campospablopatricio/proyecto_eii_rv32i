//- Describir en lenguaje de descripción de hardware y evaluar mediante simulación las siguientes memorias:
//- Conjunto de registros de 32x32 bit de tres puertos sincrónicos, dos de lectura y uno de escritura. 
//El registro cero será de solo lectura y su valor será siempre '0'.

module conjunto_reg32x32 (
  input clk,
  input rst,
  input write_enable,
  input [4:0] addr1, addr2, write_addr,
  input [31:0] write_data,
  output [31:0] data1, data2
);

  reg [31:0] memoria [31:0];

  integer i;

  // Inicialización en caso de reset
  always @(posedge clk or posedge rst)
    if (rst)
      for (i = 0; i < 32; i = i + 1)
        memoria[i] <= 0;                //si es rst es 1 pone todo el banco de registros en cero.
    else if (write_enable && write_addr != 0)// write_addr no puede ser 0 
      memoria[write_addr] <= write_data;

  assign data1 = (addr1 != 0) ? memoria[addr1] : 0;
  assign data2 = (addr2 != 0) ? memoria[addr2] : 0;

endmodule
