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
    output is_lui,
    output is_jal,
    output is_jalr,
    output is_auipc,
    output branch_confirm,
    );
    // Definição dos opcodes (conforme ISA RISC-V)
    localparam R_TYPE    = 7'b0110011;  // ADD
    localparam I_TYPE    = 7'b0010011;  // ADDI
    localparam BRANCH    = 7'b1100011;  // BEQ

    localparam JAL = 7'b1101111;
    localparam JALR = 7'b1100111;
    localparam LUI = 7'b0110111;
    localparam AUIPC = 7'b0010111;

    
    // Detecção dos tipos de instrução
    wire is_rtype = (opcode == R_TYPE);
    wire is_itype = (opcode == I_TYPE);
    wire is_branch = (opcode == BRANCH);

    assign is_jal = (opcode == JAL);
    assign is_jalr = (opcode == JALR);
    assign is_lui = (opcode == LUI);
    assign is_auipc = (opcode == AUIPC);
    
    // Sinais de controle
    assign branch   = is_branch;
    assign mem2reg  = 1'b0;        // Não usamos load no fibonacci
    assign memwrite = 1'b0;        // Não usamos store no fibonacci
    assign alusrc   = is_itype | is_jalr | is_lui;    // Usa imediato para ADDI e JALR
    assign regwrite = is_rtype | is_itype | is_jal | is_jalr | is_lui;  // ADD, ADDI, JAL e JALR escrevem no banco de registradores
    
    // Operação da ALU
    // Para ADD/ADDI: ALUctl = 0010 (soma)
    // Para BEQ: ALUctl = 0110 (subtração para testar igualdade)
    assign aluctl = (is_branch | is_jalr | is_lui) ? 4'b0110 : 4'b0010;

    localparam BEQ  = 3'b000; // branch if Equal
    localparam BNE  = 3'b001; // branch if Not Equal
    localparam BLT  = 3'b100; // branch if Less Than (signed)
    localparam BGE  = 3'b101; // branch if Greater or Equal (signed)
    localparam BLTU = 3'b110; // branch if Less Than (unsigned)
    localparam BGEU = 3'b111; // branch if Greater or Equal (unsigned)

    wire is_beq  = (funct3 == BEQ);
    wire is_bne  = (funct3 == BNE);
    wire is_blt  = (funct3 == BLT);
    wire is_bge  = (funct3 == BGE);
    wire is_bltu = (funct3 == BLTU);
    wire is_bgeu = (funct3 == BGEU);

    wire branch_confirm = 
        (is_beq  &&  zero) ||
        (is_bne  && ~zero) ||
        (is_blt  &&  (rd1 < rd2)) ||
        (is_bge  &&  (rd1 >= rd2)) ||
        (is_bltu &&  (rd1 <  rd2)) ||
        (is_bgeu &&  (rd1 >= rd2));

endmodule