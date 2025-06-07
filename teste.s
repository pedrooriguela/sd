    .section .text
    .globl _start

_start:
    #--- Teste de LUI: carrega 0x12345<<12 em x5
    lui  x5, 0x12345       # x5 = 0x12345000

    #--- Teste de JAL: salva link em x6 e salta para label_jal
    jal  x6, label_jal     # x6 = PC+4, PC ← label_jal
    addi x7, x0, 1         # (1) deve ser SKIPPED

label_after_jal:
    # aqui voltamos após o JALR em label_jal
    addi x7, x0, 2         # (2) executado depois do retorno
    jal  x0, exit          # laço infinito para encerrar

label_jal:
    # verifica o valor de LUI em x5, copia p/ x2
    addi x2, x5, 0         # x2 = x5

    #--- Teste de JALR: salva link em x3 e retorna a label_after_jal
    jalr x3, x6, 0         # x3 = PC+4, PC ← x6
    addi x7, x0, 3         # (3) deve ser SKIPPED

exit:
    jal  x0, exit          # laço infinito