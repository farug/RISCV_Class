module CU_pipe (
    input [31:0] RS1_in,
    input V,C,N,Z,L,
    input clk,reset,
    input stall, //from  stall unit
    input we0, // instruction memory
    input resetpc, // after loading instructions, reset the pc
    input [31:0] wr_din0, //instruction memory
    input [8:0] wr_addr0, // instruction memory
    input [6:0] opcode_in,
    input [2:0] funct3_in,
    input [6:0] Address_mem,
    input [31:0] IMM_in,PC_prev,
    output [31:0] PC,IMM,
    output MP,MB,MD,
    output [3:0] FS,STRB,
    output [4:0] RD,RS1,RS2,
    output RW,MW,
    output [2:0] funct3_out,
    output [6:0] opcode_out
);

    wire Branch;
    wire [31:0] Instruction;
    wire pcres;


    ProgramCounter pc(.clk(clk),.reset(resetpc),.stall(stall),.Branch(Branch),.opcode(opcode_in),
    .Imm(IMM_in),.RS1_in(RS1_in),.PC(PC),.PC_prev(PC_prev));

    BranchControl BC(.funct3(funct3_in),.V(V),.C(C),.N(N),.Z(Z),.L(L),
    .Branch(Branch));

    InstructionMem IM(.clk(clk),.reset(reset),.rd_addr0(PC[8:0]),
    .rd_dout0(Instruction),.we0(we0),.wr_din0(wr_din0),.wr_addr0(wr_addr0));

    InstructionDecoder ID(.Instruction(Instruction),.MW(MW),.RW(RW),.MD(MD),
    .MB(MB),.MP(MP),.FS(FS),.RD(RD),.RS1(RS1),.RS2(RS2),.opcode(opcode_out),
    .funct3(funct3_out),.Address_mem(Address_mem),.STRB(STRB));

    ImmGenerator Imm(.instruction(Instruction),.Imm(IMM));
endmodule