`timescale 1ns / 1ps

module ALU (
    input [31:0] A,B,
    input [3:0] GS,
    output [31:0] G,
    output V,C,N,Z,L
);
    wire [31:0] AO,LO;
    wire [1:0] LS;
    wire AS;

    Arithmetic_Unit AU(.A(A),.B(B),.AS(AS),.S(AO),.V(V),.C(C),.N(N),.Z(Z));
    logic_unit LU(.A(A),.B(B),.LS(LS),.S(LO));
    comparator COk(.A(A),.B(B),.L(L));

    assign AS = GS[3]|GS[1];
    assign LS = GS[1:0];

    assign G = (~{32{GS[2]|GS[1]}}&AO)|({{32{~GS[3]&~GS[2]&GS[1]&GS[0]}}&{32{L}}})|({32{~GS[3]&GS[2]}}&LO)|({32{~GS[3]&~GS[2]&GS[1]&~GS[0]}}&{32{N}});
endmodule