`include "conjunto_reg32x32.v"
module sim_conjunto_reg32x32;
    wire [31:0] data1;
    wire [31:0] data2;
    reg  clk;
    reg  write_enable;
    reg  [4:0]  addr1;
    reg  [4:0]  addr2;
    reg  [4:0]  write_addr;
    reg  [31:0] write_data;
 
    conjunto_reg32x32 dut (
        .data1(data1),
        .data2(data2),
        .clk(clk),
        .write_enable(write_enable),
        .addr1(addr1),
        .addr2(addr2),
        .write_addr(write_addr),
        .write_data(write_data)       
    );

    initial begin
        clk = 0;
        forever #5 clk = !clk; 
    end

    initial begin
      $dumpfile("conjunto_reg32x32.vcd"); 
      $dumpvars(0); 

        write_enable = 0;
        addr1 = 0;
        addr2 = 0;
        write_addr = 0;
        write_data = 0;
        @(posedge clk) #1;

        addr1 = 0;
        write_enable = 1;
        write_addr = 0;
        write_data = 32'h5041544F;
        @(posedge clk) #1;

        write_enable = 0;

        @(posedge clk) #1;
        // Escribe registro 1
        write_addr = 5'd1;
        write_data = 32'h5041544F;
        write_enable = 1;
        @(posedge clk) #1;
        // Escribe registro 2
        write_addr = 5'd2;
        write_data = 32'h5041544F;
        write_enable = 1;
        @(posedge clk) #1;
        // No escribe
        write_enable = 0;
        write_data = 0;

        // Lee registros 1 y 2
        addr1 = 1;
        addr2 = 2;
        @(posedge clk) #1;
        @(posedge clk) #1;
        #5;
        $finish;
    end

endmodule