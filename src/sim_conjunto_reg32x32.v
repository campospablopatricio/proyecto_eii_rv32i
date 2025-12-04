`include "conjunto_reg32x32.v"

module sim_conjunto_reg32x32;

    reg         clk;
    reg         rst;

    reg         hab_w;
    reg  [4:0]  addr_w;
    reg  [31:0] data_w;

    reg         hab_r1;
    reg  [4:0]  addr_r1;
    wire [31:0] data_r1;

    reg         hab_r2;
    reg  [4:0]  addr_r2;
    wire [31:0] data_r2;

    conjunto_reg32x32 dut (
        .clk    (clk),
        .rst    (rst),
        .hab_w  (hab_w),
        .addr_w (addr_w),
        .data_w (data_w),
        .hab_r1 (hab_r1),
        .addr_r1(addr_r1),
        .data_r1(data_r1),
        .hab_r2 (hab_r2),
        .addr_r2(addr_r2),
        .data_r2(data_r2)
    );

    // Clock 100 MHz (periodo 10 ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $dumpfile("conjunto_reg32x32.vcd");
        $dumpvars(0, sim_conjunto_reg32x32);

        rst     = 1;
        hab_w   = 0;
        hab_r1  = 0;
        hab_r2  = 0;
        addr_w  = 0;
        addr_r1 = 0;
        addr_r2 = 0;
        data_w  = 32'h0000_0000;

        @(posedge clk); #1;   
        rst = 0;               
        @(posedge clk); #1;

        // 1) Intento de escribir en registro 0 (debe ser ignorado)
        hab_w   = 1;
        addr_w  = 5'd0;
        data_w  = 32'h1111_1111;
        @(posedge clk); #1;    
        hab_w   = 0;
        data_w  = 32'h0000_0000;

        // Leer registro 0 por ambos puertos -> debe ser 0
        hab_r1  = 1;
        hab_r2  = 1;
        addr_r1 = 5'd0;
        addr_r2 = 5'd0;
        @(posedge clk); #1;    

        // 2) Escritura de registros 1 y 2
        hab_w   = 1;
        addr_w  = 5'd1;
        data_w  = 32'h5041_544F;   // "PATO"
        @(posedge clk); #1;

        addr_w  = 5'd2;
        data_w  = 32'hDEAD_BEEF;
        @(posedge clk); #1;

        hab_w   = 0;
        data_w  = 32'h0000_0000;

        // 3) Lectura de registros 1 y 2
        addr_r1 = 5'd1;
        addr_r2 = 5'd2;
        @(posedge clk); #1;   

        @(posedge clk); #1;

        // 4) Lectura del MISMO registro por los dos puertos
        addr_r1 = 5'd1;
        addr_r2 = 5'd1;
        @(posedge clk); #1;

        // 5) Deshabilitar lectura y ver que las salidas se mantienen
        hab_r1 = 0;
        hab_r2 = 0;
        @(posedge clk); #1;

        addr_r1 = 5'd2;
        addr_r2 = 5'd0;
        @(posedge clk); #1;

        #10;
        $finish;
    end

endmodule
