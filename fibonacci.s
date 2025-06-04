# Grupo 9
# Pedro Origuela Porto 15484395
# Rafael Dantas Mendonça Carnauskas 15695737

fibonacci: 
addi a0, x0, 6  #0               # Caso em que N = 6 (N>=1)   
addi a2, x0, 0  #1                                 
addi a3, x0, 1  #2
addi a4, x0, 1  #3
beq a0, a4, EXIT  #4

LOOP: 
addi a5, a3, 0   #5   #Loop para calcular o próximo número de Fibonacci
add a3, a3, a2  #6
addi a2, a5, 0  #7
addi a0, a0, -1  #8
beq a0, a4, OUT  #9
beq x0, x0, LOOP  #10

OUT:
add a0, a3, x0  #11     # retorna o valor de a3 em a0

EXIT:
beq x0, x0, EXIT  #12    # fim