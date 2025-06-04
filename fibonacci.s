# Grupo 9
# Pedro Origuela Porto 15484395
# Rafael Dantas Mendonça Carnauskas 15695737

fibonacci: 
addi a0, x0, 6      # Caso em que N = 6 (N>=1)
addi a2, x0, 0
addi a3, x0, 1
addi a4, x0, 1
beq a0, a4, EXIT

LOOP: 
addi a5, a3, 0    #Loop para calcular o próximo número de Fibonacci
add a3, a3, a2
addi a2, a5, 0
addi a0, a0, -1
beq a0, a4, OUT
beq x0, x0, LOOP

OUT:
add a0, a3, x0     # retorna o valor de a3 em a0

EXIT:
beq x0, x0, EXIT    # fim