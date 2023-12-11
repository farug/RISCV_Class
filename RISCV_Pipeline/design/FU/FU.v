`timescale 1ns / 1ps

module FU (
    input [3:0] FS,
    input [31:0] A,B,
    output V,C,N,Z,L,
    output [31:0] G
);
  
    wire [31:0] O0,O1;
    wire [1:0] H_Sel;

    // FS == 0000 add, 1000 sub, 0010 slt, 0011 sltu, 0100 xor, 0110 or, 0111 and, 0001 sll, 0101 srl, 1101 sra

    ALU alu(.A(A),.B(B),.GS(FS),.G(O0),.V(V),.C(C),.N(N),.Z(Z),.L(L));
    Shifter sh(.B(A),.H_Sel(H_Sel),.rs2(B[4:0]),.H(O1));

    assign G = (FS == 4'b0001 ) ? O1 : (FS == 4'b0101) ? O1 : (FS == 4'b1101) ? O1 : O0;
 
    assign H_Sel=FS[3:2];



endmodule