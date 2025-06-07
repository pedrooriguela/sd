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
    output is_jalr
    );
    // Definição dos opcodes (conforme ISA RISC-V)
    localparam R_TYPE    = 7'b0110011;  // ADD
    localparam I_TYPE    = 7'b0010011;  // ADDI
    localparam BRANCH    = 7'b1100011;  // BEQ

    localparam JAL = 7'b1101111;
    localparam JALR = 7'b1100111;
    localparam LUI = 7'b0110111;

    
    // Detecção dos tipos de instrução
    wire is_rtype = (opcode == R_TYPE);
    wire is_itype = (opcode == I_TYPE);
    wire is_branch = (opcode == BRANCH);

    assign is_jal = (opcode == JAL);
    assign is_jalr = (opcode == JALR);
    assign is_lui = (opcode == LUI);
    
    // Sinais de controle
    assign branch   = is_branch;
    assign mem2reg  = 1'b0;        
    assign memwrite = 1'b0;       
    assign alusrc   = is_itype | is_jalr | is_lui;  
    assign regwrite = is_rtype | is_itype | is_jal | is_jalr | is_lui;  
    
    assign aluctl = (is_branch | is_jalr | is_lui) ? 4'b0110 : 4'b0010;
    

endmodule