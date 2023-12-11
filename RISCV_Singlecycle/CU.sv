`timescale 1ns / 1ps

module CU #(IMemInitFile="")(
    input [31:0] RS1_in,
    input V,C,N,Z,L,
    input clk,reset,
    input we0,
    input [31:0] wr_din0,
    input [6:0] wr_addr0,
    input [8:0] Address_mem,
    output [31:0] PC,IMM,
    output MP,MB,MD,
    output [3:0] FS,
    output [4:0] RD,RS1,RS2,
    output RW,MW,
    output [3:0] STRB,
    output [2:0] funct3

); 
    wire [6:0] opcode;
    wire Branch;
    wire [31:0] Instruction;

    ProgramCounter pc(.clk(clk),.reset(reset),.Branch(Branch),.opcode(opcode),
    .Imm(IMM),.RS1_in(RS1_in),.PC(PC));

    BranchControl BC(.funct3(funct3),.V(V),.C(C),.N(N),.Z(Z),.L(L),.Branch(Branch));

    InstructionMem #(.IMemInitFile(IMemInitFile)) IM(.clk(clk),.reset(reset),.rd_addr0(PC),
    .rd_dout0(Instruction),.we0(we0),.wr_din0(wr_din0),.wr_addr0(wr_addr0));

    InstructionDecoder ID(.Instruction(Instruction),.MW(MW),.RW(RW),.MD(MD),.MB(MB),.MP(MP),
    .FS(FS),.RD(RD),.RS1(RS1),.RS2(RS2),.opcode(opcode),.funct3(funct3),.STRB(STRB),.Address_mem(Address_mem));

    ImmGenerator Imm(.instruction(Instruction),.Imm(IMM));


endmodule