`include "reg32.v"
module sim_reg32 ;
    integer i;
    reg clk;
    reg load;
    reg rst;
    reg [31:0] d;
    wire [31:0] q;
    
    reg32 dut (
        .q (q),
        .clk (clk),
        .load (load),
        .rst(rst),
        .d(d)
    );

    initial begin
        clk = 0;
        forever #10 clk = !clk;
    end

       initial begin
        $dumpfile("reg32.vcd");
        $dumpvars(0);
        rst=1;
        d={32{1'bx}}; //inicia el registro d con un valor indeterminado        
        load=1'bx;

        @(posedge clk) #5;
        rst = 0;
        load = 0; 
        d = 5; 

        @(posedge clk) #5;
        load = 1; 

        @(posedge clk) #5;
        load = 0;
        #5;
        

        $finish;
    end
endmodule