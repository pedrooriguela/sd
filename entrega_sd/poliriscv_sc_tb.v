`timescale 1ns/1ps

module poliriscv_tb();
    reg clk;
    reg rst;
    
    // Instancia o processador
    poliriscv_sc #(
        .instructions(256),
        .datawords(1024),
        .IFILE("test_program.mem")  // Arquivo que conterá nosso programa de teste
    ) dut (
        .clk(clk),
        .rst(rst)
    );
    
    // Acesso aos sinais internos para monitoramento
    wire [31:0] pc = dut.datapath0.pc;
    wire [31:0] instruction = dut.instruction;
    wire [31:0] alu_out = dut.datapath0.alu_out;
    wire [31:0] rd1 = dut.datapath0.rd1;
    wire [31:0] rd2 = dut.datapath0.rd2;
    wire [31:0] imm = dut.datapath0.imm;
    wire zero = dut.datapath0.zero;
    wire [3:0] aluctl = dut.aluctl;
    
    // Geração do clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Monitoramento e verificação
    initial begin
        $display("Starting RISC-V Processor Test");
        $display("================================");
        
        // Inicializa o processador
        rst = 1;
        #10;
        rst = 0;
        
        // Espera alguns ciclos para as instruções executarem
        #500;
        
        // Verifica registradores específicos para confirmar resultados
        $display("Test Complete - Check register values in waveform viewer");
        
         // Verifica registradores específicos para confirmar resultados
        $display("Test Complete - Verificando os resultados esperados:");
        $display("x1 (Valor esperado 10): %h", dut.datapath0.rf0.registers[1]);
        $display("x2 (Valor esperado 5): %h", dut.datapath0.rf0.registers[2]);
        $display("x3 (Valor esperado -5 / 0xFFFFFFFB): %h", dut.datapath0.rf0.registers[3]);
        $display("x4 (Valor esperado 0xF0): %h", dut.datapath0.rf0.registers[4]);
        $display("x5 (ADD: Valor esperado 15): %h", dut.datapath0.rf0.registers[5]);
        $display("x6 (SUB: Valor esperado 5): %h", dut.datapath0.rf0.registers[6]);
        $display("x7 (AND: Valor esperado 0): %h", dut.datapath0.rf0.registers[7]);
        $display("x8 (OR: Valor esperado 0xFA): %h", dut.datapath0.rf0.registers[8]);
        $display("x9 (XOR: Valor esperado 0xFA): %h", dut.datapath0.rf0.registers[9]);
        $display("x10 (SLL: Valor esperado 40): %d", dut.datapath0.rf0.registers[10]);
        $display("x11 (SRL: Valor esperado 0xF): %h", dut.datapath0.rf0.registers[11]);
        $display("x12 (SRA: Valor esperado -3): %b", dut.datapath0.rf0.registers[12]);
        $display("x13 (SLT: Valor esperado 1): %b", dut.datapath0.rf0.registers[13]);
        $display("x14 (SLTU: Valor esperado 0): %b", dut.datapath0.rf0.registers[14]);

        // Encerra a simulação
        $finish;
    end
    
    // Monitor para observar a execução de instruções
    always @(posedge clk) begin
        if (!rst) begin
            $display("Time: %0t, PC: %h, Instruction: %h", $time, pc, instruction);
            $display("ALU Control: %b, ALU Out: %h, Zero: %b", aluctl, alu_out, zero);
            $display("Register values - RD1: %h, RD2: %h", dut.datapath0.rf0.registers[1], dut.datapath0.rf0.registers[2]);
            $display("--------------------------------------------------");
        end
    end
    
    // Cria arquivo para visualizar forma de onda
    initial begin
        $dumpfile("poliriscv_tb.vcd");
        $dumpvars(0, poliriscv_tb);
    end

endmodule