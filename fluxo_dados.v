// 15484395 Pedro Origuela Porto
// 15695737 Rafael Dantas Mendonça Carnauskas
// os modulos da alu e do registerfile ja estão neste arquivo

module alu

  #(parameter W = 32)

(

  input  [3:0]   ALUctl,

  input  [W-1:0] A, B,
  input          rst,
  output [W-1:0] ALUout,

  output zero

);


assign ALUout = (ALUctl == 4'b0000) ? A & B : 
                  (ALUctl == 4'b0001) ? A | B : 
                  (ALUctl == 4'b0010) ? A + B : 
                  (ALUctl == 4'b0110) ? A - B :
                  (ALUctl == 4'b0111) ? {W{A < B}} :
                  ~(A | B);

assign zero = (ALUout == 0) ? 1'b1 : 1'b0;

endmodule

module registerfile

  #(parameter W = 32)

(

  input  [4  :0] Read1, Read2, WriteReg,

  input  [W-1:0] WriteData,

  input  RegWrite, clk,

  output [W-1:0] Data1, Data2

);

  reg [W-1:0] registers [31:1];
  integer i;

  initial begin
  for ( i = 1; i < 32; i = i + 1)
    registers[i] = 0;
end

  assign Data1 = (Read1 == 5'b00000) ? 0 : registers[Read1];

  assign Data2 = (Read2 == 5'b00000) ? 0 : registers[Read2];

  always @(posedge clk) begin
    if (RegWrite & WriteReg != 0)
      registers[WriteReg] <= WriteData;
  end

endmodule

module instruction_memory 
  #(parameter W = 32,
    parameter IFILE = "rom_hex.mem")
(
  input [W-1:0] addr,
  input CS, OE, regwrite,
  output reg [31:0] out
);

  reg [7:0] data[1023:0];  // Armazena bytes individuais
  wire [W-1:0] word_addr = addr >> 2;  // Converte endereço para índice de palavras
  integer i;
  
  initial begin
    // Inicializa a memória com zeros
    for (i = 0; i < 1024; i = i + 1)
      data[i] = 8'h0;
    
    // Carrega o arquivo ROM
    $readmemh(IFILE, data);
  end

  always @(addr, CS, OE)
    if (OE==1'b1) begin
            out = {data[word_addr*4], data[word_addr*4+1], 
             data[word_addr*4+2], data[word_addr*4+3]};
    end
    else begin
      out = 32'bz;
    end
endmodule


module imm_gen(
  input [31:0] instruction,  // Recebe a instrução completa
  output reg [31:0] imm_out
);
  wire [6:0] opcode = instruction[6:0];


  always @(*) begin
    case (opcode)
      7'b0010011: // ADDI (tipo I)
        imm_out = {{20{instruction[31]}}, instruction[31:20]};
      7'b1100011: // BEQ (tipo B)
        imm_out = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};
      7'b1101111: // JAL (tipo J)
      imm_out = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};
      7'b0110111: //LUI
      imm_out = {instruction[31:12], 12'b0};
      default:
        imm_out = 32'b0;
    endcase
  end
endmodule

module DataMemory
  #(parameter W = 32)
(
  input [W-1:0] addr,
  input [W-1:0] data_in,
  input memwrite, memread, clk,
  output reg [W-1:0] data_out
);

  reg [W-1:0] memory[31:0];

  always @(posedge clk) begin
    if (memwrite)
      memory[addr] <= data_in;
    if (memread)
      data_out <= memory[addr];
  end
endmodule


module datapath
  #(parameter W = 32,
    parameter IFILE = "rom_hex.mem")
(
  input              clk,
  input              rst,
  // sinais de controle vindos da control_unit
  input              branch,
  input              mem2reg,
  input              memwrite,
  input              alusrc,
  input              regwrite,
  input     [3:0]    aluctl,
  output             zero,
  output    [W-1:0]  instruction,
  output reg  [W-1:0]  pc
);

  wire [W-1:0] imm, next_pc, alu_out, rd1, rd2, memout;
  wire         pcsrc = branch & zero;

  // 3.3) Busca de instrução
  instruction_memory #(.W(W), .IFILE(IFILE)) im0 (
    .addr(pc),
    .CS(1'b1),
    .OE(1'b1),
    .regwrite(regwrite),
    .out(instruction)
  );

  // 3.4) Geração de imediato
  imm_gen ig0 (
    .instruction(instruction),
    .imm_out(imm)
  );

  // 3.5) Arquivo de registradores
  registerfile #(.W(W)) rf0 (
    .Read1(instruction[19:15]),
    .Read2(instruction[24:20]),
    .WriteReg(instruction[11:7]),
    .WriteData(mem2reg ? memout : alu_out),
    .RegWrite(regwrite),
    .clk(clk),
    .Data1(rd1),
    .Data2(rd2)
  );

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      pc <= 0;
    end else if (pcsrc) begin
      pc <= pc + imm; // Atualiza o PC com o valor do imediato
    end
    else begin
      pc <= pc + 4; // Incrementa o PC para a próxima instrução
    end
  end

  wire is_jalr = (instruction[6:0] == 7'b1100111);
  wire is_lui = (instruction[6:0] == 7'b0110111);

  // 3.6) ALU
  wire [W-1:0] alu_src2 = alusrc ? imm : rd2;
  alu ula0 (
    .A(rd1),
    .B(alu_src2),
    .ALUctl(aluctl),
    .ALUout(alu_out),
    .zero(zero)
  );

  // 3.7) Memória de dados
  DataMemory #(.W(W)) dm0 (
    .addr(alu_out),
    .data_in(rd2),
    .memwrite(memwrite),
    .memread(mem2reg),
    .clk(clk),
    .data_out(memout)
  );

  assign WriteData = is_lui ? imm : (mem2reg ? data_mem_out : ula_out);

endmodule
