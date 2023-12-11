`timescale 1ns / 1ps

module DP_DM_tb;

    reg clk,reset,MD,MB,RW,MP,MW;
    wire V,C,N,Z,L;
    reg [4:0] RD,RS1,RS2;
    reg [3:0] FS,STRB;
    reg [31:0] IMM,PC;
    wire [31:0] RS1_out;

    DP_DM dpdm(.clk(clk),.reset(reset),.RD(RD),.RS1(RS1),.RS2(RS2),.FS(FS),
    .STRB(STRB),.IMM(IMM),.PC(PC),.MD(MD),.MB(MB),.RW(RW),.MP(MP),
    .MW(MW),.V(V),.C(C),.N(N),.Z(Z),.L(L),.RS1_out(RS1_out));

    always begin
        clk = ~clk;
        #5;
    end

    initial begin
        clk =1'b1;
    end

    initial begin
        reset = 1'b0;
        #1;
        //positive C result
        reset=1'b1;
        // C =1
        RD=5'd1;
        RS1 = 5'd0;
        RS2 = 5'd0;
        FS = 4'b0000;
        STRB=4'b1111;
        IMM = 32'd1;
        PC = 32'd0;
        MD = 1'b0;
        MB = 1'b1;
        RW = 1'b1;
        MP = 1'b0;
        MW=1'b0;
        #10;
        //C=C+C
        RD=5'd1;
        RS1 = 5'd1;
        RS2 = 5'd1;
        FS = 4'b0000;
        STRB=4'b1111;
        IMM = 32'd1;
        PC = 32'd0;
        MD = 1'b0;
        MB = 1'b0;
        RW = 1'b1;
        MP = 1'b0;
        MW=1'b0;
        #10;
        // Load N
        RD=5'd2;
        RS1=5'd0;
        RS2=5'd0;
        FS=4'b0000;
        STRB=4'b1111;
        IMM = 32'd0;
        PC=32'd0;
        MD = 1'b1;
        MB=1'b1;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // C = C-N
        RD=5'd1;
        RS1=5'd1;
        RS2=5'd2;
        FS=4'b1000;
        STRB=4'b1111;
        IMM = 32'd0;
        PC=32'd0;
        MD = 1'b0;
        MB=1'b0;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // Load A
        RD=5'd3;
        RS1=5'd0;
        RS2=5'd0;
        FS=4'b0000;
        STRB=4'b1111;
        IMM = 32'd1;
        PC=32'd0;
        MD = 1'b1;
        MB=1'b1;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // C = C+A
        RD=5'd1;
        RS1=5'd1;
        RS2=5'd3;
        FS=4'b0000;
        STRB=4'b1111;
        IMM = 32'd1;
        PC=32'd0;
        MD = 1'b0;
        MB=1'b0;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // C = C-N
        RD=5'd1;
        RS1=5'd1;
        RS2=5'd2;
        FS=4'b1000;
        STRB=4'b1111;
        IMM = 32'd0;
        PC=32'd0;
        MD = 1'b0;
        MB=1'b0;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;

        reset = 1'b1;
        #1;
        //negative C result
        reset=1'b1;
        // C =1
        RD=5'd1;
        RS1 = 5'd0;
        RS2 = 5'd0;
        FS = 4'b0000;
        STRB=4'b1111;
        IMM = 32'd1;
        PC = 32'd0;
        MD = 1'b0;
        MB = 1'b1;
        RW = 1'b1;
        MP = 1'b0;
        MW=1'b0;
        #10;
        //C=C+C
        RD=5'd1;
        RS1 = 5'd1;
        RS2 = 5'd1;
        FS = 4'b0000;
        STRB=4'b1111;
        IMM = 32'd1;
        PC = 32'd0;
        MD = 1'b0;
        MB = 1'b0;
        RW = 1'b1;
        MP = 1'b0;
        MW=1'b0;
        #10;
        // Load N
        RD=5'd2;
        RS1=5'd0;
        RS2=5'd0;
        FS=4'b0000;
        STRB=4'b1111;
        IMM = 32'd2;
        PC=32'd0;
        MD = 1'b1;
        MB=1'b1;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // C = C-N
        RD=5'd1;
        RS1=5'd1;
        RS2=5'd2;
        FS=4'b1000;
        STRB=4'b1111;
        IMM = 32'd0;
        PC=32'd0;
        MD = 1'b0;
        MB=1'b0;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // Load A
        RD=5'd3;
        RS1=5'd0;
        RS2=5'd0;
        FS=4'b0000;
        STRB=4'b1111;
        IMM = 32'd3;
        PC=32'd0;
        MD = 1'b1;
        MB=1'b1;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // C = C+A
        RD=5'd1;
        RS1=5'd1;
        RS2=5'd3;
        FS=4'b0000;
        STRB=4'b1111;
        IMM = 32'd1;
        PC=32'd0;
        MD = 1'b0;
        MB=1'b0;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // C = C-N
        RD=5'd1;
        RS1=5'd1;
        RS2=5'd2;
        FS=4'b1000;
        STRB=4'b1111;
        IMM = 32'd0;
        PC=32'd0;
        MD = 1'b0;
        MB=1'b0;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;

        // C Zero Result
        // C =1
        RD=5'd1;
        RS1 = 5'd0;
        RS2 = 5'd0;
        FS = 4'b0000;
        STRB=4'b1111;
        IMM = 32'd1;
        PC = 32'd0;
        MD = 1'b0;
        MB = 1'b1;
        RW = 1'b1;
        MP = 1'b0;
        MW=1'b0;
        #10;
        //C=C+C
        RD=5'd1;
        RS1 = 5'd1;
        RS2 = 5'd1;
        FS = 4'b0000;
        STRB=4'b1111;
        IMM = 32'd1;
        PC = 32'd0;
        MD = 1'b0;
        MB = 1'b0;
        RW = 1'b1;
        MP = 1'b0;
        MW=1'b0;
        #10;
        // Load N
        RD=5'd2;
        RS1=5'd0;
        RS2=5'd0;
        FS=4'b0000;
        STRB=4'b1111;
        IMM = 32'd4;
        PC=32'd0;
        MD = 1'b1;
        MB=1'b1;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // C = C-N
        RD=5'd1;
        RS1=5'd1;
        RS2=5'd2;
        FS=4'b1000;
        STRB=4'b1111;
        IMM = 32'd0;
        PC=32'd0;
        MD = 1'b0;
        MB=1'b0;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // Load A
        RD=5'd3;
        RS1=5'd0;
        RS2=5'd0;
        FS=4'b0000;
        STRB=4'b1111;
        IMM = 32'd5;
        PC=32'd0;
        MD = 1'b1;
        MB=1'b1;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // C = C+A
        RD=5'd1;
        RS1=5'd1;
        RS2=5'd3;
        FS=4'b0000;
        STRB=4'b1111;
        IMM = 32'd1;
        PC=32'd0;
        MD = 1'b0;
        MB=1'b0;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #10;
        // C = C-N
        RD=5'd1;
        RS1=5'd1;
        RS2=5'd2;
        FS=4'b1000;
        STRB=4'b1111;
        IMM = 32'd0;
        PC=32'd0;
        MD = 1'b0;
        MB=1'b0;
        RW=1'b1;
        MP=1'b0;
        MW=1'b0;
        #13;
        $finish;
    end



endmodule