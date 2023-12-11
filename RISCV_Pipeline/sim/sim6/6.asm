lw x0, 70(x0) // x0 = 0 expected
lw x1, 70(x0) // x1 = 128
lh x2, 70(x0) // x2= 128
lw x3, 69(x0) // x3 = 176
lb x4, 69(x0) // x4 = 176
addi x5, x0, 110 // x5 = 110
add x6,x5,x3 // x6 = 286
sub x7,x5,x3 // x7 = -66
addi x8,x7,20 // x8 = -46
or x9,x6,x5