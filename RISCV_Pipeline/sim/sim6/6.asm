lw x0, 70(x0) # x0 = 0 expected
lw x1, 70(x0) # x1 = 128
lh x2, 70(x0) # x2= 128
lw x3, 69(x0) # x3 = 176
lb x4, 69(x0) # x4 = 176
addi x5, x0, 110 # x5 = 110
add x6,x5,x3 # x6 = 286
sub x7,x5,x3 # x7 = -66
addi x8,x7,20 # x8 = -46
or x9,x6,x5 #x9 = 382
xor x10,x6,x5 #x10 = 368
and x11,x9,x10 #x11 = 368 RAW hazard
sw x6, 44(x0) # Dmem[11] = 286
lw x12, 44(x0) # x12 = 286 Load Use Hazard
andi x13,x12,20 # x13 = 20
sb x6, 39(x0) # Dmem[9][31:23] = 286[7:0] = 30
blt x6,x9,8 # if x6 < x9 pc=pc+8, 1
add x6,x1,x6 # unexecuted instruction ( x6 = 286+128)
xori x6,x6,100 #x6 = 378 if 506 then previous is executed
beq x0,x0,8
add x1,x1,x1 # unexecuted instruction x1 =256
addi x3,x0,3 # x3 = 3
srl x2,x2,x3 # x2 = 16
bne x1,x2,8
add x1 ,x0,x0 # unexecuted instruction (x1=0)
sll x13,x13,x3 # x13 = 160
bge x1,x0,8
add x1 ,x0,x0 # unexecuted instruction (x1=0)
slli x13,x13,1 # x13 = 320
lui x14, 1048575 # x14 = 4294963200() use for unsigned operations
lui x15, 1048574 #x15 = 4294959104() use for unsigned operations
jal x30,8
add x1,x1,x1 #unexecuted instruction
sra x16,x15,x3 # x16 = 4294966272 unsigend
