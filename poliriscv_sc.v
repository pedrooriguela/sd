module poliriscv_sc #(
    parameter instructions = 256,
    parameter datawords = 1024,
    parameter IFILE = "rom_hex.mem"
)(
    input clk,
    input rst
);

    // Declaração dos sinais combinatórios
    wire mem2reg;
    wire memwrite;
    wire alusrc;
    wire regwrite;
    wire [3:0] aluctl;
    wire pcsrc;
    wire zero_comb;
    wire branch_comb;
    
    // Registradores para zero e branch

    wire [31:0] pc;
    wire [31:0] instruction;
    

    datapath #(
        .W(32)
    ) datapath0 (
        .clk(clk),
        .branch(branch_comb),
        .mem2reg(mem2reg),
        .memwrite(memwrite),
        .alusrc(alusrc),
        .regwrite(regwrite),
        .aluctl(aluctl),
        .rst(rst),
        .zero(zero_comb),  // Agora conectamos ao sinal combinatório
        .instruction(instruction),
        .pc(pc)
    );

    control_unit control_unit0 (
        .opcode(instruction[6:0]),
        .funct3(instruction[14:12]),
        .funct7(instruction[31:25]),
        .branch(branch_comb),  // Agora conectamos ao sinal combinatório
        .mem2reg(mem2reg),
        .memwrite(memwrite),
        .zero(zero_comb),
        .alusrc(alusrc),
        .regwrite(regwrite),
        .aluctl(aluctl)
    );

endmodule