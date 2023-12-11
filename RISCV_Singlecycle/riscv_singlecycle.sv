`timescale 1ns / 1ps

module riscv_singlecycle 
#(DMemInitFile="",IMemInitFile="",LogFile="C:/Users/omer/Desktop/Dersler/MTH101E/Logfile.txt")
(
    input clk_i,
    input rst_ni,
    output [31:0] rf_data_hex // just for synthesis, otherwise the tools can remove everything for optimization
);

    wire [4:0] RD,RS1,RS2;
    wire [31:0] IMM,RS1_in;
    wire V,C,N,Z,L;
    wire [3:0] FS;
    wire MD,MB,MP;
    wire RW,MW;
    wire [31:0] Data_in,PC,Data_out,Addres_out;
    wire [3:0] STRB;
    wire [2:0] funct3;

    Datapath  dp(.RD(RD),.RS1(RS1),.RS2(RS2),.IMM(IMM),.Data_In(Data_in),.PC(PC),.MD(MD),
    .MB(MB),.RW(RW),.MP(MP),.clk(clk_i),.reset(rst_ni),.FS(FS),
    .V(V),.C(C),.N(N),.Z(Z),.L(L),.RS1_out(RS1_in),
    .Data_out(Data_out),.Addres_out(Addres_out),.funct3(funct3));

    CU #(.IMemInitFile(IMemInitFile)) cu(.RS1_in(RS1_in),.V(V),.C(C),.N(N),.Z(Z),.L(L),.clk(clk_i),.reset(rst_ni),.PC(PC),
    .IMM(IMM),.MP(MP),.MB(MB),.MD(MD),.FS(FS),.RD(RD),.RS1(RS1),
    .RS2(RS2),.RW(RW),.MW(MW),.STRB(STRB),.funct3(funct3),.Address_mem(Addres_out[8:0]));

    Data_mem #(.DMemInitFile(DMemInitFile)) dm(.clk(clk_i),.reset(rst_ni),.we0(MW),.wr_din0(Data_out),.wr_strb(STRB),.rd_strb(STRB),
    .rd_addr0(Addres_out[8:0]),.wr_addr0(Addres_out[8:0]),.rd_dout0(Data_in));

    assign rf_data_hex = RS1_in;

    // For log file
    int fd;

    always @(dp.rm.we0 & rst_ni & dm.we0) begin
        fd = $fopen(LogFile,"a");
        if(dp.rm.we0 ) begin
            $fwrite(fd,"x%0d 0x%16h\n",dp.rm.wr_addr0, dp.rm.wr_din0); // For byte and halfword instructions relevant bits must be considered
        end
        else if (dm.we0) begin
            $fwrite(fd,"mem 0x%h 0x%h", dm.wr_addr0, dm.wr_din0); // For byte and halfword instructions relevant bits must be considered
        end
        $fclose(fd);
    end
    
endmodule