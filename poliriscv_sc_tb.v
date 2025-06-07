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
                    riscv.datapath0.rf0.registers[2], // a0 (x10)
                    riscv.datapath0.rf0.registers[3], // a2 (x12)
                    riscv.datapath0.rf0.registers[5], // a3 (x13)
                    riscv.datapath0.rf0.registers[6], // a4 (x14)
                    riscv.datapath0.rf0.registers[7]  // a5 (x15)
                    );
        end
        
        // Mostra informações finais
        $display("\n=== Fim da simulação após %0d ciclos ===", i);
        $display("PC final = 0x%h", riscv.pc);
        $display("Valores finais dos registradores:");
        $display("a0 (2) = 0x%h", riscv.datapath0.rf0.registers[2]);
        $display("a2 (3) = 0x%h", riscv.datapath0.rf0.registers[3]);
        $display("a3 (5) = 0x%h", riscv.datapath0.rf0.registers[5]);
        $display("a4 (6) = 0x%h", riscv.datapath0.rf0.registers[6]);
        $display("a5 (7) = 0x%h", riscv.datapath0.rf0.registers[7]);
        
        $finish;
    end

    poliriscv_sc #(.instructions(256), .datawords(1024), .IFILE("rom_hex.mem"))
    riscv (.clk(clk), .rst(rst));

endmodule