`timescale 1ns / 1ps

module Datapath (
    input [4:0] RD,RS1,RS2,
    input [31:0] IMM, Data_In,PC,
    input MD,MB,RW,MP,clk,reset,
    input [3:0] FS,
    input [2:0] funct3,
    output V,C,N,Z,L,
    output [31:0] RS1_out,Data_out,Addres_out
);

    wire [31:0] A,B,MuxB;
    wire [31:0] G,MuxD,MuxP;

    assign Addres_out = G;
    assign Data_out = B;
    assign RS1_out = A;
    assign MuxP = (MP == 1'b1) ? PC : A;

    Register_mem rm(.clk(clk),.reset(reset),.we0(RW),.wr_din0(MuxD),
    .rd_addr0(RS1),.wr_addr0(RD),.rd_addr1(RS2),.rd_dout0(A),.rd_dout1(B),.funct3(funct3));

    assign MuxB = (MB == 1'b0) ? B : IMM;

    FU fu(.A(MuxP),.B(MuxB),.FS(FS),.V(V),.C(C),.N(N),.Z(Z),.L(L),.G(G));

    assign MuxD = (MD == 1'b0 ) ? G : Data_In;

    
    
endmodule