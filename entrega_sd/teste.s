# Inicialização de registradores
addi x1, x0, 10       # x1 = 10
addi x2, x0, 5        # x2 = 5
addi x3, x0, -5       # x3 = -5 (representado em complemento de dois)
addi x4, x0, 0xF0     # x4 = 0xF0

# Testes de operações aritméticas
add x5, x1, x2        # x5 = 15
sub x6, x1, x2        # x6 = 5

# Testes de operações lógicas
and x7, x1, x4        # x7 = 0
or x8, x1, x4         # x8 = 0xFA
xor x9, x1, x4        # x9 = 0xFA

# Testes de shift
slli x10, x1, 2       # x10 = 40 (10 << 2)
srli x11, x4, 4       # x11 = 0xF (0xF0 >> 4)
srai x12, x3, 1       # x12 = -3 (-5 >> 1, preservando sinal)

# Testes de comparação
slt x13, x3, x1       # x13 = 1 (-5 < 10, com sinal)
sltu x14, x3, x1      # x14 = 0 (valor sem sinal de -5 > 10)

# Loop infinito para encerrar o programa
loop:
j loop