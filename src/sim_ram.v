`include "ram.v"
module sim_ram ;
    integer i;
    reg        write_en;
    reg        clk;
    reg [8:0] addr;
    reg [31:0] din;  
    wire [31:0] dout;

    ram dut (
        .dout (dout),
        .addr (addr),
        .din (din),
        .write_en(write_en),
        .clk(clk)
    );

    initial begin
        clk = 0;
        forever #10 clk = !clk;
    end

    initial begin
        $dumpfile("ram.vcd");
        $dumpvars(0);

        din = 0;
        addr = 9'd511;
        write_en = 1;
        @(posedge clk) #5; // completa ciclo de escritura
        write_en = 0;
        @(posedge clk) #5; // ciclo de lectura para comprobar

        din = 1;
        addr = 9'd510;
        write_en = 1;
        @(posedge clk) #5; // completa ciclo de escritura
        write_en = 0;
        @(posedge clk) #5; // ciclo de lectura para comprobar

        din = 1;
        addr = 9'd509;
        write_en = 0;
        @(posedge clk) #5; // completa ciclo de escritura
        write_en = 0;
        @(posedge clk) #5; // ciclo de lectura para comprobar

        din = 2;
        addr = 9'd508;
        write_en = 1;
        @(posedge clk) #5; // completa ciclo de escritura
        write_en = 0;
        @(posedge clk) #5; // ciclo de lectura para comprobar
        
       
        #5; 
        $finish;
        

    end
endmodule