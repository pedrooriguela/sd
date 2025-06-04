module control_unit(
    input [6:0] opcode,
    input [2:0] funct3,
    input [6:0] funct7,
    input zero,
    output mem2reg,
    output memwrite,
    output alusrc,
    output regwrite,
    output [3:0] aluctl,
    output branch,
    output pcsrc
);
    // Definição dos opcodes (conforme ISA RISC-V)
    localparam R_TYPE    = 7'b0110011;  // ADD
    localparam I_TYPE    = 7'b0010011;  // ADDI
    localparam BRANCH    = 7'b1100011;  // BEQ

    
    // Detecção dos tipos de instrução
    wire is_rtype = (opcode == R_TYPE);
    wire is_itype = (opcode == I_TYPE);
    wire is_branch = (opcode == BRANCH);
    
    // Sinais de controle
    assign branch   = is_branch;
    assign mem2reg  = 1'b0;        // Não usamos load no fibonacci
    assign memwrite = 1'b0;        // Não usamos store no fibonacci
    assign alusrc   = is_itype;    // Usa imediato apenas para ADDI
    assign regwrite = is_rtype | is_itype;  // ADD e ADDI escrevem no banco de registradores
    
    // Operação da ALU
    // Para ADD/ADDI: ALUctl = 0010 (soma)
    // Para BEQ: ALUctl = 0110 (subtração para testar igualdade)
    assign aluctl = is_branch ? 4'b0110 : 4'b0010;
    
    // Controle de salto: só salta se for instrução de branch E a condição for verdadeira
    assign pcsrc = branch & zero;

endmodule