`timescale 1ns / 1ps
module InstructionDecoder_tb ;
    reg [31:0] Instruction;
    reg [6:0] Address_mem;
    wire MW,RW,MD,MB,MP;
    wire [3:0] FS,STRB;
    wire [4:0] RD,RS1,RS2;
    wire [6:0] opcode;
    wire [2:0] funct3;

    InstructionDecoder Id(.Instruction(Instruction),.Address_mem(Address_mem),
    .MW(MW),.RW(RW),.MD(MD),.MB(MB),.MP(MP),.FS(FS),.RD(RD),.RS1(RS1),.RS2(RS2),
    .opcode(opcode),.funct3(funct3),.STRB(STRB));

    integer i;
    reg [31:0] inst [29:0];
    initial begin
        $readmemb("C:/Users/omer/Desktop/Okul/Dersler_22-23_2.half/EHB425E/HW-07/Verilog/design/true.true.txt",inst);
        for (i =0 ;i<30 ;i=i+1 ) begin
            Instruction = inst[i];
            Address_mem = i;
            #10;
        end
        $finish;
    end
endmodule