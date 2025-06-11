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

    localparam ADD = 3'b000;
    localparam SUB = 3'b000;
    localparam XOR = 3'b100;
    localparam OR = 3'b110;
    localparam AND = 3'b111;
    localparam SHIFT_LL  = 3'b001;
    localparam SHIFT_RL = 3'b101;
    localparam SHIFT_RA = 3'b101;
    localparam SET_LTS = 3'b010; // signed
    localparam SET_LTU = 3'b011; // unsinged
    

    
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
    

    // Sinais da alu
    wire is_add = (funct3 == ADD) && (funct7 == 7'h00); //
    wire is_sub = (funct3 == SUB) && (funct7 == 7'h20); //
    wire is_xor = (funct3 == XOR); 
    wire is_or = (funct3 == OR); //
    wire is_and = (funct3 == AND); //
    wire is_shift_ll = (funct3 == SHIFT_LL);
    wire is_shift_rl = (funct3 == SHIFT_RL);
    wire is_shift_ra = (funct3 == SHIFT_RA);
    wire is_set_lts = (funct3 == SET_LTS) && (funct7 == 7'h00); //
    wire is_set_ltu = (funct3 == SET_LTU && (funct7 == 7'h20)); //

    assign aluctl = is_and ? 4'b0000 :
                    is_or ? 4'b0001 :
                    is_add ? 4'b0010 :
                    is_sub ? 4'b0011 :
                    is_set_ltu ? 4'b0100 :
                    is_set_lts ? 4'b0101 :
                    is_xor ? 4'b0110 :
                    is_shift_ll ? 4'b0111 :
                    is_shift_rl ? 4'b1000 :
                    4'b1001; // shift right arithmetic 

endmodule