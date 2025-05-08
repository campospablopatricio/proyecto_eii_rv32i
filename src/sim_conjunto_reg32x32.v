`include "conjunto_reg32x32.v"
module sim_conjunto_reg32x32;
    wire [31:0] read_data1;
    wire [31:0] read_data2;
    reg  clk;
    reg  write_enable;
    reg  [4:0]  read_addr1;
    reg  [4:0]  read_addr2;
    reg  [4:0]  write_addr;
    reg  [31:0] write_data;
 
    conjunto_reg32x32 dut (
        .read_data1(read_data1),
        .read_data2(read_data2),
        .clk(clk),
        .write_enable(write_enable),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
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
        read_addr1 = 0;
        read_addr2 = 0;
        write_addr = 0;
        write_data = 0;
        @(posedge clk) #1;

        read_addr1 = 0;
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
        read_addr1 = 1;
        read_addr2 = 2;
        @(posedge clk) #1;
        @(posedge clk) #1;
        #5;
        $finish;
    end

endmodule