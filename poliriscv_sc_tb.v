`timescale 1ns/1ps
module poliriscv_sc_tb;

    localparam CLKP = 10;

    reg clk, rst;

    initial begin
        clk = 1'b0;
        forever
            #(CLKP/2) clk = ~clk;
    end

    integer i; // Contador de ciclos
    integer j; // Para iterar pela memória
    
    initial begin
        $dumpfile("polriscv_sc_tb.vcd");
        $dumpvars(0, riscv);
        
        // Dump da memória de instruções
        $display("\n=== CONTEÚDO DA MEMÓRIA DE INSTRUÇÕES ===");
        $display("Endereço\tInstrução (hex)");
        for (j = 0; j < 64; j = j + 1) begin
            $display("0x%h\t0x%h", j*4, riscv.datapath0.im0.data[j]);
        end
        
        // Reset inicial
        rst = 1'b1;
        #(CLKP) rst = 1'b0;
        
        // Cabeçalho
        $display("\n=== Iniciando simulação do RISC-V por 100 ciclos ===");
        $display("Ciclo\tPC\t\tInstrução\t\tZero\tBranch\tPCSrc\ta0\t\ta2\t\ta3\t\ta4\t\ta5");
        
        // Executa por até 100 ciclos
        for (i = 0; i < 100; i = i + 1) begin
            // Espera um ciclo de clock completo
            #(CLKP);
            
            // Mostra informações do estado atual
            $display("%0d\t0x%h\t0x%h\t%b\t%b\t%b\t0x%h\t0x%h\t0x%h\t0x%h\t0x%h", 
                    i, 
                    riscv.pc, 
                    riscv.instruction,
                    riscv.zero_comb,
                    riscv.branch_comb,
                    riscv.pcsrc,
                    riscv.datapath0.rf0.registers[10], // a0 (x10)
                    riscv.datapath0.rf0.registers[12], // a2 (x12)
                    riscv.datapath0.rf0.registers[13], // a3 (x13)
                    riscv.datapath0.rf0.registers[14], // a4 (x14)
                    riscv.datapath0.rf0.registers[15]  // a5 (x15)
                    );
        end
        
        // Mostra informações finais
        $display("\n=== Fim da simulação após %0d ciclos ===", i);
        $display("PC final = 0x%h", riscv.pc);
        $display("Valores finais dos registradores:");
        $display("a0 (x10) = 0x%h", riscv.datapath0.rf0.registers[10]);
        $display("a2 (x12) = 0x%h", riscv.datapath0.rf0.registers[12]);
        $display("a3 (x13) = 0x%h", riscv.datapath0.rf0.registers[13]);
        $display("a4 (x14) = 0x%h", riscv.datapath0.rf0.registers[14]);
        $display("a5 (x15) = 0x%h", riscv.datapath0.rf0.registers[15]);
        
        $display("x0  = 0x%h", riscv.datapath0.rf0.registers[0]);
        $display("x1  = 0x%h", riscv.datapath0.rf0.registers[1]);
        $display("x2  = 0x%h", riscv.datapath0.rf0.registers[2]);
        $display("x3  = 0x%h", riscv.datapath0.rf0.registers[3]);
        $display("x4  = 0x%h", riscv.datapath0.rf0.registers[4]);
        $display("x5  = 0x%h", riscv.datapath0.rf0.registers[5]);
        $display("x6  = 0x%h", riscv.datapath0.rf0.registers[6]);
        $display("x7  = 0x%h", riscv.datapath0.rf0.registers[7]);
        $display("x8  = 0x%h", riscv.datapath0.rf0.registers[8]);
        $display("x9  = 0x%h", riscv.datapath0.rf0.registers[9]);
        $display("x10 = 0x%h", riscv.datapath0.rf0.registers[10]);
        $display("x11 = 0x%h", riscv.datapath0.rf0.registers[11]);
        $display("x12 = 0x%h", riscv.datapath0.rf0.registers[12]);
        $display("x13 = 0x%h", riscv.datapath0.rf0.registers[13]);
        $display("x14 = 0x%h", riscv.datapath0.rf0.registers[14]);
        $display("x15 = 0x%h", riscv.datapath0.rf0.registers[15]);
        
        $finish;
    end

    poliriscv_sc #(.instructions(256), .datawords(1024), .IFILE("rom_hex.mem"))
    riscv (.clk(clk), .rst(rst));

endmodule