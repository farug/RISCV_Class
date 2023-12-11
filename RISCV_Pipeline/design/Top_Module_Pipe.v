module Top_Module_Pipe (
    input clk,reset,we0,resetpc,
    input [8:0] wr_addr0,
    input [31:0] wr_din0,
    output [31:0] Data_in_o
);
    wire[31:0] Load_Use2,Load_Use3;
    wire [31:0] RS1_in,IMM_in,IMM,PC,Address_mem;
    wire V,C,Z,N,L;
    wire [6:0] opcode_in,opcode_out;
    wire [2:0] funct3_in,funct3_out;
    wire MP,MB,MD;
    wire [3:0] FS,STRB;
    wire [4:0] RD,RS1,RS2;
    wire RW,MW;

    wire RW4;
    wire [31:0] Data_path;
    wire [4:0] RD4;
    wire [31:0] PC_prev;
    wire [31:0] PC_prev_cu;
    wire [31:0] PC_prev_hazard;
    wire MPC;
    wire V_o,C_o,N_o,Z_o,L_o,reset_branch;
    wire [6:0] opcode_in2;

    assign opcode_in2 = (MPC == 1'b1) ? opcode_o : opcode_in;

    assign PC_prev_cu = (MPC == 1'b1) ? PC_prev_hazard : PC_prev;

    CU_pipe CUP(.clk(clk),.reset(reset),.resetpc(resetpc),.we0(we0),
    .wr_din0(wr_din0),.wr_addr0(wr_addr0),.stall(stall),
        .RS1_in(RS1_in),.V(V),.C(C),.N(N),.Z(Z),.L(L),
        .opcode_in(opcode_in2),.funct3_in(funct3_in),.Address_mem(Address_mem[6:0]),
        .IMM_in(IMM_in),.PC(PC),.IMM(IMM),
        .MP(MP),.MB(MB),.MD(MD),.FS(FS),.STRB(STRB),.RD(RD),.RS1(RS1),.RS2(RS2),
        .RW(RW),.MW(MW),.funct3_out(funct3_out),.opcode_out(opcode_out),
        .PC_prev(PC_prev_cu)
    );

    wire MP1,MB1,MD1,MW1,RW1;
    wire [3:0] FS1,STRB1;
    wire [4:0] RD1,RS11,RS21;
    wire [2:0] funct31;
    wire [6:0] opcode1;
    wire [31:0] IMM1,PC1;

    wire resetidex;
    wire resetifid;
    assign resetidex = idexreset&reset_jump2;
    assign resetifid = resetpc&reset_jump3&idexreset&reset_branch;

    IF_ID IFID(.clk(clk),.MP_in(MP),.MB_in(MB),.MD_in(MD),.MW_in(MW),.RW_in(RW),
    .FS_in(FS),.STRB_in(STRB),.RD_in(RD),.RS1_in(RS1),.RS2_in(RS2),
    .funct3_in(funct3_out),.opcode_in(opcode_out),.IMM_in(IMM),.PC_in(PC),
    .MP_out(MP1),.MB_out(MB1),.MD_out(MD1),.MW_out(MW1),.RW_out(RW1),.FS_out(FS1),
    .STRB_out(STRB1),.RD_out(RD1),.RS1_out(RS11),.RS2_out(RS21),
    .funct3_out(funct31),.opcode_out(opcode1),.IMM_out(IMM1),.PC_out(PC1),
    .reset(resetifid));


    wire [31:0] A,B;


    Register_mem RM(.clk(clk),.reset(resetpc),.we0(RW4),.wr_din0(Data_path),
    .rd_addr0(RS11),
    .wr_addr0(RD4),.rd_addr1(RS21),.rd_dout0(A),.rd_dout1(B));

    wire [31:0] A2,B2,IMM2,PC2;
    wire MP2,MB2,MD2,RW2,MW2;
    wire [3:0] STRB2,FS2;
    wire [4:0] RD2;
    wire [6:0] opcode2;
    wire [2:0] funct32;

    //signal for forwarding unit
    wire FW0_in,FW1_in,FW00_id,FW10_id,FW01_id,FW11_id,FW0_out,FW1_out;
    wire [4:0] RS22,RS12;
    wire [31:0] G_generate0,G_generate1;
    wire FW00_id_out,FW01_id_out,FW10_id_out,FW11_id_out,FW12_id,FW02_id,FW12_id_out,FW02_id_out;

    FW_Unit FW0(.RS1(RS11),.RS2(RS21),.RD(RD2),.FW0(FW00_id),
    .FW1(FW10_id),.RW(RW2));

    FW_Unit FW1(.RS1(RS11),.RS2(RS21),.RD(RD3),.FW0(FW01_id),
    .FW1(FW11_id),.RW(RW3));

    FW_Unit FW2(.RS1(RS11),.RS2(RS21),.RD(RD4),.FW0(FW02_id),
    .FW1(FW12_id),.RW(RW4));


    assign FW0_in = FW00_id|FW01_id|FW02_id;
    assign FW1_in = FW10_id|FW11_id|FW12_id;
    
    wire reset_jump2,reset_jump3;
    wire [6:0] opcode_o;

    jump_control jc1(.opcode(opcode3),.reset(reset_jump2));
    jump_control jc2(.opcode(opcode4),.reset(reset_jump3));

    

    Branch_Hazard BH(.V(V2),.C(C2),.N(C2),.Z(Z2),.L(L2),.opcode(opcode2),.PC(PC2),
    .MPC(MPC),.PC_prev(PC_prev_hazard),
    .V_o(V_o),.C_o(C_o),.N_o(N_o),.Z_o(Z_o),.L_o(L_o),.reset(reset_branch),.opcode_o(opcode_o));


    ID_EX IDEX(.clk(clk),.MP_in(MP1),.IMM_in(IMM1),.PC_in(PC1),.A_in(A),.B_in(B),
    .MB_in(MB1),.STRB_in(STRB1),.MD_in(MD1),.RW_in(RW1),.RD_in(RD1),.MW_in(MW1),
    .FS_in(FS1),.opcode_in(opcode1),.funct3_in(funct31),
    .FW0_in(FW0_in),.FW1_in(FW1_in),
    .FW00_id_in(FW00_id),.FW01_id_in(FW01_id),.FW10_id_in(FW10_id),
    .FW11_id_in(FW11_id),.RS2_in(RS21),.RS1_in(RS11),
    .FW02_in(FW02_id),.FW12_in(FW12_id),
    .MP_out(MP2),.IMM_out(IMM2),.PC_out(PC2),.A_out(A2),.B_out(B2),.MB_out(MB2),
    .STRB_out(STRB2),.MD_out(MD2),.RW_out(RW2),.RD_out(RD2),.MW_out(MW2),
    .FS_out(FS2),.opcode_out(opcode2),.funct3_out(funct32),
    .FW0_out(FW0_out),.FW1_out(FW1_out),
    .reset(resetidex),
    .FW00_id_out(FW00_id_out),.FW01_id_out(FW01_id_out),.FW10_id_out(FW10_id_out),
    .FW11_id_out(FW11_id_out),.RS2_out(RS22),.RS1_out(RS12),
    .FW02_id_out(FW02_id_out),.FW12_id_out(FW12_id_out));

    wire [31:0] G,Ap,Bp,Afw,Bfw;
    wire V2,C2,N2,Z2,L2;
    wire stall;
    wire idexreset;
    assign idexreset = resetpc & (~stall);

    stall_unit st(.RD(RD3),.RS1(RS1),.RS2(RS2),.MD(MD3),.reset(stall));

    G_Product GP0(.G1(G3),.G2(G4),.A(A),.B(B),.FW00(FW00_id_out),.FW10(FW10_id_out),
    .FW01(FW01_id_out),.FW11(FW11_id_out),.G_generate0(G_generate0),
    .FW02(FW02_id_out),.FW12(FW12_id_out),
    .G_generate1(G_generate1));

    wire [31:0] Load_Use0,Load_Use1;


    assign Afw = (MP2 == 1'b1) ? PC2 : Load_Use0; 
    assign Bfw = (MB2 == 1'b1) ? IMM2 : Load_Use1;

    

    assign Ap = (FW0_out == 1'b1) ? G_generate0 : A2; //Mux fw0
    assign Bp = (FW1_out == 1'b1) ? G_generate1 : B2; // Mux fw1


    FU fu(.FS(FS2),.A(Afw),.B(Bfw),.V(V2),.C(C2),.N(N2),.Z(Z2),.L(L2),.G(G));

    wire V3,C3,N3,Z3,L3;
    wire [31:0]G3,RS1_out3,Data_out3;
    wire [3:0] STRB3;
    wire MD3,RW3,MW3;
    wire [4:0] RD3,RS23,RS13;
    wire [6:0] opcode3;
    wire [2:0] funct33;
    wire [31:0] IMM3;
    wire [31:0] PC3;




    EX_MEM EXMEM(.clk(clk),.V_in(V2),.C_in(C2),.N_in(N2),.Z_in(Z2),.L_in(L2),.G_in(G),
    .RS1_out_in(Ap),.Data_out_in(Bp),.STRB_in(STRB2),.MD_in(MD2),.RD_in(RD2),  //Ap yerine a2 olabilir emin degilim kontrol et
    .RW_in(RW2),.MW_in(MW2),.opcode_in(opcode2),.funct3_in(funct32),.IMM_in(IMM2),
    .PC_in(PC2),.RS2_in(RS22),.RS1_in(RS12),
    .V_out(V3),.C_out(C3),.N_out(N3),.Z_out(Z3),.L_out(L3),.G_out(G3),
    .RS1_out_out(RS1_out3),.Data_out_out(Data_out3),
    .STRB_out(STRB3),.MD_out(MD3),.RD_out(RD3),.RW_out(RW3),.MW_out(MW3),
    .opcode_out(opcode3),.funct3_out(funct33),.IMM_out(IMM3),.PC_out(PC3),
    .reset(resetpc),.RS2_out(RS23),.RS1_out(RS13));

    wire [31:0] Data_out_mem,Data_in;
    wire FWD;


    MEM_MEM_MUX MMD(.RS2(RS23),.RD(RD4),.MW(MW3),.MD(MD4),.FWD(FWD));

    assign Data_in = (FWD == 1'b1) ? Data_out_mem4 : Data_out3 ; //Mem_mux

    Data_mem DM(.clk(clk),.reset(reset),.we0(MW3),.wr_din0(Data_in),
    .wr_strb(STRB3),.rd_addr0(G3[8:0]),.wr_addr0(G3[8:0]),
    .rd_dout0(Data_out_mem));

    wire [31:0] G4,Data_out_mem4,RS1_out4,IMM4;
    wire MD4,V4,C4,N4,Z4,L4;
    wire [6:0] opcode4;
    wire [2:0] funct34;
   wire [31:0] PC4,Load_Use00,Load_Use10;
   wire Flag0;

   Load_Use_Zero LU0(.RD(RD3),.RS1(RS12),.RS2(RS22),.Data_in(Data_out_mem),
   .Mux_FW_0(Ap),.Mux_FW_1(Bp),.MD(MD3),
   .Load_Use0(Load_Use00),.Load_Use1(Load_Use10),.Flag(Flag0));



    MEM_WB MEMWB(.clk(clk),.G_in(G3),.Data_out_in(Data_out_mem),
    .RS1_out_in(RS1_out3),.MD_in(MD3),.RW_in(RW3),
    .RD_in(RD3),.V_in(V3),.C_in(C3),.N_in(N3),.Z_in(Z3),.L_in(L3),
    .opcode_in(opcode3),.funct3_in(funct33),.IMM_in(IMM3),.PC_in(PC3),
    .G_out(G4),.Data_out_out(Data_out_mem4),.RS1_out_out(RS1_out4),
    .MD_out(MD4),.RW_out(RW4),.RD_out(RD4),
    .V_out(V4),.C_out(C4),.N_out(N4),.Z_out(Z4),.L_out(L4),.opcode_out(opcode4),
    .funct3_out(funct34),.IMM_out(IMM4),.PC_out(PC4),
    .reset(resetpc));

    wire [31:0] Load_Use01,Load_Use11,Load_Use02,Load_Use12;
    wire Flag1,Flag2;

    Load_Use_Zero LU1(.RD(RD4),.RS1(RS12),.RS2(RS22),.Data_in(Data_out_mem4),
   .Mux_FW_0(Ap),.Mux_FW_1(Bp),.MD(MD4),
   .Load_Use0(Load_Use01),.Load_Use1(Load_Use11),.Flag(Flag1));


   Load_Use_Zero LU2(.RD(RD4),.RS1(RS11),.RS2(RS21),.Data_in(Data_out_mem4),
   .Mux_FW_0(Ap),.Mux_FW_1(Bp),.MD(MD4),
   .Load_Use0(Load_Use02),.Load_Use1(Load_Use12),.Flag(Flag2));

   Load_Gen LG(.Flag0(Flag0),.Flag1(Flag1),.Load_Use00(Load_Use00),
   .Load_Use01(Load_Use01),.Load_Use10(Load_Use10),.Load_Use11(Load_Use11),
   .Load_Use02(Load_Use02),.Load_Use12(Load_Use12),.Flag2(Flag2),
   .Load_Use0(Load_Use0),.Load_Use1(Load_Use1),
   .Mux_FW_0(Ap),.Mux_FW_1(Bp));

    assign Data_path = (MD4 == 1'b1) ? Data_out_mem4 : G4;

    assign RS1_in = RS1_out4;
    assign V = (MPC == 1'b1) ? (V_o) :V4;
    assign C = (MPC == 1'b1) ? C_o : C4;
    assign N = (MPC == 1'b1) ? N_o : N4;
    assign Z = (MPC == 1'b1) ? Z_o : Z4;
    assign L = (MPC == 1'b1) ? L_o : L4;

    assign opcode_in = opcode4;
    assign funct3_in = funct34;

    assign Address_mem = G4;

    assign IMM_in = IMM4;

    assign PC_prev = PC4;
endmodule