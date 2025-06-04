`timescale 1ns/1ps
module poliriscv_sc_tb;

    localparam CLKP = 10;

    reg clk, rst;

    initial
    begin
        clk = 1'b0;
        forever
            #(CLKP/2) clk = ~clk;
    end

    integer pc;
    initial
    begin
        $dumpfile("polriscv_sc_tb.vcd");
        $dumpvars (0, riscv);
        
        #1 rst = 1'b1;
        #1 rst = 1'b0;
        pc = riscv.pc; #(CLKP);
        while (pc != riscv.pc) begin
            pc = riscv.pc;
            #(CLKP);
        end
        $finish;
    end




    poliriscv_sc #(.instructions(256), .datawords(1024),.IFILE("rom_hex.mem"))
    riscv (.clk(clk), .rst(rst));

endmodule


