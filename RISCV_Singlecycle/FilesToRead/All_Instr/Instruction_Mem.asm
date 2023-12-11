lui x1, 600
auipc x2, 200
sb x2, 21(x0)
bne x1, x2, 8
addi x3, x0, 30
addi x3, x3, 10
jal x4, 8
addi x3, x0, 20
sub x5, x0, x3
beq x1 , x2, 8
add x6, x1, x2
and x7, x2, x3